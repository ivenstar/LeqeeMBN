//
//  WebViewViewController.h
//  Flatland
//
//  Created by Manuel Ohlendorf on 09.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "FlatViewController.h"

/**
 * Displays the all possible html content like  Privacy Policy or AGB.
 */
@interface WebViewViewController : FlatViewController

@property (nonatomic, copy) NSString *viewName; //the name of the html view without extension
@property (nonatomic, assign) BOOL modal; //when YES that the View has a Done button
@property(nonatomic,strong)NSString *url;
-(id)initWithLink:(NSString*)link;

@end
