//
//  BottlefeedingDailyGraph.h
//  Flatland
//
//  Created by Jochen Block on 13.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"

@interface BottlefeedingDailyGraph : CPTGraphHostingView <CPTPlotSpaceDelegate, CPTPlotDataSource, CPTScatterPlotDelegate>
{
    CPTXYGraph *graph;
}

@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, copy) NSArray *bottles;

- (void)createGraph;

@end