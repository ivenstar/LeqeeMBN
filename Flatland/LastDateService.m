//
//  LastDateService.m
//  Flatland
//
//  Created by Pirlitu Vasilica on 1/13/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import "LastDateService.h"
#import "RESTService.h"


@implementation LastDateService
static LastDateService*sharedInstance = nil;

+ (LastDateService *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

- (void) loadLastDate:(Baby *)baby
{
    NSString *url = [[NSString alloc] initWithFormat:@"%@",WS_getLastEventDate];
    //NSLog(@"URL:::%@",url);
    //NSLog(@"URL:::%@",baby.ID);
    if (baby.ID)
    [[RESTService sharedService] queueRequest:[RESTRequest postURL:url object:@{@"babyId" :baby.ID}] completion:^(RESTResponse *response) {
        if(response.statusCode == 200)
        {
            NSLog(@"%@",response.object);
            _feedings = [[LastDateFeedings alloc] initWithJSONObject:response.object];
            NSLog(@"%@",_feedings.lastBottleFeedDate);

        }
        else
        {
            
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WidgetsHadChangedNotification" object:nil];
    }];
}

@end
