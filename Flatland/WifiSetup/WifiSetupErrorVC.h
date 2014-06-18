//
//  WifiSetupErrorVC.h
//  Flatland
//
//  Created by Ionel Pascu on 12/5/13.
//  Copyright (c) 2013 Optaros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatWifiViewController.h"

@interface WifiSetupErrorVC : FlatWifiViewController{

}
@property (strong, nonatomic) IBOutlet UILabel *titleTxt;
@property (strong, nonatomic) IBOutlet UITextView *description;
@property (strong, nonatomic) IBOutlet UITextView *suport;
@property (strong, nonatomic) NSString *titleS;
@property (strong, nonatomic) NSString *descriptionS;
@property (strong, nonatomic) NSString *suportS;
- (IBAction)restartProcess:(id)sender;
@end
