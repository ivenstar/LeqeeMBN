//
//  Message.h
//  Flatland
//
//  Created by Magdalena Kamrowska on 17.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationMessage : NSObject

@property (nonatomic, copy) NSString *babyMessage;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic) BOOL response;

-(id)initWithJSONObject:(id)object;

@end
