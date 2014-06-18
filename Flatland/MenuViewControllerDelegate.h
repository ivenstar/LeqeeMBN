//
//  MenuViewControllerDelegate.h
//  Flatland
//
//  Created by Stefan Aust on 21.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Baby.h"

@protocol MenuViewControllerDelegate <NSObject>
- (void)doAccountInformation;
- (void)doOrderingInformation;
- (void)doAdjustCapsuleStock;
- (void)doWifiSetup;
- (void)doWifiRefill;
- (void)doOpenNotificationCenter;
- (void)doLogout;
- (void)doCreateBabyProfile;
- (void)doEditBabyProfile:(Baby *)babyProfile;
- (void)doConfigureWidgets;
- (void)doLegalTerms;
- (void)doPrivacyPolicy;
- (void)doGeneralTermsOfSale;
- (void)doSanitaryMentions;
- (void)doEcoParticipation;
- (void)doUpdateFavouriteBaby;
@end
