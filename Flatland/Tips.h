//
//  Tips.h
//  Flatland
//
//  Created by Magdalena Kamrowska on 30.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tip : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, retain) NSNumber *week;
@property (nonatomic, retain) NSNumber *ageStep;

- (id)initWithJSONObject:(id)object;

@end

@interface Tips : NSObject

@property (nonatomic, retain) NSArray *tipsArray;

+ (Tips *)sharedTips;

- (int)count;

- (Tip *)tipAtIndex:(int)index;

- (Tip *)tipForWeek:(NSNumber *)week;

@end
