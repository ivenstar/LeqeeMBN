//
//  Order.h
//  Flatland
//
//  Created by Stefan Aust on 24.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "Address.h"
#import "DeliveryMode.h"

@class OrderItem;

/**
 * Provides an abstraction for an order, that is a number of order items
 * plus delivery & billing addresses and delivery mode.
 */
@interface Order : NSObject<NSCopying>

@property (nonatomic, readonly) NSMutableArray *orderItems;
@property (nonatomic, copy) NSString *deliveryAddressID;
@property (nonatomic, copy) NSString *billingAddressID;
@property (nonatomic, copy) NSString *deliveryModeID;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSDate *rendezvousDate;

@property (nonatomic, strong) Address *deliveryAddress;
@property (nonatomic, strong) Address *billingAddress;
@property (nonatomic, strong) DeliveryMode *deliveryMode;

+ (Order *)sharedOrder;

/// adds observer to this instance
- (void)addObserver:(id)observer selector:(SEL)selector;

/// removes observer from this instance
- (void)removeObserver:(id)observer;

/// returns the number of items, each adding its quantity
- (NSUInteger)orderItemCount;

/// initializes the receiver with the given JSON value (or nil)
- (id)initWithJSONValue:(id)JSONValue;

/// returns the receiver as a JSON value that can be used with -initWithJSONValue:
- (id)JSONValue;

/// returns the price of all capsules
- (NSInteger)capsulesPrice;

/// return the price of all capsules plus shipping and handling fee
- (NSInteger)totalPrice;

/// add more capsules to the receiver; the order item object must have the properties capsuleType, capsuleSize and boxCount
- (void)addOrderItem:(OrderItem *)orderItem;

/// remove capsules from the receiver; the order item object must have the properties capsuleType, capsuleSize and boxCount
- (void)removeOrderItem:(OrderItem *)orderItem;

/// remove all order items
- (void)removeAllOrderItems;

/// combine duplicate order items into a single order item
- (void)combineCapsules;

/// save order after potential changes to order items.
- (void)save;

/// return shipping and handling price in cent for the given delivery mode
- (NSInteger)priceForDeliveryMode:(DeliveryMode *)deliveryMode;

@end

/**
 * Provides an abstraction of an order item, that is a capsule type, capsule size and box count.
 */
@interface OrderItem : NSObject<NSCopying>

@property (nonatomic, copy) NSString *capsuleType;
@property (nonatomic, copy) NSString *capsuleSize;
@property (nonatomic, assign) NSInteger quantity;
@property (nonatomic, copy) NSString *itemType;

/// initializes the receiver with the given JSON value (or nil)
- (id)initWithJSONValue:(id)JSONValue;

// init with the name of the capsule
- (id)initWithString:(NSString*)name andQuantity:(int)quantity;

/// returns the receiver as a JSON value that can be used with -initWithJSONValue:
- (id)JSONValue;

/// returns true if this item represents the machine and not a capsule
- (BOOL)isMachine;

/// returns the price of either a single box or a single machine represented by this item
- (NSInteger)price;

/// returns the ml size classification of this item
- (NSInteger)ml;

/// Returns 0 for small capsules and 1 for large ones
- (NSInteger)sizeIndex;

@end
