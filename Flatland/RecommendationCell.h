//
//  RecommendationCell.h
//  Flatland
//
//  Created by Stefan Aust on 13.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recommendation.h"

/**
 * Displays the recommendation information at the top of the capsule list as part of the `CapsulesViewController`.
 */
@interface RecommendationCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *sinceLabel;

- (void)setRecommendation:(Recommendation *)recommendation;

@end
