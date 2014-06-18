//
//  BabyWeightGraph.h
//  Flatland
//
//  Created by Jochen Block on 14.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"
#import "WeightWidgetViewController.h"

@interface BabyWeightGraph : CPTGraphHostingView <CPTPlotSpaceDelegate, CPTPlotDataSource, CPTScatterPlotDelegate>
{
    CPTXYGraph *graph;
    CPTXYGraph *graph2;
    float pinScale;
}

@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, strong) NSMutableArray *weights;
@property (nonatomic, strong) WeightWidgetViewController *parentViewControler;
@property (nonatomic) float pinScale;
@property (nonatomic, copy) NSArray *growthPath;
@property (nonatomic, copy) NSMutableArray *values;
@property (nonatomic) int period;
- (void)createGraph;

@end
