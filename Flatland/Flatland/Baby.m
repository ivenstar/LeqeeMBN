//
//  Baby.m
//  Flatland
//
//  Created by Manuel Ohlendorf on 03.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "Baby.h"
#import "RESTService.h"

@implementation Baby
- (id)initWithJSONObject:(id)JSONObject {
    self = [self init];
    if (self) {
        _ID = StringFromJSONObject([JSONObject valueForKey:@"id"]);
        _name = StringFromJSONObject([JSONObject valueForKey:@"name"]);
        _pictureURL = StringFromJSONObject([JSONObject valueForKey:@"imageURL"]);
        _birthday = DateFromJSONValue([JSONObject valueForKey:@"birthday"]);
    }
    return self;
}

- (id) data {
    NSString *gender = @"";
    if(self.gender == GenderMale) {
        gender = @"male";
    } else if (self.gender == GenderFemale) {
        gender = @"female";
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    
    return @{@"firstname": self.name,
             @"gender": gender,
             @"weight": [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:self.weight / 1000.0]],
             @"birthday": [dateFormat stringFromDate:self.birthday]};   
}

- (void)save:(void (^)(BOOL))completion {
    if(self.ID == nil) {
        [[RESTService sharedService]
         queueRequest:[RESTRequest postURL:@"/create/baby" object:[self data]]
         completion:^(RESTRequest *request) {
             if (request.statusCode == 200 && [[request.object valueForKey:@"success"] boolValue]) {
                 //update the ID value
                 self.ID = StringFromJSONObject([request.object valueForKey:@"babyId"]);
                 completion(YES);
             } else {
                 completion(NO);
             }
         }];
    }
}
@end
