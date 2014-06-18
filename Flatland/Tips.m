//
//  Tips.m
//  Flatland
//
//  Created by Magdalena Kamrowska on 30.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "Tips.h"

@implementation Tip

- (id)initWithJSONObject:(id)object {
    self = [super init];
    if(self) {
        _title = [object objectForKey:@"title"];
        _text = [object objectForKey:@"text"];
        _ageStep = [object objectForKey:@"ageStep"];
        _week = [object objectForKey:@"week"];
    }
    return self;
}

@end

@implementation Tips

static Tips* tips = nil;

+ (Tips *)sharedTips {
    if(!tips) {
        tips = [Tips new];
        [tips readJSON];
    }
    return tips;
}

- (BOOL)validateJSON {
    return YES;
}

- (void)readJSON {
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"tips" ofType:@"json"];
    NSString *myJSON = [[NSString alloc] initWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:NULL];
    NSDictionary *tipsJSON =  [NSJSONSerialization JSONObjectWithData:[myJSON dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    NSArray *tipsArray = [tipsJSON objectForKey:@"tips"];
    NSMutableArray *tips = [[NSMutableArray alloc] initWithCapacity:[tipsArray count]];
    for(id tip in tipsArray) {
        [tips addObject:[[Tip alloc] initWithJSONObject:tip]];
    }
    _tipsArray = [tips copy];
}

- (void)refreshJSON {

}

- (int)count {
    return [_tipsArray count];
}

- (Tip *)tipAtIndex:(int)index {
    return [_tipsArray objectAtIndex:index];
}

- (Tip *)tipForWeek:(NSNumber *)week {
    for(Tip *tip in _tipsArray) {
        if([tip.week isEqualToNumber:week]) {
            return tip;
        }
    }
    return  nil;
}

@end
