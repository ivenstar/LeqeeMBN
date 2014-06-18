//
//  RecommendationCell.m
//  Flatland
//
//  Created by Stefan Aust on 13.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "RecommendationCell.h"

@implementation RecommendationCell

- (void)setRecommendation:(Recommendation *)recommendation {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.locale = CurrentLocale();
    [df setDateFormat:@"d MMMM YYYY"];
    NSString *since = [df stringFromDate:recommendation.since];
    self.sinceLabel.attributedText = [[NSString stringWithFormat:T(@"%capsuleStock.sinceLabel"), since] attributedTextFromHTMLStringWithFont:self.sinceLabel.font];
}

@end
