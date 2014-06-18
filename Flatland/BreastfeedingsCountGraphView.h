//
//  BreastfeedingsCountGraphView.h
//  Flatland
//
//  Created by Manuel Ohlendorf on 06.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"


@interface BreastfeedingsCountGraphView : CPTGraphHostingView <CPTBarPlotDataSource, CPTPlotSpaceDelegate>{
    CPTXYGraph *graph;
    float pinScale;
}

@property (nonatomic, copy) NSArray *breastfeedings;
@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic) float pinScale;

- (void)createGraph;

@end
