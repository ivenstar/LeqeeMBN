//
//  BabyWeightYearlyGraph.h
//  Flatland
//
//  Created by Pirlitu Vasilica on 12/11/13.
//  Copyright (c) 2013 Optaros. All rights reserved.
//

#import "CPTGraphHostingView.h"
#import "CorePlot-CocoaTouch.h"
#import "WeightWidgetViewController.h"

@interface BabyWeightYearlyGraph : CPTGraphHostingView<CPTPlotSpaceDelegate, CPTPlotDataSource, CPTScatterPlotDelegate>
{
    CPTXYGraph *graph;
    CPTXYGraph *graph2;
    float pinScale;
}

@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, copy) NSArray *weights;
@property (nonatomic, strong) WeightWidgetViewController *parentViewControler;
@property (nonatomic) float pinScale;

- (void)createGraph;
 
@end
