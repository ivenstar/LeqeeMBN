//
//  TimelineService.m
//  Flatland
//
//  Created by Bogdan Chitu on 18/04/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "TimelineService.h"

#import "WsApiList.h"

#import "RESTService.h"

#import "Globals.h"

#import "TimelineEntryJournal.h"
#import "TimelineEntryMood.h"
#import "TimelineEntryPhoto.h"
#import "TimelineEntryBirthDay.h"
#import "TimelineEntryFeeding.h"
#import "TimelineEntryWeight.h"

@implementation TimelineService

+ (id) dataForTimelineGet:(NSString*) babyID date:(NSDate*)date entriesPerPage:(NSUInteger) entriesPerPage
{
    return  @{
             @"baby_id" : babyID,
             @"timestamp" : JSONValueFromDate(date),
             @"size" : [NSString stringWithFormat:@"%i",entriesPerPage]
             };
}

+ (void)getEntriesForBaby:(Baby*)baby withDate:(NSDate*)date andEntriesPerPage:(NSUInteger)entriesPerPage completion:(void (^)(NSArray *entries,NSTimeInterval lastTimeStamp))completion
{
    if (!baby)
    {
        completion(nil,-2);
        return;
    }
    
    RESTRequest *postRequest = [RESTRequest postURL:WS_timelineGet object:[self dataForTimelineGet:baby.ID date:date entriesPerPage:entriesPerPage]];
    [[RESTService sharedService] queueRequest:postRequest completion:^(RESTResponse *response)
    {
        if(response.statusCode == 200)
        {
            NSArray* data = ArrayFromJSONObject(response.object[@"data"]);
            
            NSString* timeStampString = response.object[@"lastTimestamp"];
            NSTimeInterval lastTimeStamp = (id)timeStampString == [NSNull null] ? -1 : [timeStampString doubleValue];
            
            __block int images = 0;
            
            NSMutableArray *entries = [[NSMutableArray alloc] init];
            for (NSDictionary *dataDictionary in data)
            {
                TimelineEntry *entry = [self entryFromDataDictinoary:dataDictionary];
                if (nil != entry)
                {
                    [entries addObject:entry];
                }
                
                if ([entry isKindOfClass:[TimelineEntryPhoto class]])
                {
                    images++;
                }
            }
            
            if (images > 0)
            {
                for (TimelineEntry* entry in entries)
                {
                    if ([entry isKindOfClass:[TimelineEntryPhoto class]])
                    {
                        // start new request
                        [[RESTService sharedService] queueImageRequest:[(TimelineEntryPhoto*)entry pictureUrl] completionWithNil:^(UIImage *image)
                        {
                            [(TimelineEntryPhoto*)entry setImage:image];
                            images--;
                            
                            if (images == 0)
                            {
                                completion(entries,lastTimeStamp);
                            }
                        }];
                    }
                }
            }
            else
            {
                completion(entries,lastTimeStamp);
            }
        }
        else
        {
            completion(nil,-2);
        }
    }];
}

+ (TimelineEntry*) entryFromDataDictinoary :(NSDictionary*) dataDictionary
{
    TimelineEntry* entry = nil;
    NSString* dataType = [dataDictionary valueForKey:@"type"];
    
    if ([dataType isEqualToString:@"journal"])
    {
        TimelineEntryJournal *journalEntry = [[TimelineEntryJournal alloc] init];
        journalEntry.title = StringFromJSONObject([dataDictionary objectForKey:@"title"]);
        journalEntry.comment = StringFromJSONObject([dataDictionary objectForKey:@"description"]);
        
        entry = journalEntry;
    }
    else if ([dataType isEqualToString:@"mood"])
    {
        TimelineEntryMood *moodEntry = [[TimelineEntryMood alloc] init];
        moodEntry.title = StringFromJSONObject([dataDictionary objectForKey:@"title"]);
        moodEntry.mood = 1;//TODO ..real value
        moodEntry.comment = StringFromJSONObject([dataDictionary objectForKey:@"description"]);
        
        entry = moodEntry;
    }
    else if ([dataType isEqualToString:@"photo"])
    {
        TimelineEntryPhoto *photoEntry = [[TimelineEntryPhoto alloc] init];
        photoEntry.title = StringFromJSONObject([dataDictionary objectForKey:@"title"]);
        photoEntry.comment = StringFromJSONObject([dataDictionary objectForKey:@"description"]);
        photoEntry.pictureUrl = StringFromJSONObject([dataDictionary objectForKey:@"image"]);
        
        entry = photoEntry;
    }
    else if ([dataType isEqualToString:@"birthday"])
    {
        TimelineEntryBirthDay *birthDayEntry = [[TimelineEntryBirthDay alloc] init];
        birthDayEntry.title = StringFromJSONObject([dataDictionary objectForKey:@"description"]);
        
        entry = birthDayEntry;
    }
    else if ([dataType isEqualToString:@"feedingbootle"] || [dataType isEqualToString:@"breastfeedingbottle"])
    {
        TimelineEntryFeeding *feedingEntry = [[TimelineEntryFeeding alloc] init];
        feedingEntry.title = StringFromJSONObject([dataDictionary objectForKey:@"description"]);
        
        entry = feedingEntry;
    }
    else if ([dataType isEqualToString:@"weight"])
    {
        TimelineEntryWeight *weightEntry = [[TimelineEntryWeight alloc] init];
        weightEntry.title = StringFromJSONObject([dataDictionary objectForKey:@"description"]);
        
        entry = weightEntry;
    }
    
    entry.date = DateWithoutTimezoneFromJSONValue([dataDictionary objectForKey:@"time"]);
    
    return entry;
}

+ (void) saveEntry:(TimelineEntry*) entry forBaby:(Baby*)baby completion:(void (^)(BOOL success, NSArray* errors))completion
{
    if (baby != nil && baby.ID != nil)
    {
        NSDictionary *entryData = [entry data];
        [entryData setValue:baby.ID forKey:@"baby_id"];
        
        [[RESTService sharedService]
         queueRequest:[RESTRequest postURL:WS_timelineCreate object:entryData]
         completion:^(RESTResponse *response) {
             if (response.success)
             {
                 completion (YES,nil);
             } else
             {
                 NSMutableArray *errors = [NSMutableArray new];
                 completion(NO, errors);
             }
         }];
    }
    else
    {
        NSMutableArray *errors = [NSMutableArray new];
        completion(NO,errors);
    }
}

+ (void) savePhotoEntry: (TimelineEntryPhoto*) photoEntry forBaby: (Baby*) baby withCompletion:(void (^)(BOOL success))uploadCompletion
{
    //if we have picture data upload them
    if (photoEntry.image)
    {
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        
        NSMutableData *body = [NSMutableData data];
        
        //TYPE
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"type\"; \r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"photo \r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        //BABY ID
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"baby_id\"; \r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n",baby.ID] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //TIME
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"time\"; \r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n",JSONValueFromDate(photoEntry.date)] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //TITLE
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"title\"; \r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n",photoEntry.title] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //DESCRIPTION
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"description\"; \r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n",photoEntry.comment] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //IAMGE
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"files\"; filename=\"files.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSString* dataString2 = [[NSString alloc] initWithBytes:[body bytes] length:body.length encoding:NSUTF8StringEncoding];
        
        NSLog(@"\n\n%@",dataString2);
        
        [body appendData:[NSData dataWithData:UIImagePNGRepresentation(photoEntry.image)]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        NSData* pictureData = [[NSData alloc] initWithData:body];
        
        
        
        NSString *url = WS_timelineCreate;
        
        [[RESTService sharedService] queueRequest:[RESTRequest uploadURL:url data:pictureData mimeType:contentType] completion:^(RESTResponse *response)
         {
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


@end
