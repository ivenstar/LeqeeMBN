//
//  Stock.h
//  Flatland
//
//  Created by Stefan Aust on 13.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Represents the capsule stock as known by the server.
 */
@interface Stock : NSObject

@property (nonatomic, assign) NSInteger capsulesLeft;
@property (nonatomic, copy) NSArray *stockItems; // of type StockItem

/// adds observer to this instance
- (void)addObserver:(id)observer selector:(SEL)selector;

/// removes observer from this instance
- (void)removeObserver:(id)observer;

/// loads the stock from the sever; passes either a new Stock instance or nil on errors
+ (void)get:(void (^)(Stock *stock))callback;

/// initializes a new instance with the given JSON value
- (id)initWithJSONValue:(id)JSONValue;

/// returns the receiver as JSON value suitable for saving it to the server
- (id)JSONValue;

/// saves the receiver to the server; passes YES on success and NO on errors
- (void)save:(void (^)(BOOL success))callback;

/// returns the number of capsules of the given type and size in the stock
- (NSInteger)countOfCapsuleType:(NSString *)capsuleType size:(NSString *)size;

/// sets the new number of capsules of the given type and size
- (void)setCount:(NSInteger)count ofCapsuleType:(NSString *)capsuleType size:(NSString *)size;

@end


@interface StockItem : NSObject

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *size;

- (id)initWithJSONValue:(id)JSONValue;
- (id)JSONValue;

@end
