//
//  WifiSetupMachineFound.m
//  Flatland
//
//  Created by Ionel Pascu on 12/3/13.
//  Copyright (c) 2013 Optaros. All rights reserved.
//

#import "WifiSetupMachineFoundVC.h"
#import "WifiSetupSettingUpMachineVC.h"
#import "RESTService.h"

@interface WifiSetupMachineFoundVC ()

@end

@implementation WifiSetupMachineFoundVC
//@synthesize wifiListTable;
@synthesize wifiDict;
@synthesize wifiArray;
@synthesize wifiEncryption;

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
	self.navigationItem.rightBarButtonItem = MakeImageBarButton(@"barbutton-cancel", self, @selector(exitSetup));
    _wifiListTable.delegate = self;
    _wifiListTable.dataSource = self;
    _description.text = T(@"%wifisetup.scanningwifi");
    _description.backgroundColor = [UIColor clearColor];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_spinner startAnimating];
    [_spinner setHidden:NO];
    _description.text = T(@"%wifisetup.scanningwifi");
    _description.backgroundColor = [UIColor clearColor];
    [_scanBtn setHidden:YES];
    //[NSThread sleepForTimeInterval:7.0];
    [self getWifiList:^(BOOL success){
        [_spinner stopAnimating];
        [_spinner setHidden:YES];
        _description.text = T(@"%wifisetup.choosewifi");
        _description.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        if (success){
            NSLog(@"wifilist OK!");
            [_wifiListTable reloadData];
            [_wifiListTable flashScrollIndicators];
        }
        
        else{
            NSLog(@"wifilist NOT OK");
            //push error screen
        }
    }];

}

- (void)getWifiList:(void (^)(BOOL))completion{
    [[RESTService sharedService]
     queueRequest:[RESTRequest getURLMachine:WSM_getWifiList]
     completion:^(RESTResponse *response) {
         if (response.statusCode){
         
             if (![response.object[@"error"] boolValue]) {
             NSArray *jsonArray = ArrayFromJSONObject(response.object[@"result"]);
             _ssids = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
             wifiArray = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
                 wifiEncryption = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
                 for (id object in jsonArray) {
                 SSID *ssid = [[SSID alloc] initWithJSONObject:object];
                 [_ssids addObject:ssid];
                 [wifiArray addObject:ssid.ssid];
                 [wifiEncryption addObject:ssid.auth];
                 
             }
             if ([wifiArray count] == 0){
                 [self performSegueWithIdentifier:@"showErrorNoWifiNetworks" sender:self];

             }
                 //[_scanBtn setHidden:NO];
             //else [_scanBtn setHidden:YES];
             //wifiArray = _ssids;
             completion(YES);
         } else{
             [_scanBtn setHidden:NO];
             [_spinner stopAnimating];
             [_spinner setHidden:YES];
             
             if ([response.object[@"result"] intValue] == 2) //2: Internal machine error
             //show error 7.2
                 [self performSegueWithIdentifier:@"showErrorWifi" sender:self];
             else if ([response.object[@"result"] intValue] == 1) //1: The list of SSIDs is empty
             //show error 7.1
                 [self performSegueWithIdentifier:@"showErrorNoWifiNetworks" sender:self];
             completion(NO);
         }

         }
         else{
             [_scanBtn setHidden:NO];
             [_spinner stopAnimating];
             [_spinner setHidden:YES];
             [self performSelector:@selector(showError72) withObject:nil afterDelay:1.0f];
             
             completion(NO);
         }
     }];
}

- (void)showError72{
    [self performSegueWithIdentifier:@"showErrorWifi" sender:self];
}

- (IBAction)scanAgain:(id)sender {
    [_spinner startAnimating];
    [_spinner setHidden:NO];
    [_scanBtn setHidden:YES];
    _description.text = T(@"%wifisetup.scanningwifi");
    _description.backgroundColor = [UIColor clearColor];
    
    [self getWifiList:^(BOOL success){
        [_spinner stopAnimating];
        [_spinner setHidden:YES];
        _description.text = T(@"%wifisetup.choosewifi");
        _description.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        if (success){
            NSLog(@"wifilist OK!");
            [_wifiListTable reloadData];
        }
        
        else{
            NSLog(@"wifilist NOT OK");
            //push error screen
        }
    }];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"number of ssids:: %d", [wifiArray count]);
    return [wifiArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"wifiSSID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        // More initializations if needed.
    }
    
    cell.textLabel.text = [wifiArray objectAtIndex:indexPath.row];
    
//    //fix for iOS7 delay touches
//    for (id obj in tableView.subviews) {
//        if ([obj respondsToSelector:@selector(setDelaysContentTouches:)]) {
//            [obj setDelaysContentTouches:NO];
//        }
//    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *name = [wifiArray objectAtIndex:indexPath.row];
    NSLog(@"selected SSID:: %@", name);
    _selectedSSID = name;
    _selectedEncryption = [wifiEncryption objectAtIndex:indexPath.row];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:T(@"%wifisetup.enterpassword"), name] delegate:self cancelButtonTitle:T(@"%general.cancel") otherButtonTitles:T(@"%general.ok"), nil];
    
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    //UITextField *pass = [alert textFieldAtIndex:0];
    //pass.keyboardType = UIKeyboardTypeNumberPad;
    //pass.placeholder = @"Password";
    //[alert addSubview:pass];
    [alert show];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    //    for (NSIndexPath *i in [tableView indexPathsForSelectedRows]) {
//        if (i.section == indexPath.section && i.row != indexPath.row) {
//            [tableView deselectRowAtIndexPath:i animated:NO];
//        }
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma mark Password validation

/******
 
 * For WPA, WPA2: password must be between 8 and 63 printable ASCII-encoded characters (i.e. Characters in range 0x20 – ‘Space’ to 0x7E – ‘-‘)
 * For WEP:
 - Either 5 or 13 printable ASCII characters long password
 - Or 10 or 26 Hexadecimal characters long password (i.e. characters 0123456789ABCDEF)
 
 ******/
- (BOOL)validatePassword:(NSString*)pass :(NSString*)encryption {

    NSString *enc = [encryption substringToIndex:3];
    if ([enc isEqualToString:@"WPA"]) {
        if (([pass length] < 8) || ([pass length] > 63) || !MatchesRegex(pass, @"^[\\x20-\\x7E]*$"))
            return FALSE;
    }
    else if ([enc isEqualToString:@"WEP"]) {
        if (MatchesRegex(pass, @"^[0-9A-Fa-f]+$")) //if hexa
        {
            //check length
            if (([pass length] != 10) && ([pass length] != 26))
            {
                return FALSE;
            }
        }
        else if (MatchesRegex(pass, @"^[\\x20-\\x7E]*$")) //if printable ascii
        {
            //check length
            if (([pass length] != 5) && ([pass length] != 13))
            {
                return FALSE;
            }
        }
        else
        {
            return FALSE;
        }
    }
    return TRUE;
}

#pragma mark - AlertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
     if (buttonIndex == 1){
        _password = [alertView textFieldAtIndex:0].text;
        NSLog(@"pass: %@   encryption:%@", _password, _selectedEncryption);
        if ([self validatePassword:_password :_selectedEncryption])
            [self performSegueWithIdentifier:@"ConfigureWifi" sender:self];
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:T(@"%wifisetup.invalidpassword") delegate:self cancelButtonTitle:T(@"%general.ok") otherButtonTitles:nil];
            [alert show];
        }
    }
    NSLog(@"buton:::::::::%d", buttonIndex);
}
                          

 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     if ([[segue identifier] isEqualToString:@"ConfigureWifi"]){
     WifiSetupSettingUpMachineVC *vc = [segue destinationViewController];
     vc.pass = _password;
     vc.ssid = _selectedSSID;
     vc.connecting = [NSString stringWithFormat:T(@"%wifisetup.connectingmachine"), _selectedSSID];
     }
     else if ([[segue identifier] isEqualToString:@"showErrorWifi"]){
         WifiSetupErrorVC *vc = [segue destinationViewController];
         vc.titleS = T(@"%wifisetup.internalerrortitle");
         vc.descriptionS = T(@"%wifisetup.internalerrortext");
         vc.suportS = @"";
     }
}



@end
