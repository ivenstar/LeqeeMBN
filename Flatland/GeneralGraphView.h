//
//  GeneralGraphView.h
//  Flatland
//
//  Created by Jochen Block on 02.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface GeneralGraphView : CPTGraphHostingView <CPTPlotSpaceDelegate, CPTPlotDataSource, CPTScatterPlotDelegate>
{
    CPTXYGraph *graph;
}

@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, copy) NSArray *bottles;

- (void)createGraph;

@end
