//
//  BreastFeedMonthlyGraph.h
//  Flatland
//
//  Created by Pirlitu Vasilica on 12/10/13.
//  Copyright (c) 2013 Optaros. All rights reserved.
//

#import "CPTGraphHostingView.h"
#import "CorePlot-CocoaTouch.h"
#import "BreastfeedingWidgetViewController.h"

@interface BreastFeedMonthlyGraph : CPTGraphHostingView <CPTPlotSpaceDelegate, CPTPlotDataSource, CPTScatterPlotDelegate>
{
CPTXYGraph *graph;
float pinScale;
}

@property (nonatomic, copy) NSArray *breastfeedings;
@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic) float pinScale;
@property (nonatomic, strong) BreastfeedingWidgetViewController *parentVC;

- (void)createGraph;

@end

