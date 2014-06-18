//
//  BottleFeedingWeeklyGraph.m
//  Flatland
//
//  Created by Jochen Block on 13.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "BottleFeedingWeeklyGraph.h"
#import "BottleWeekly.h"

@interface BottleFeedingWeeklyGraph()
@property (nonatomic,copy) NSDictionary *data;
@property (nonatomic,copy) NSDictionary *sets;
@property (nonatomic, copy) NSArray *xAxisLabels;
@property (nonatomic,copy) NSString *yAxisTitle;
@property (nonatomic) int xMaxValue;
@property (nonatomic) int yMaxValue;

@end

@implementation BottleFeedingWeeklyGraph
- (void)createGraph
{
    
    //reverse array
    self.bottles = [self.bottles reversedArray];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // initialize a date formatter to get localized week names and month names
    NSDateFormatter *df = [NSDateFormatter new];
    [df setCalendar:calendar];
    [df setLocale:[calendar locale]];
    
    self.yAxisTitle = T(@"%bottlefeeding.yAxis");
    self.yMaxValue = 0;
    self.sets = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:(224.0 / 255.0) green:(193.0 / 255.0) blue:(129.0 / 255.0) alpha: 1], @"", nil];
    
    // get the number of weeks
    NSMutableArray *weeksForYAxis = [NSMutableArray arrayWithCapacity:5];
    NSMutableArray *fullMonthNames = [NSMutableArray arrayWithCapacity:2];
    NSMutableArray *labelDates = [NSMutableArray arrayWithCapacity:2];
    NSString *year = [[NSString alloc] init];
    
    for (NSUInteger i = 0; i < [self.bottles count]; i++){
        BottleWeekly *bottle = [self.bottles objectAtIndex:i];
        
        NSDateFormatter *startDateFormatter = [[NSDateFormatter alloc] init];
        [startDateFormatter setDateFormat:@"dd"];
        
        if(i == 0)
        {
            [labelDates addObject:[startDateFormatter stringFromDate:bottle.startDate]];
            
            NSDateFormatter *startMonthFormatter = [[NSDateFormatter alloc] init];
            [startMonthFormatter setDateFormat:@"MMM"];
            NSString *month = [startMonthFormatter stringFromDate:bottle.startDate];
            [fullMonthNames addObject:month];
            
            NSDateFormatter *yearFormatter = [[NSDateFormatter alloc] init];
            [yearFormatter setDateFormat:@"yy"];
            year = [yearFormatter stringFromDate:[NSDate new]];
        }
        
        if(i == [self.bottles count] -1){
            [labelDates addObject:[startDateFormatter stringFromDate:bottle.endDate]];
            
            NSDateFormatter *endMonthFormatter = [[NSDateFormatter alloc] init];
            [endMonthFormatter setDateFormat:@"MMM"];
            NSString *month = [endMonthFormatter stringFromDate:bottle.endDate];
            [fullMonthNames addObject:month];
        }
        
        NSDateFormatter *endDateFormatter = [[NSDateFormatter alloc] init];
        NSDateFormatter *monthFormatter = [NSDateFormatter new];
        [endDateFormatter setDateFormat:@"dd"];
        [monthFormatter setDateFormat:@"MMM"];
        //NSString *label = [[NSString alloc] initWithFormat:@"%@ - %@%@",[startDateFormatter stringFromDate:bottle.startDate],[endDateFormatter stringFromDate:bottle.endDate], [monthFormatter stringFromDate:bottle.endDate]];
        NSString *label = [[NSString alloc] initWithFormat:@"%@ %@", [endDateFormatter stringFromDate:bottle.endDate], [monthFormatter stringFromDate:bottle.endDate]];
        [weeksForYAxis addObject:label];
    }
    self.xAxisLabels = weeksForYAxis;
    self.xMaxValue = [_xAxisLabels count];
    
    self.parentViewControler.descriptionLabelText = [[NSString alloc] initWithFormat:@"%@ %@ - %@ %@ %@",labelDates[0], fullMonthNames[0],labelDates[1], fullMonthNames[1],year ];
    self.parentViewControler.shareStartDate = [[NSString alloc] initWithFormat:@"%@ %@",labelDates[0], fullMonthNames[0]];
    self.parentViewControler.shareEndDate = [[NSString alloc] initWithFormat:@"%@ %@ %@",labelDates[1], fullMonthNames[1],year];
    
    NSMutableDictionary *dataTemp =[[NSMutableDictionary alloc] init];
    
    //aggregate data
    int pos = 4;
    for (NSUInteger i = 0; i < [self.bottles count]; i++){
            BottleWeekly *b = [self.bottles objectAtIndex:pos];
            //b.average = 6.5;
            if(self.yMaxValue < b.average)
            {
                self.yMaxValue = b.average;
            }
                
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:[NSNumber numberWithFloat:b.average] forKey:@"average"];
            [dataTemp setObject:dict forKey:self.xAxisLabels[pos]];
            pos--;
        }
    
    
    self.data = dataTemp;
    
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
    graph.paddingTop                    = 10.0f;
    if(_xMaxValue == 5){
        graph.paddingRight                  = 20.0f;
    }else{
        graph.paddingRight                  = 10.0f;
    }
	graph.paddingBottom                 = 24.0f;
    
    CPTMutableLineStyle *borderLineStyle    = [CPTMutableLineStyle lineStyle];
	borderLineStyle.lineColor               = [CPTColor whiteColor];
	borderLineStyle.lineWidth               = 0.0f;
	graph.plotAreaFrame.borderLineStyle     = nil;
	graph.plotAreaFrame.paddingTop          = 0.0;
	graph.plotAreaFrame.paddingRight        = 0.0;
	graph.plotAreaFrame.paddingBottom       = 10.0;
	graph.plotAreaFrame.paddingLeft         = 30.0;
    
	//Add plot space
	CPTXYPlotSpace *plotSpace       = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.delegate              = self;
	plotSpace.yRange                = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0)
                                                                   length:CPTDecimalFromInt(self.yMaxValue + 1)];
	plotSpace.xRange                = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(-0.85)
                                                                   length:CPTDecimalFromDouble(self.xMaxValue + 0.85)];
    
    //Grid line styles
	CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
	majorGridLineStyle.lineWidth            = 0.0;
	majorGridLineStyle.lineColor            = [[CPTColor whiteColor] colorWithAlphaComponent:1.0];
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
	minorGridLineStyle.lineWidth            = 0.0;
	minorGridLineStyle.lineColor            = [[CPTColor whiteColor] colorWithAlphaComponent:1.0];
    
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.fontName = @"Helvetica";
    textStyle.fontSize = 10;
    textStyle.textAlignment = NSTextAlignmentCenter;
    textStyle.color = [CPTColor colorWithComponentRed:(52.0 / 255.0) green:(48.0 / 255.0) blue:(78.0 / 255.0) alpha:1];
    CPTMutableTextStyle *yTextStyle = [CPTMutableTextStyle textStyle];
    yTextStyle.fontName = @"Helvetica";
    yTextStyle.fontSize = 9;
    yTextStyle.textAlignment = NSTextAlignmentCenter;
    yTextStyle.color = [CPTColor colorWithComponentRed:(52.0 / 255.0) green:(48.0 / 255.0) blue:(78.0 / 255.0) alpha:1];    
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
    for (NSString *labelText in _xAxisLabels) {
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
    y.labelingPolicy        = CPTAxisLabelingPolicyFixedInterval;
    y.axisConstraints       = [CPTConstraints constraintWithLowerOffset:0.0];
    y.titleTextStyle = yTextStyle;
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
    
    //Plot
    BOOL firstPlot = YES;
    for (NSString *set in [[self.sets allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]) {
        CPTBarPlot *plot        = [CPTBarPlot tubularBarPlotWithColor:[CPTColor blueColor] horizontalBars:NO];
        plot.cornerRadius = 20.0;
        plot.lineStyle          = barLineStyle;
        CGColorRef color        = ((UIColor *)[self.sets objectForKey:set]).CGColor;
        plot.fill               = [CPTFill fillWithColor:[CPTColor colorWithCGColor:color]];
        if (firstPlot) {
            plot.barBasesVary   = NO;
            firstPlot           = NO;
        } else {
            plot.barBasesVary   = YES;
        }
        plot.barWidth           = CPTDecimalFromFloat(0.3f);
        plot.barsAreHorizontal  = NO;
        plot.barOffset          = [[NSDecimalNumber decimalNumberWithString:@"0.0"]
                                   decimalValue];
        plot.dataSource         = self;
        plot.identifier         = set;
        [graph addPlot:plot toPlotSpace:plotSpace];
        //Ionel animation
        plot.anchorPoint = CGPointMake(0.0, 0.0);
        CABasicAnimation *scaling = [CABasicAnimation
                                     animationWithKeyPath:@"transform.scale.y"]; //
        scaling.fromValue = [NSNumber numberWithFloat:0.0];
        scaling.toValue = [NSNumber numberWithFloat:1.0];
        scaling.duration = 1; // Duration
        scaling.removedOnCompletion = NO;
        scaling.fillMode = kCAFillModeForwards;
        [plot addAnimation:scaling forKey:@"scaling"];
    }
}

#pragma mark - CPTPlotDataSource methods

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return _xAxisLabels.count;
}

- (double)doubleForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    double num = NAN;
    
    //X Value
    if (fieldEnum == 0) {
        num = index;
    }
    
    else {
        double offset = 0;
        if (((CPTBarPlot *)plot).barBasesVary) {
            for (NSString *set in [[self.sets allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]) {
                if ([plot.identifier isEqual:set]) {
                    break;
                }
                offset += [[[self.data objectForKey:[_xAxisLabels objectAtIndex:index]] objectForKey:@"average"] doubleValue];
            }
        }
        
        //Y Value
        if (fieldEnum == 1) {
            num = [[[self.data objectForKey:[_xAxisLabels objectAtIndex:index]] objectForKey:@"average"] doubleValue] + offset;
        }
        
        //Offset for stacked bar
        else {
            num = offset;
        }
    }
    
    return num;
}
@end
