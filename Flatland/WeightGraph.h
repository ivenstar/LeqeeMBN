//
//  WeightGraph.h
//  Flatland
//
//  Created by Jochen Block on 03.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface WeightGraph : CPTGraphHostingView <CPTPlotSpaceDelegate, CPTPlotDataSource, CPTScatterPlotDelegate>
{
    CPTXYGraph *graph;
}

@property (nonatomic,copy) NSDictionary *data;
@property (nonatomic,copy) NSDictionary *sets;
@property (nonatomic,copy) NSArray *xAxisLabels;
@property (nonatomic,copy) NSString *yAxisTitle;
@property (nonatomic) int yMaxValue;
@property (nonatomic) int xMaxValue;
@property (nonatomic) BOOL isMonth;

- (void)createGraph;

@end