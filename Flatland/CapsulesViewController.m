//
//  CapsulesViewController.m
//  Flatland
//
//  Created by Stefan Aust on 20.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "CapsulesViewController.h"
#import "CapsulesCell.h"
#import "Capsule.h"
#import "CapsuleSummaryViewController.h"
#import "RecommendationCell.h"
#import "CapsulesRecommendationViewController.h"

@interface CapsulesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL gotRecommendation;
@property (nonatomic, strong) Recommendation *recommendation;

@end

#pragma mark

@implementation CapsulesViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // try to load the recommendations only once (even if it failed)
    if (!self.gotRecommendation) {
        [Recommendation get:^(Recommendation *recommendation)
        {
            self.gotRecommendation = YES;
            self.recommendation = recommendation;
            [self.tableView reloadData];
        }];
    }
}

- (BOOL)showRecommendation
{
    return nil != self.recommendation && nil != self.recommendation.since;
}

#pragma mark - Table view data source & delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[Capsule capsules] count] + self.showRecommendation;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    
    if (self.showRecommendation) {
        if (row == 0) {
            RecommendationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Recommendation"];
            [cell changeSystemFontToApplicationFont];
            [cell setRecommendation:self.recommendation];
            [cell icnhLocalizeSubviews];
            return cell;
        }
        row -= 1;
    }

    CapsulesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [cell changeSystemFontToApplicationFont];
    [cell setCapsule:[Capsule capsules][row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.showRecommendation && indexPath.row == 0 ? 87 : 70; // the recommendation cell is slightly larger
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"recommendation"])
    {
        CapsulesRecommendationViewController *viewController = segue.destinationViewController;
        viewController.recommendation = self.recommendation;
    }
    
    if ([segue.identifier isEqualToString:@"summary"]) {
        CapsuleSummaryViewController *viewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        viewController.capsule = [Capsule capsules][indexPath.row - self.showRecommendation];
    }
}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{

    //Ionel: don't allow buying of Sensitive capsule for FR target - instead, show alert
#ifdef BABY_NES_FR
    if ([identifier isEqualToString:@"summary"]){
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if ([[Capsule capsuleIDforCapsule:[Capsule capsules][indexPath.row - self.showRecommendation] withSize:0] isEqualToString:@"sensitive"]){
        NSString *telCleaned = [[NSString stringWithString:T(@"support.phonenumber")] stringByReplacingOccurrencesOfString:@"tel:" withString:@""];
        NSString *call = [NSString stringWithFormat:@"%@ %@", T(@"%general.call"), telCleaned];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"En raison de sa composition, cette capsule ne peut être vendue que par une pharmacie. Afin d’être mis en relation avec notre partenaire pharmacie, merci de téléphoner au 0800 036 036*.\n*Appel gratuit depuis un poste fixe et décompté des forfaits mobiles" delegate:self cancelButtonTitle:T(@"%general.ok") otherButtonTitles:call, nil];
        alert.tag = 21;
        [alert show];
        return NO;
    }
    }
    
#endif
    
    return YES;
}

#pragma mark - AlertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 21)
    if (buttonIndex == 1) {
        CallSupport();
    }
}


@end
