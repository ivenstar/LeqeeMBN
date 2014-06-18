//
//  WifiSetupInstructionsVC.m
//  Flatland
//
//  Created by Ionel Pascu on 12/3/13.
//  Copyright (c) 2013 Optaros. All rights reserved.
//

#import "WifiSetupInstructionsVC.h"
#import "WifiSetupConnectingVC.h"

@interface WifiSetupInstructionsVC ()

@end

@implementation WifiSetupInstructionsVC

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
	_step1Text.text = T(@"%wifisetup.instructions.step1text");
	_step2Text.text = T(@"%wifisetup.instructions.step2text");
    // Do any additional setup after loading the view.
    //[self.scrollView setScrollEnabled:TRUE];
    //[self.scrollView setContentSize:CGSizeMake(320, 1000)];
    //self.scrollView.translatesAutoresizingMaskIntoConstraints = YES;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goNext) name:UIApplicationDidBecomeActiveNotification object:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidBecomeActiveNotification object:nil];
//    
    self.navigationItem.leftBarButtonItem = MakeImageBarButton(@"barbutton-back", self, @selector(goBack));
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    ((AppDelegate *)[UIApplication sharedApplication].delegate).WifiSetupConfigureVisible = TRUE;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goNext) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidBecomeActiveNotification object:nil];
    
    
    if ([GetSSID() isEqualToString:BabyNesID]){
        ((AppDelegate *)[UIApplication sharedApplication].delegate).returnFromBG = TRUE;
        [self performSelector:@selector(goNext) withObject:self afterDelay:0.5f];
    }

}

- (void) viewDidDisappear:(BOOL)animated{
    ((AppDelegate *)[UIApplication sharedApplication].delegate).WifiSetupConfigureVisible = FALSE;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)goNext{
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).returnFromBG == TRUE){
        ((AppDelegate *)[UIApplication sharedApplication].delegate).returnFromBG = FALSE;
        WifiSetupConnectingVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WifiSetupConnecting"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
