//
//  WifiSetupConnectingVC.m
//  Flatland
//
//  Created by Ionel Pascu on 12/3/13.
//  Copyright (c) 2013 Optaros. All rights reserved.
//

#import "WifiSetupConnectingVC.h"
#import "RESTService.h"

@interface WifiSetupConnectingVC ()

@property (nonatomic) NSInteger scanCount;
@end

@implementation WifiSetupConnectingVC

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
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.spinner startAnimating];
    
    _scanCount = 0;
    [self performSelector:@selector(scan:) withObject:GetSSID() afterDelay:3.0f];
    
}

- (void)getSetupStatus:(void (^)(BOOL))completion{
    [[RESTService sharedService]
     queueRequest:[RESTRequest getURLMachine:WSM_getStatus]
     completion:^(RESTResponse *response) {
         if (response.statusCode == 0){
             if (_scanCount <=5)
             [self performSelector:@selector(scan:) withObject:nil afterDelay:5.0f];
             completion(NO);
         }
         else
         if (![response.object[@"error"] boolValue]) {
             completion(YES);
         }else{
             //[self performSelector:@selector(scan:) withObject:nil afterDelay:3.0f];
             completion(NO);
         }
     }];
}

- (void)scan:(id)object{
    _scanCount++;
    if ([GetSSID() isEqualToString:BabyNesID]){
        //if YES, call getSetupStatus
        //onCompletion
        [self getSetupStatus:^(BOOL success){
            if (success){
             [self performSegueWithIdentifier:@"goToMachineFound" sender:self];
            }
            else{
            if (_scanCount == 5) [self performSegueWithIdentifier:@"showError" sender:self];
            }
        }];
        
    }
    else{
        if (_scanCount == 5) [self performSegueWithIdentifier:@"showError" sender:self];
        else [self performSelector:@selector(scan:) withObject:nil afterDelay:3.0f];

        //[self performSelector:@selector(setupStatusPoll) withObject:nil afterDelay:3.0f];
    }
}


 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
     if ([[segue identifier] isEqualToString:@"showError"]){
     WifiSetupErrorVC *vc = [segue destinationViewController];
     vc.titleS = T(@"%wifisetup.cannotconnect");
     vc.descriptionS = T(@"%wifisetup.errorconnecting");
     vc.suportS = @"";
    }

}
 
 

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
