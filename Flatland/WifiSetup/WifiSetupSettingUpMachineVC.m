//
//  WifiSetupSettingUpMachineVC.m
//  Flatland
//
//  Created by Ionel Pascu on 12/4/13.
//  Copyright (c) 2013 Optaros. All rights reserved.
//

#import "WifiSetupSettingUpMachineVC.h"
#import "WifiSetupConnectionSuccessVC.h"
#import "RESTService.h"
#import "User.h"
#import "EncryptAES.h"

int result = 0;
@interface WifiSetupSettingUpMachineVC ()

@end

@implementation WifiSetupSettingUpMachineVC
@synthesize setupStatus;

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
    self.connectingText.text = self.connecting;
	
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _visibleFirmware = 0;
    //call configureWifi Machine API
    //onCompletion
    [self configureWifi:^(BOOL success){
        if (success){
            //[_spinner stopAnimating];
            //[_spinner setHidden:YES];
            NSLog(@"configureWifi OK!");
            //[wifiListTable reloadData];
            //WifiSetupConnectionSuccessVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WifiSetupConnectionSuccess"];
            //[self.navigationController pushViewController:vc animated:YES];

        }
        
        else{
            NSLog(@"configureWifi NOT OK");
            //push error screen
            [self performSegueWithIdentifier:@"showError1" sender:self];
        }
    }];

    //if configureWifi timeout:: show Lost connection screen 9.3
    
    
    setupStatus = 0;
    result = 0;
    //poll every 5 sec if AP = Babynes;
    [self performSelector:@selector(setupStatusPoll) withObject:nil afterDelay:5.0f];
    
    
}

- (id)createData {
    //NSString *ssid = URLencodeForString(@"optaros");
    //NSString *pass = URLencodeForString(@"AAAAAAAAA88");
    /*
    //old code
    NSString *ssid = URLencodeForString(_ssid);
    NSString *pass = URLencodeForString(_pass);
    NSString *token = URLencodeForString([User activeUser].accessToken);
    NSString *lang = URLencodeForString(@"fr");
    NSString *country = URLencodeForString(@"CH");
    NSString *aux = [NSString stringWithFormat:@"ssid=%@&password=%@&apptoken=%@&lang=%@&country=%@", ssid, pass, token, lang, country];
    NSLog(@"raw string:: %@", aux);
    
    //NSLog(@"url-encoded raw string: %@", aux);
    NSString *data = Base64forData([aux dataUsingEncoding:NSASCIIStringEncoding]);
    //url-encode data
    data = URLencodeForString(data);
    NSLog(@"url-encoded base64 string: %@", data);
    NSString *aux2 = @"akskwieiroqieotp";
    //iv
    NSString *iv = Base64forData([aux2 dataUsingEncoding:NSASCIIStringEncoding]);
    //url-encode iv base64 data
    iv = URLencodeForString(iv);
    NSLog(@"url-encoded base64 iv: %@", iv);
    NSString *final = [NSString stringWithFormat:@"data=%@&iv=%@", data, iv];
    */
    //NSLog(@"token:: %@", [User activeUser].accessToken);
    EncryptAES *encrypt = [[EncryptAES alloc] init];
    NSString *final = [encrypt encryptWithSSID:_ssid password:_pass token:[User activeUser].accessToken lang:T(@"%general.language") country:kCountryCode];
    //NSLog(@"final:: %@", final);
    return final;
    
    //return @{@"data" : data,
    //         @"iv": iv};
}

- (void)configureWifi:(void (^)(BOOL))completion{
    [[RESTService sharedService]
     queueRequest:[RESTRequest postURLMachine:WSM_configureWifi object:[self createData]]
     completion:^(RESTResponse *response) {
         
         if (![response.object[@"error"] boolValue]) {

             completion(YES);
         }else{
             completion(NO);
         }
     }];
}

- (void)completeSetup:(void (^)(BOOL))completion{
    [[RESTService sharedService]
     queueRequest:[RESTRequest getURLMachine:WSM_completeSetup]
     completion:^(RESTResponse *response) {
         
         if (![response.object[@"error"] boolValue]) {
             
             completion(YES);
         }else{
             completion(NO);
         }
     }];
}

- (void)getSetupStatus:(void (^)(BOOL))completion{
    [[RESTService sharedService]
     queueRequest:[RESTRequest getURLMachine:WSM_getStatus]
     completion:^(RESTResponse *response) {
         
         if (![response.object[@"error"] boolValue]) {
             //test
             setupStatus++;
             result = [response.object[@"result"] intValue];
             //if (setupStatus == 2) result = 7;
             //if (setupStatus == 4) result = 10;
             //if (setupStatus == 6) result = 9;
             switch (result){
                 //5: Registration OK
                 case 5: {
                     [self completeSetup:^(BOOL success){
                         if (success){
                             
                         }
                         else{
                             
                         }
                     }];
                     WifiSetupConnectionSuccessVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WifiSetupConnectionSuccess"];
                            [self.navigationController pushViewController:vc animated:YES];
                            break;
                 }
                 //4: Currently registering
                 case 4: [self performSelector:@selector(setupStatusPoll) withObject:nil afterDelay:5.0f];
                     break;
                 //3: Wi-Fi configured OK / Registration not OK
                 case 3: [self performSegueWithIdentifier:@"showErrorServer" sender:self];
                     break;
                 //2: Wi-Fi configuration not OK
                 case 2: [self performSegueWithIdentifier:@"showErrorWifi" sender:self];
                     break;
                 //1: Currently configuring Wi-Fi
                 case 1: [self performSelector:@selector(setupStatusPoll) withObject:nil afterDelay:5.0f];
                     break;
                 //0: Not configured
                 case 0: [self performSelector:@selector(setupStatusPoll) withObject:nil afterDelay:5.0f];
                     break;
                 case 7:
                 case 8:
                 {
                     if (_visibleFirmware != 1){
                         _visibleFirmware = 1;
                         [self performSegueWithIdentifier:@"NewFirmwareAvailable" sender:self];
                     }
                     [self performSelector:@selector(setupStatusPoll) withObject:nil afterDelay:5.0f];
                 }
                     break;
                 case 10:
                 {
                     if (_visibleFirmware != 2){
                         _visibleFirmware = 2;
                         [self performSegueWithIdentifier:@"NewFirmwareDownloaded" sender:self];
                     }
                     [self performSelector:@selector(setupStatusPoll) withObject:nil afterDelay:5.0f];
                 }
                     break;
                 case 9:
                 case 13:
                 {
                     [self performSegueWithIdentifier:@"NewFirmwareError" sender:self];
                     //[self performSelector:@selector(setupStatusPoll) withObject:nil afterDelay:5.0f];
                 }
                     break;
                 default: [self performSelector:@selector(setupStatusPoll) withObject:nil afterDelay:5.0f];
                     break;
                
                     //if status = orice != 5, start 30 sec local timeout / each step / global timeout for all status codes
                     //[self performSelector:@selector(setupStatusPoll) withObject:nil afterDelay:5.0f];
                     //if status = 2, show error 9.2
                     //[self performSegueWithIdentifier:@"showError2" sender:self];
                     //if status = 3, show error 9.4
                     //[self performSegueWithIdentifier:@"showErrorServer" sender:self];
                     //if status = OK, cancel poll, show 9.1 + call completeSetup
                     
             }
             completion(YES);
         }else{
             completion(NO);
         }
     }];
}

- (void) setupStatusPoll{
    if ([GetSSID() isEqualToString:BabyNesID]){
        //if YES, call getSetupStatus
        //onCompletion
        [self getSetupStatus:^(BOOL success){
            if (success){
                
            }
            else{
                // if NO, connection lost, show 9.3
                WifiSetupLostConnectionVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WifiSetupLostConnection"];
                if (_visibleFirmware){
                    vc.afterFirmwareString = T(@"%wifisetup.lostStep2.2");
                }
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
        
    }
    else{
        // if NO, connection lost, show 9.3
        WifiSetupLostConnectionVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WifiSetupLostConnection"];
        if (_visibleFirmware){
            vc.afterFirmwareString = T(@"%wifisetup.lostStep2.2");
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showError1"]){
        WifiSetupErrorVC *vc = [segue destinationViewController];
        vc.titleS = @"Wrong parameters";
        vc.descriptionS = @"Wrong parameters";
        vc.suportS = @"";
    }
    else if ([[segue identifier] isEqualToString:@"NewFirmwareAvailable"]){
        WifiSetupFirmwareVC *vc = [segue destinationViewController];
        vc.titleString = T(@"%wifisetup.newfirmwareavailable");
        vc.descString1 = T(@"%wifisetup.firmware.available1");
        vc.descString2 = T(@"%wifisetup.firmware.available2");
    }
    else if ([[segue identifier] isEqualToString:@"NewFirmwareDownloaded"]){
        WifiSetupFirmwareVC *vc = [segue destinationViewController];
        vc.titleString = T(@"%wifisetup.newfirmwaredownloaded");
        vc.descString1 = T(@"%wifisetup.firmware.downloaded1");
        vc.descString2 = T(@"%wifisetup.firmware.downloaded2");
    }

    else if ([[segue identifier] isEqualToString:@"NewFirmwareError"]){
        WifiSetupErrorVC *vc = [segue destinationViewController];
        vc.titleS = T(@"%wifisetup.firmware.error.title");
        vc.descriptionS = T(@"%wifisetup.firmware.error.text1");
        vc.suportS = T(@"%wifisetup.firmware.error.text2");
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
