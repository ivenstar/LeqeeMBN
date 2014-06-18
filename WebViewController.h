//
//  WebViewController.h
//  Flatland
//
//  Created by Pirlitu Vasilica on 12/6/13.
//  Copyright (c) 2013 Optaros. All rights reserved.
//

#import "FlatViewController.h"

@interface WebViewController : FlatViewController<UIWebViewDelegate>
@property(nonatomic,strong)NSString *url;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
-(id)initWithLink:(NSString*)link;
@end
