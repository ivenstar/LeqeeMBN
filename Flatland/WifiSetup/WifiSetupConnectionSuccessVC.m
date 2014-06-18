//
//  WifiSetupConnectionSuccessVC.m
//  Flatland
//
//  Created by Ionel Pascu on 12/4/13.
//  Copyright (c) 2013 Optaros. All rights reserved.
//

#import "WifiSetupConnectionSuccessVC.h"

@interface WifiSetupConnectionSuccessVC ()
@property (weak, nonatomic) IBOutlet UILabel *labelChooseOrder;

@end

@implementation WifiSetupConnectionSuccessVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
#ifdef BABY_NES_US
    _labelChooseOrder.text = [NSString stringWithFormat:@"%@\n%@", _labelChooseOrder.text, @"Your choice can be changed at a later stage in MyBabyNes."];;
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)chooseOptions:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"openWifiOptions" object:nil];
        //[self performSelector:@selector(openOptions:) withObject:Nil afterDelay:3.0f];
    }];
    
}

- (void) openOptions:(id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Wifi" bundle:nil];
    [self presentViewController:[storyboard instantiateViewControllerWithIdentifier:@"WifiChangeOptionsNC"] animated:YES completion:nil];
}

@end
