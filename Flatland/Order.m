//
//  Order.m
//  Flatland
//
//  Created by Stefan Aust on 24.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "Order.h"
#import "Capsule.h"
#import "User.h"

#define OrderKey @"babynes.order"

static NSString * const kOrderChanged = @"OrderChanged";

@implementation Order

@synthesize orderItems;

#pragma mark

+ (Order *)sharedOrder {
    static Order *order;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *key = [[NSString alloc] initWithFormat:@"%@-%@", OrderKey, [[User activeUser] email]];
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        id JSONValue = data ? [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL] : nil;
        order = [[Order alloc] initWithJSONValue:JSONValue];
    });
    return order;
}

#pragma mark - Notification support

- (void)addObserver:(id)observer selector:(SEL)selector {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:kOrderChanged object:self];
}

- (void)removeObserver:(id)observer {
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:kOrderChanged object:self];
}

- (void)postNotificationOrderChanged {
    [[NSNotificationCenter defaultCenter] postNotificationName:kOrderChanged object:self];
}

#pragma mark - JSON serialization

- (id)initWithJSONValue:(id)JSONValue {
    self = [self init];
    if (self) {
        if (JSONValue) {
            orderItems = [[NSMutableArray alloc] init];
            for (id value in JSONValue[@"orderItems"]) {
                [orderItems addObject:[[OrderItem alloc] initWithJSONValue:value]];
            }
            self.deliveryAddressID = ObjectFromJSONValue(JSONValue[@"deliveryAddressID"]);
            self.billingAddressID = ObjectFromJSONValue(JSONValue[@"billingAddressID"]);
            self.deliveryModeID = ObjectFromJSONValue(JSONValue[@"deliveryModeID"]);
            self.rendezvousDate = DateFromJSONValue(JSONValue[@"requestedDeliveryDate"]);
            self.phoneNumber = ObjectFromJSONValue(JSONValue[@"contactPhoneNumber"]);
            [self postNotificationOrderChanged];
        }
    }
    return self;
}

- (id)JSONValue {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[orderItems count]];
    for (id item in orderItems) {
        [result addObject:[item JSONValue]];
    }
    return [NSDictionary dictionaryWithObjectsAndKeys:
            result, @"orderItems",
            JSONValueFromObject(self.deliveryAddressID), @"deliveryAddressID",
            JSONValueFromObject(self.billingAddressID), @"billingAddressID",
            JSONValueFromObject(self.deliveryModeID), @"deliveryModeID",
            JSONValueFromDate(self.rendezvousDate), @"requestedDeliveryDate",
            JSONValueFromObject(self.phoneNumber), @"contactPhoneNumber",
            nil];
}

#pragma mark - Properties

- (NSMutableArray *)orderItems {
    if (!orderItems) {
        orderItems = [NSMutableArray new];
    }
    return orderItems;
}

#pragma mark - Random stuff

- (NSUInteger)orderItemCount {
    NSUInteger count = 0;
    for (OrderItem *item in orderItems) {
        count += item.quantity;
    }
    return count;
}

- (NSInteger)capsulesPrice {
    NSInteger price = 0;
    for (OrderItem *item in orderItems) {
        price += [item price] * item.quantity;
    }
    return price;
}

- (NSInteger)totalPrice {
    return [self capsulesPrice] + [self priceForDeliveryMode:[DeliveryMode deliveryModeForID:self.deliveryModeID]];
}

- (NSInteger)priceForDeliveryMode:(DeliveryMode *)deliveryMode {
    if ([deliveryMode.ID isEqualToString:@"Default"] && [self orderItemCount] >= 4)
    {
        return 0;
    }
    if ([kCountryCode isEqualToString:@"FR"]) {
        for(OrderItem *i in [self orderItems])
        {
            if([i.capsuleType isEqualToString:@"Machine"])
            {
                return 0;
            }
        }
    }
    
    return deliveryMode.price;
}

#pragma mark - Modifying orders

- (void)addOrderItem:(OrderItem *)orderItem {
    for (OrderItem *item in orderItems) {
        if ([item.capsuleType isEqual:orderItem.capsuleType] && [item.capsuleSize isEqual:orderItem.capsuleSize]) {
            item.quantity += orderItem.quantity;
            [self save];
            return;
        }
    }
    [self.orderItems addObject:[orderItem copy]]; // need to use getter to lazy-initialize the array
    [self save];
}

- (void)removeOrderItem:(OrderItem *)orderItem {
    for (OrderItem *item in orderItems) {
        if ([item.capsuleType isEqual:orderItem.capsuleType] && [item.capsuleSize isEqual:orderItem.capsuleSize]) {
            item.quantity -= orderItem.quantity;
            if (item.quantity <= 0) {
                [orderItems removeObjectIdenticalTo:item];
            }
            [self save];
            return;
        }
    }
}

- (void)removeAllOrderItems {
    [orderItems removeAllObjects];
    [self save];
}

- (void)combineCapsules {
    for (NSUInteger i = 0; i < [orderItems count]; i++) {
        OrderItem *baseItem = [orderItems objectAtIndex:i];
        for (NSUInteger j = i + 1; j < [orderItems count]; j++) {
            OrderItem *testItem = [orderItems objectAtIndex:j];
            if ([baseItem.capsuleType isEqual:testItem.capsuleType] && [baseItem.capsuleSize isEqual:testItem.capsuleSize]) {
                baseItem.quantity += testItem.quantity;
                [orderItems removeObjectAtIndex:j--];
            }
        }
    }
}

- (void)save {
    [self postNotificationOrderChanged];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:[self JSONValue] options:0 error:NULL];
    NSString *key = [[NSString alloc] initWithFormat:@"%@-%@", OrderKey, [[User activeUser] email]];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - copying

- (id)copyWithZone:(NSZone *)zone {
    Order *order = [[[self class] allocWithZone:zone] initWithJSONValue:[self JSONValue]];
    order.orderNo = self.orderNo;
    order.email = self.email;
    order.price = self.price;
    order.deliveryAddress = self.deliveryAddress;
    order.billingAddress = self.billingAddress;
    order.deliveryMode = self.deliveryMode;
    return order;
}

@end


@implementation OrderItem

- (id)initWithJSONValue:(id)JSONValue {
    if ((self = [self init])) {
        if (JSONValue) {
            self.capsuleType = [JSONValue valueForKey:@"capsuleType"];
            self.itemType = [JSONValue valueForKey:@"itemType"];
            self.capsuleSize = [JSONValue valueForKey:@"capsuleSize"];
            self.quantity = [[JSONValue valueForKey:@"boxCount"] integerValue];
        }
    }
    return self;
}

- (id)initWithString:(NSString*)name andQuantity:(int)quantity {
    
    
    name = [name lowercaseString];
    
    if(self = [self init])
    {
        if([name isEqualToString:@"firstmonthmaxi"]) {
            self.capsuleType = @"FirstMonth";
            self.capsuleSize = @"Large";
        } else if([name isEqualToString:@"firstmonthstandard"]) {
            self.capsuleType = @"FirstMonth";
            self.capsuleSize = @"Small";
        } else if([name isEqualToString:@"secondmonthmaxi"]) {
            self.capsuleType = @"SecondMonth";
            self.capsuleSize = @"Large";
        } else if([name isEqualToString:@"secondmonthstandard"]) {
            self.capsuleType = @"SecondMonth";
            self.capsuleSize = @"Small";
        } else if([name isEqualToString:@"thirdtosixthmonthmaxi"]) {
            self.capsuleType = @"ThirdToSixthMonth";
            self.capsuleSize = @"Large";
        } else if([name isEqualToString:@"thirdtosixthmonthstandard"]) {
            self.capsuleType = @"ThirdToSixthMonth";
            self.capsuleSize = @"Small";
        } else if([name isEqualToString:@"seventhtotwelfthmonth"]) {
            self.capsuleType = @"SeventhToTwelfthMonth";
            self.capsuleSize = @"Small";
        } else if([name isEqualToString:@"thirteenthtotwentyfourthmonth"]) {
            self.capsuleType = @"ThirteenthToTwentyFourthMonth";
            self.capsuleSize = @"Small";
        } else if([name isEqualToString:@"twentyfifthmonthtothirtysixthmonth"]) {
            self.capsuleType = @"TwentyFifthMonthToThirtySixthMonth";
            self.capsuleSize = @"Small";
        }
        
        self.quantity = quantity;
    }
    return self;
}

- (id)JSONValue {
    if([self isMachine]){
        self.itemType = @"Dispenser";
    }else{
        self.itemType = @"CapsuleBox";
    }
    return [NSDictionary dictionaryWithObjectsAndKeys:
            self.capsuleType, @"capsuleType",
            self.capsuleSize, @"capsuleSize",
            self.itemType, @"itemType",
            [NSNumber numberWithInteger:self.quantity], @"boxCount",
            nil];
}

- (BOOL)isMachine {
    return [self.capsuleType isEqualToString:@"Machine"];
}

- (NSInteger)price {
    if ([self isMachine]) {
        return [T(@"machine.priceInCents") integerValue];
    }
    Capsule *capsule = [Capsule capsuleForType:self.capsuleType];
    return [capsule.prices[[self sizeIndex]] integerValue];
}

- (NSInteger)ml {
    if ([self isMachine]) {
        return 0;
    }
    Capsule *capsule = [Capsule capsuleForType:self.capsuleType];
    return [capsule.sizes[[self sizeIndex]] integerValue];
}

- (NSInteger)sizeIndex {
    return [self.capsuleSize isEqualToString:@"Small"] ? 0 : 1;
}

- (id)copyWithZone:(NSZone *)zone {
    OrderItem *orderItem = [[OrderItem allocWithZone:zone] init];
    orderItem.capsuleType = self.capsuleType;
    orderItem.capsuleSize = self.capsuleSize;
    orderItem.quantity = self.quantity;
    return orderItem;
}

@end
