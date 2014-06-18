//
//  Country.h
//  Flatland
//
//  Created by Bogdan Chitu on 13/02/14.
//  Copyright (c) 2014 Optaros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Country : NSObject

@property (nonatomic,strong) NSString* code;
@property (nonatomic,strong) NSString* name;

- (id) initWithCode:(NSString*) code andName: (NSString*) name;

@end
