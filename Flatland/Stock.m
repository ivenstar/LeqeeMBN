//
//  Stock.m
//  Flatland
//
//  Created by Stefan Aust on 13.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "Stock.h"
#import "RESTService.h"

static NSString * const kStockChanged = @"StockChanged";

@implementation Stock

/// loads the stock from the sever; passes either a new Stock instance or nil on errors
+ (void)get:(void (^)(Stock *))callback {
    [[RESTService sharedService]
     queueRequest:[RESTRequest getURL:WS_capsuleStock]
     completion:^(RESTResponse *response) {
         if (response.success) {
             callback([[Stock alloc] initWithJSONValue:response.object]);
         } else {
             callback(nil);
         }
     }];
}

/// initializes a new instance with the given JSON value
- (id)initWithJSONValue:(id)JSONValue {
    self = [self init];
    if (self) {
        NSMutableArray *stockItems = [NSMutableArray new];
        NSArray *keys = [JSONValue allKeys];
        for(NSString *key in keys) {
            if(![key isEqualToString:@"success"] && ![key isEqualToString:@"message"] && ![key isEqualToString:@"totalCapsules"]) {
                StockItem *item = [StockItem new];
                if([key isEqualToString:@"firstMonthMaxi"]) {
                    item.type = @"FirstMonth";
                    item.size = @"Large";
                } else if([key isEqualToString:@"firstMonthStandard"]) {
                    item.type = @"FirstMonth";
                    item.size = @"Small";
                } else if([key isEqualToString:@"secondMonthMaxi"]) {
                    item.type = @"SecondMonth";
                    item.size = @"Large";
                } else if([key isEqualToString:@"secondMonthStandard"]) {
                    item.type = @"SecondMonth";
                    item.size = @"Small";
                } else if([key isEqualToString:@"thirdToSixthMonthMaxi"]) {
                    item.type = @"ThirdToSixthMonth";
                    item.size = @"Large";
                } else if([key isEqualToString:@"thirdToSixthMonthStandard"]) {
                    item.type = @"ThirdToSixthMonth";
                    item.size = @"Small";
                } else if([key isEqualToString:@"seventhToTwelfthMonth"]) {
                    item.type = @"SeventhToTwelfthMonth";
                    item.size = @"Small";
                } else if([key isEqualToString:@"thirteenthToTwentyFourthMonth"]) {
                    item.type = @"ThirteenthToTwentyFourthMonth";
                    item.size = @"Small";
                } else if([key isEqualToString:@"twentyFifthMonthToThirtySixthMonth"]) {
                    item.type = @"TwentyFifthMonthToThirtySixthMonth";
                    item.size = @"Small";
                } else if([key isEqualToString:@"sensitive"]) {
                    item.type = @"Sensitive";
                    item.size = @"Small";
                }
                item.count = ((NSNumber *)JSONValue[key]).integerValue;
                [stockItems addObject:item];
            }
        }

        self.stockItems = stockItems;
        
        self.capsulesLeft = 0;
        for (StockItem *item in stockItems)
        {
            self.capsulesLeft += item.count;
        }
        
//        self.capsulesLeft = ((NSNumber*)JSONValue[@"totalCapsules"]).integerValue;
    }
    return self;
}

/// returns the receiver as JSON value suitable for saving it to the server
- (id)JSONValue {
    NSMutableDictionary *stockItems = [NSMutableDictionary new];
    for (StockItem *stockItem in self.stockItems) {
        NSString *firstLetter = [[stockItem.type substringToIndex:1] lowercaseString];
        NSString *type = [stockItem.type stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstLetter];
        NSString *size;
        if([stockItem.type hasSuffix:@"ThirdToSixthMonth"] || [stockItem.type hasSuffix:@"FirstMonth"] || [stockItem.type hasSuffix:@"SecondMonth"]) {
            size = ([stockItem.size isEqualToString:@"Small"] ? @"Standard" : @"Maxi");
        } else {
            size = @"";
        }
        NSString *name = [NSString stringWithFormat:@"%@%@", type, size];
        [stockItems setObject:@(stockItem.count) forKey:name];
    }
    return stockItems;
}

/// saves the receiver to the server; passes YES on success and NO on errors
- (void)save:(void (^)(BOOL))callback {
    [[RESTService sharedService]
     queueRequest:[RESTRequest postURL:WS_capsuleStock object:[self JSONValue]]
     completion:^(RESTResponse *response) {
         callback(response.success);
     }];
}

/// returns the number of capsules of the given type and size in the stock
- (NSInteger)countOfCapsuleType:(NSString *)capsuleType size:(NSString *)size {
    for (StockItem *stockItem in self.stockItems) {
        if ([stockItem.type isEqualToString:capsuleType] && [stockItem.size isEqualToString:size]) {
            return stockItem.count;
        }
    }
    return 0;
}

/// sets the new number of capsules of the given type and size
- (void)setCount:(NSInteger)count ofCapsuleType:(NSString *)capsuleType size:(NSString *)size {
    for (StockItem *stockItem in self.stockItems) {
        if ([stockItem.type isEqualToString:capsuleType] && [stockItem.size isEqualToString:size]) {
            if (stockItem.count != count) {
                stockItem.count = count;
                [self postNotificationStockChanged];
            }
            return;
        }
    }
    StockItem *stockItem = [StockItem new];
    stockItem.type = capsuleType;
    stockItem.size = size;
    stockItem.count = count;
    self.stockItems = [self.stockItems arrayByAddingObject:stockItem];
    [self postNotificationStockChanged];
}

#pragma mark - Notification support

- (void)addObserver:(id)observer selector:(SEL)selector {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:kStockChanged object:self];
}

- (void)removeObserver:(id)observer {
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:kStockChanged object:self];
}

- (void)postNotificationStockChanged {
    [[NSNotificationCenter defaultCenter] postNotificationName:kStockChanged object:self];
}

@end


@implementation StockItem

- (id)initWithJSONValue:(id)JSONValue {
    self = [self init];
    if (self) {
        
        self.count = [JSONValue[@"capsuleCount"] integerValue];
        self.type = JSONValue[@"capsuleType"];
        self.size = JSONValue[@"capsuleSize"];
    }
    return self;
}

- (id)JSONValue {
    //return
    NSString *firstLetter = [[self.type substringToIndex:1] lowercaseString];
    NSString *type = [self.type stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstLetter];
    NSString *name = [NSString stringWithFormat:@"%@%@", type, ([self.size isEqualToString:@"Small"] ? @"Standard" : @"Maxi")];
    return @{name : @(self.count)};
}

@end
