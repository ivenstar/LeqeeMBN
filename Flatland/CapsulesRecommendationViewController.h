//
//  CapsulesRecommendationViewController.h
//  Flatland
//
//  Created by Stefan Aust on 16.04.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "OrderAwareViewController.h"
#import "Recommendation.h"

/**
 * Displays the current recommendation and allows the user to add the recommendation to the shared order object.
 */
@interface CapsulesRecommendationViewController : OrderAwareViewController

@property (nonatomic, strong) Recommendation *recommendation;

@end
