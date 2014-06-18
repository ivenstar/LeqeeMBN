//
//  Baby.m
//  Flatland
//
//  Created by Manuel Ohlendorf on 03.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//  TODO: save feedingPreferences as soon as rest-service available
//

#import "Baby.h"
#import "RESTService.h"
#import "Message.h"
#import "User.h"
#import "Capsule.h"

#define kSecondsInMonth 2419200

NSString *const WithingsChangedNotification = @"WithingsChangedNotification";

@interface Baby()

@end


@implementation Baby {
    NSMutableArray *_imageLoadingBlocks;
}

- (id)initWithJSONObject:(id)JSONObject {
    self = [self init];
    if (self)
    {
        [self updateWithJSONObject:JSONObject];
    }
    return self;
}

- (void) setWithingsEnabled:(BOOL)withingsEnabled
{
    _withingsEnabled = withingsEnabled;
    [[NSNotificationCenter defaultCenter] postNotificationName:WithingsChangedNotification object:nil];
}

- (void)updateWithJSONObject:(id)JSONObject {
    _ID = StringFromJSONObject([JSONObject valueForKey:@"id"]);
    _name = StringFromJSONObject([JSONObject valueForKey:@"name"]);
    _pictureURL = StringFromJSONObject([[JSONObject valueForKey:@"imageUrl"] stringByReplacingOccurrencesOfString:@"%D" withString:@"200"]);
    _capsuleSize = StringFromJSONObject([JSONObject valueForKey:@"capsuleSize"]);
    _capsuleType = StringFromJSONObject([JSONObject valueForKey:@"capsuleType"]);
    _capsuleImage = StringFromJSONObject([JSONObject valueForKey:@"capsuleImageUrl"]);
    _birthday = DateFromJSONValue([JSONObject valueForKey:@"birthday"]);
    _weight = StringFromJSONObject([JSONObject valueForKey:@"weight"]).doubleValue * 1000.0;
    NSString *gender = StringFromJSONObject([JSONObject valueForKey:@"gender"]);
    if ([gender isEqualToString:@"Male"]) {
        _gender = GenderMale;
    } else if ([gender isEqualToString:@"Female"]) {
        _gender = GenderFemale;
    } else {
        _gender = GenderNone;
    }
    _feedingPreferences = StringFromJSONObject([JSONObject valueForKey:@"feedingPreferences"]);
    _preganatWithThisBaby = [StringFromJSONObject([JSONObject valueForKey:@"pregnant"]) boolValue];
    _withingsEnabled = [StringFromJSONObject([JSONObject valueForKey:@"withingsEnabled"]) boolValue];
    
}

- (id)data {
    NSString *gender = @"";
    if (self.gender == GenderMale) {
        gender = @"Male";
    } else if (self.gender == GenderFemale) {
        gender = @"Female";
    }

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];

    return @{@"id" : self.ID ? self.ID : @"",
             @"firstName" : self.name,
             @"gender" : gender,
             @"weight" : [NSNumber numberWithDouble:self.weight / 1000.0],
             @"birthday" : self.birthday ? [dateFormat stringFromDate:self.birthday] : @"",
             @"capsuleSize" : _capsuleSize,
             @"pregnant" : [NSString stringWithFormat:@"%i",self.preganatWithThisBaby]
             };
}

- (id)nonCamelData {
    NSString *gender = @"";
    if (self.gender == GenderMale) {
        gender = @"Male";
    } else if (self.gender == GenderFemale) {
        gender = @"Female";
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    
    return @{@"id" : self.ID ? self.ID : @"",
             @"firstname" : self.name,
             @"gender" : gender,
             @"weight" : [NSNumber numberWithDouble:self.weight / 1000.0],
             @"birthday" : self.birthday ? [dateFormat stringFromDate:self.birthday] : @"",
             @"capsuleSize" : _capsuleSize};
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[Baby class]])
        return NO;
    return [self isEqualToBaby:other];
}

- (NSUInteger)hash {
    return [self.ID hash];
}

- (BOOL)isEqualToBaby:(Baby *)aBaby {
    if (self == aBaby)
        return YES;
    if (![(id)[self ID] isEqualToString:aBaby.ID])
        return NO;
    return YES;
}

- (UIImage *)downscaledPicture {
    CGSize newSize = CGSizeMake(195, 195);
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = self.picture.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    return newImage;
}


/// upload the image if neccessary
- (void)uploadImage:(void (^)(BOOL success))uploadCompletion {
    //if we have picture data upload them
    if (self.picture) {
        _cachedImage = self.picture;
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"files\"; filename=\"files.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:UIImagePNGRepresentation(self.downscaledPicture)]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];

        
        NSData* pictureData = [[NSData alloc] initWithData:body]; //
        
        NSString *url = [NSString stringWithFormat:WS_babyImageUpload, self.ID];
        
        
        [[RESTService sharedService] queueRequest:[RESTRequest uploadURL:url data:pictureData mimeType:contentType] completion:^(RESTResponse *response) {
            if(response.error) {
                uploadCompletion(NO);
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBabyViews" object:nil];
                uploadCompletion(YES);
            }
        }];
    } else { 
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBabyViews" object:nil];
        uploadCompletion(YES);
    }
}

- (void)save:(void (^)(BOOL, NSArray*))completion {
    
    //save the new baby
    if (self.ID == nil) {
        NSLog(@"sinri debug 0529 baby-save id is nil");
        [[RESTService sharedService]
         queueRequest:[RESTRequest postURL:WS_createBaby object:[self nonCamelData]]
         completion:^(RESTResponse *response) {
             NSLog(@"sinri debug 0529 baby-save rest service response code=%i ",response.statusCode);
             if (response.success) {
                 NSLog(@"sinri debug 0529 baby-save rest service response success ");
                 NSLog(@"I am trying to see the object: %p=%@",response.object,response.object);
                 //update the ID value
                 self.ID = StringFromJSONObject([response.object valueForKey:@"babyId"]);
                 //now upload the image if needed
                 
                 [self uploadImage:^(BOOL uploadSuccess) {
                     //update the local data with the server data
                     [self refreshWithCompletion:^(BOOL refreshSuccess) {
                         //add the new baby to the acive accout
                         [[User activeUser] addBaby:self];
                         //igonre the result of the update and use the image upload result instead
                         completion(uploadSuccess, nil);
                     }];
                 }];
             } else {
                 NSLog(@"sinri debug 0529 baby-save rest service response error");
                 NSMutableArray *errors = [NSMutableArray new];
                 completion(NO, errors);
             }
         }];
    } else { //update the baby
        [[RESTService sharedService] queueRequest:[RESTRequest postURL:WS_updateBaby object:[self data]] completion:^(RESTResponse *response) {
            if (response.success) {
                
                
                NSLog(@"%@",response.object);
                
                //now upload the image if needed
                [self uploadImage:^(BOOL success) {
                    if (success) {
                        [self refreshWithCompletion:^(BOOL refreshSuccess) {
                            //add the new baby to the acive accout
                        [[User activeUser] updateBaby:self];
                            //igonre the result of the update and use the image upload result instead
                            completion(success, nil);
                        }];
                        completion(YES, nil);
                    } else {
                        completion(NO, nil);
                    }
                }];
            } else {
                NSMutableArray *errors = [NSMutableArray new];
                completion(NO, errors);
            }
        }];
    }
}

- (void)refreshWithCompletion:(void (^)(BOOL))updateCompletion {
    NSString* url = [NSString stringWithFormat:WS_babiesID, self.ID];

    [[RESTService sharedService] queueRequest:[RESTRequest getURL:url] completion:^(RESTResponse *response) {
        if (!response.error) {
            [self updateWithJSONObject:response.object];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBabyViews" object:nil];
            updateCompletion(YES);
        } else {
            updateCompletion(NO);
        }
    }];
}

- (void)loadPictureWithCompletion:(void (^)(UIImage *))completion {
    if (_cachedImage) {
        completion(_cachedImage);
    } else {
        // start a request if we have no image and no qued blocks
        if (!_imageLoadingBlocks) {
            _imageLoadingBlocks = [NSMutableArray new];
        }
            // start new request
            [[RESTService sharedService] queueImageRequest:self.pictureURL completion:^(UIImage *image) {
                _cachedImage = image;
                // inform all the blocks
                for (void (^ cmpl)(UIImage *) in _imageLoadingBlocks) {
                    cmpl(image);
                }
                // and nil it...
                _imageLoadingBlocks = nil; 
            }];
        }
        // add completion block to blocks
        [_imageLoadingBlocks addObject:completion];
}

- (void)loadMessages:(void (^)(BOOL))completion {
    NSString* url = [NSString stringWithFormat:WS_babyMessages, _ID];
    [[RESTService sharedService] queueRequest:[RESTRequest getURL:url] completion:^(RESTResponse *response) {
        if(!response.error) {
            NSArray *messageArray = ArrayFromJSONObject(response.object);
            NSMutableArray *messages = [[NSMutableArray alloc] initWithCapacity:messageArray.count];
            for (id object in messageArray) {
                NotificationMessage *msg = [[NotificationMessage alloc] initWithJSONObject:object];
                if([_ID isEqualToString:[object objectForKey:@"authorId"]]) {
                    [msg setResponse:NO];
                    [messages addObject:msg];
                }else{
                    [msg setResponse:YES];
                    [messages addObject:msg];
                }
                _messages = [messages copy];
            }
            completion(YES);
        } else {
            completion(NO);
        }
    }];
}

- (void)remove:(void (^)(BOOL))completion {
    if(!self.ID) {
        return;
    }
    
    [[RESTService sharedService]
     //queueRequest:[RESTRequest postURL:[NSString stringWithFormat:WS_deleteBaby, self.ID] object:nil]
     queueRequest:[RESTRequest getURL:[NSString stringWithFormat:WS_deleteBaby, self.ID]]
     completion:^(RESTResponse *response) {
         if (response.success) {
             [[User activeUser] removeBaby:self];
             completion(YES);
         } else {
             completion(NO);
         }
     }];
}

- (Capsule *)capsuleForDate:(NSDate *)date {
    NSTimeInterval age = [date timeIntervalSinceDate:self.birthday];
     Capsule *c = [Capsule new];
     if (age < kSecondsInMonth) {
         c = [Capsule capsuleForType:@"FirstMonth"];
     } else if(age < kSecondsInMonth*2) {
         c = [Capsule capsuleForType:@"SecondMonth"];
     } else if(age < kSecondsInMonth*6) {
         c = [Capsule capsuleForType:@"ThirdToSixthMonth"];
     } else if(age < kSecondsInMonth*12) {
         c = [Capsule capsuleForType:@"SeventhToTwelfthMonth"];
     } else if(age < kSecondsInMonth*24) {
         c = [Capsule capsuleForType:@"ThirteenthToTwentyFourthMonth"];
     } else {
         c = [Capsule capsuleForType:@"TwentyFifthMonthToThirtySixthMonth"];
     }

    return c;
}

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        
        [copy setGender:self.gender];
        [copy setID:[self.ID copyWithZone:zone]];
        [copy setName:[self.name copyWithZone:zone]];
        [copy setPictureURL:[self.pictureURL copyWithZone:zone]];
        [copy setCapsuleImage:[self.capsuleImage copyWithZone:zone]];
        [copy setCapsuleSize:[self.capsuleSize copyWithZone:zone]];
        [copy setCapsuleType:[self.capsuleType copyWithZone:zone]];
        [copy setPicture:[UIImage imageWithCGImage:self.picture.CGImage]];
        [copy setBirthday:[self.birthday copyWithZone:zone]];
        [copy setWeight:self.weight];
        [copy setMessages:[self.messages copyWithZone:zone]];
        [copy setFeedingPreferences:[self.feedingPreferences copyWithZone:zone]];
        [copy setCachedImage:[UIImage imageWithCGImage:self.cachedImage.CGImage]];
        [copy setIsEdited:self.isEdited];
    }
    
    return copy;
}

@end
