//
//  WeightGraph.m
//  Flatland
//
//  Created by Jochen Block on 03.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "WeightGraph.h"

@implementation WeightGraph

@synthesize data, sets, xAxisLabels, yMaxValue, xMaxValue, yAxisTitle, isMonth;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)createGraph
{
    //Generate layout
    [self generateLayout];
}

- (void)generateLayout
{
    //Create graph from theme
	graph                               = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    
	self.hostedGraph                    = graph;
    graph.plotAreaFrame.masksToBorder   = NO;
    graph.paddingLeft                   = 23.0f;
    graph.paddingTop                    = 0.0f;
    if(xMaxValue == 5){
        graph.paddingRight                  = 20.0f;
    }else{
        graph.paddingRight                  = 0.0f;
    }
	graph.paddingBottom                 = 10.0f;
    
    CPTMutableLineStyle *borderLineStyle    = [CPTMutableLineStyle lineStyle];
	borderLineStyle.lineColor               = [CPTColor whiteColor];
	borderLineStyle.lineWidth               = 0.0f;
	graph.plotAreaFrame.borderLineStyle     = nil;
	graph.plotAreaFrame.paddingTop          = 10.0;
	graph.plotAreaFrame.paddingRight        = 0.0;
	graph.plotAreaFrame.paddingBottom       = 10.0;
	graph.plotAreaFrame.paddingLeft         = 30.0;
    
	//Add plot space
	CPTXYPlotSpace *plotSpace       = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.delegate              = self;
	plotSpace.yRange                = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0)
                                                                   length:CPTDecimalFromInt(yMaxValue * sets.count)];
	plotSpace.xRange                = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(-0.7)
                                                                   length:CPTDecimalFromInt(xMaxValue)];
    
    //Grid line styles
	CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
	majorGridLineStyle.lineWidth            = 0.0;
	majorGridLineStyle.lineColor            = [[CPTColor whiteColor] colorWithAlphaComponent:1.0];
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
	minorGridLineStyle.lineWidth            = 0.0;
	minorGridLineStyle.lineColor            = [[CPTColor whiteColor] colorWithAlphaComponent:1.0];
    
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.fontName = @"Helvetica";
    textStyle.fontSize = 9;
    textStyle.textAlignment = NSTextAlignmentCenter;
    textStyle.color = [CPTColor colorWithComponentRed:(151.0 / 255.0) green:(147.0 / 255.0) blue:(187.0 / 255.0) alpha:1];
    
    
    //Axes
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    
    //X axis
    CPTXYAxis *x                    = axisSet.xAxis;
    x.orthogonalCoordinateDecimal   = CPTDecimalFromInt(0);
	x.majorIntervalLength           = CPTDecimalFromInt(1);
	x.minorTicksPerInterval         = 0;
    x.labelingPolicy                = CPTAxisLabelingPolicyNone;
    x.axisConstraints               = [CPTConstraints constraintWithLowerOffset:0.0];
    x.axisLineStyle = nil;
    x.labelTextStyle = textStyle;
    
    //X labels
    int labelLocations = 0;
    NSMutableArray *customXLabels = [NSMutableArray array];
    for (NSString *labelText in xAxisLabels) {
        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:labelText textStyle:x.labelTextStyle];
        newLabel.tickLocation   = [[NSNumber numberWithInt:labelLocations] decimalValue];
        newLabel.offset         = x.labelOffset + x.majorTickLength;
        //newLabel.rotation       = M_PI / 3;
        [customXLabels addObject:newLabel];
        labelLocations++;
    }
    x.axisLabels                    = [NSSet setWithArray:customXLabels];
    
    //Y axis
	CPTXYAxis *y            = axisSet.yAxis;
	y.title                 = self.yAxisTitle;
	y.titleOffset           = 26.0f;
    y.minorTicksPerInterval = 0;
    y.axisLineStyle = nil;
    y.labelingPolicy        = CPTAxisLabelingPolicyAutomatic;
    y.axisConstraints       = [CPTConstraints constraintWithLowerOffset:0.0];
    y.titleTextStyle = textStyle;
    y.labelTextStyle = textStyle;
    y.minorTickLineStyle = nil;
    y.majorGridLineStyle = nil;
    y.majorTickLineStyle = nil;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:0];
    y.labelFormatter = formatter;
    
    //Create a bar line style
    CPTMutableLineStyle *barLineStyle   = [[CPTMutableLineStyle alloc] init];
    barLineStyle.lineWidth              = 0.0;
    barLineStyle.lineColor              = [CPTColor whiteColor];
    CPTMutableTextStyle *whiteTextStyle = [CPTMutableTextStyle textStyle];
	whiteTextStyle.color                = [CPTColor whiteColor];
    
    // Configure the Scatter Plot
    CPTScatterPlot *sPlot = [[CPTScatterPlot alloc] init];
    sPlot.dataSource = self;
    sPlot.identifier = @"mainplot";
    
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor clearColor];
    lineStyle.lineWidth = 3.0f;
    sPlot.dataLineStyle = lineStyle;
    
    CPTPlotSymbol* circlePlotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    circlePlotSymbol.fill = [CPTFill fillWithColor:[CPTColor blackColor]];
    circlePlotSymbol.size = CGSizeMake(10.0, 10.0);
    sPlot.plotSymbol = circlePlotSymbol;
    
    CPTScatterPlot *sPlot2 = [[CPTScatterPlot alloc] init];
    sPlot2.dataSource = self;
    sPlot2.identifier = @"secondplot";
    
    CPTMutableLineStyle *lineStyle2 = [CPTMutableLineStyle lineStyle];
    lineStyle2.lineColor = [CPTColor clearColor];
    lineStyle2.lineWidth = 3.0f;
    sPlot2.dataLineStyle = lineStyle2;
    

    
    //Plot
    BOOL firstPlot = YES;
    for (NSString *set in [[sets allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]) {
        CPTBarPlot *plot        = [CPTBarPlot tubularBarPlotWithColor:[CPTColor blueColor] horizontalBars:NO];
        plot.cornerRadius = 20.0;
        plot.lineStyle          = barLineStyle;
        plot.fill               = [CPTFill fillWithColor:[CPTColor blackColor]];
        if (firstPlot) {
            plot.barBasesVary   = NO;
            firstPlot           = NO;
        } else {
            plot.barBasesVary   = YES;
        }
        plot.barWidth           = CPTDecimalFromFloat(0.05f);
        plot.barsAreHorizontal  = NO;
        plot.barOffset          = [[NSDecimalNumber decimalNumberWithString:@"0.0"]
                                   decimalValue];
        plot.dataSource         = self;
        plot.identifier         = set;
        [graph addPlot:plot];
    }
    
       [graph addPlot:sPlot];
    
    [graph addPlot:sPlot2 toPlotSpace:plotSpace];
    
}

#pragma mark - CPTPlotDataSource methods

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return xAxisLabels.count;
}

- (double)doubleForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    double num = NAN;
    
    //X Value
    if (fieldEnum == 0) {
        num = index;
    }
    
    else {
        if([plot.identifier isEqual:@""]){
            double offset = 0;
            if (((CPTBarPlot *)plot).barBasesVary) {
                for (NSString *set in [[sets allKeys] sortedArrayUsingSelector:@selector    (localizedCaseInsensitiveCompare:)]) {
                    if ([plot.identifier isEqual:set]) {
                        break;
                    }
                    offset += [[[data objectForKey:[xAxisLabels objectAtIndex:index]] objectForKey:set] doubleValue];
                }
            }
        
            //Y Value
            if (fieldEnum == 1) {
                num = [[[data objectForKey:[xAxisLabels objectAtIndex:index]] objectForKey:plot.identifier] doubleValue] + offset;
            }
        
            //Offset for stacked bar
            else {
                num = offset;
            }
        }else{
                        double offset = 0;
                for (NSString *set in [[sets allKeys] sortedArrayUsingSelector:@selector    (localizedCaseInsensitiveCompare:)]) {
                    if ([plot.identifier isEqual:set]) {
                        break;
                    }
                    offset += [[[data objectForKey:[xAxisLabels objectAtIndex:index]] objectForKey:set] doubleValue];
                }
            
            
            //Y Value
            if (fieldEnum == 1) {
                num = [[[data objectForKey:[xAxisLabels objectAtIndex:index]] objectForKey:plot.identifier] doubleValue] + offset - 0.2;
            }
            
            //Offset for stacked bar
            else {
                num = offset;
            }
        }
    }
    
    return num;
}

- (CPTPlotSymbol *)symbolForScatterPlot:(CPTScatterPlot *)plot recordIndex:(NSUInteger)index
{
    CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = [CPTColor clearColor];
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.lineStyle = symbolLineStyle;
    
    /*if (_selectedIndex != NSNotFound && index == _selectedIndex)
    {
        plotSymbol.symbolType = CPTPlotSymbolTypeDiamond;
        plotSymbol.size = CGSizeMake(12, 12);
        plotSymbol.fill = [CPTFill fillWithColor:[CPTColor redColor]];
    }
    else
    {*/
    if([plot.identifier isEqual:@"mainplot"]){
        plotSymbol.symbolType = CPTPlotSymbolTypeEllipse;
        plotSymbol.size = CGSizeMake(10, 10);
        if(index % 2 == 0){
            plotSymbol.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
            symbolLineStyle.lineColor = [CPTColor blackColor];
            plotSymbol.lineStyle = symbolLineStyle;
        }else{
            plotSymbol.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:(151.0 / 255.0) green:(147.0 / 255.0) blue:(187.0 / 255.0) alpha:1]];
        }
    }else{
        if(index % 2 == 0){
        plotSymbol.symbolType = CPTPlotSymbolTypeEllipse;
        plotSymbol.size = CGSizeMake(7, 7);
        plotSymbol.fill = [CPTFill fillWithColor:[CPTColor blackColor]];
        }
    }
    //}
    return plotSymbol;
}


@end
