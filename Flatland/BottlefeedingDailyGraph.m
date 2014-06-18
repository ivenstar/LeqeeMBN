//
//  BottlefeedingDailyGraph.m
//  Flatland
//
//  Created by Jochen Block on 13.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "BottlefeedingDailyGraph.h"
#import "BottleDaily.h"

@interface BottlefeedingDailyGraph()
@property (nonatomic,copy) NSDictionary *data;
@property (nonatomic,copy) NSDictionary *sets;
@property (nonatomic, retain) NSMutableArray *weekdays;
@property (nonatomic, copy) NSArray *xAxisLabels;
@property (nonatomic,copy) NSString *yAxisTitle;
@property (nonatomic) int xMaxValue;
@property (nonatomic) int yMaxValue;

@end

@implementation BottlefeedingDailyGraph
- (void)createGraph
{
    
    self.weekdays = [[NSMutableArray alloc] init];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // initialize a date formatter to get localized week names and month names
    NSDateFormatter *df = [NSDateFormatter new];
    [df setCalendar:calendar];
    [df setLocale:[calendar locale]];
    
    self.yAxisTitle = T(@"%bottlefeeding.yAxis");
    self.yMaxValue = 0;
    self.sets = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:(224.0 / 255.0) green:(193.0 / 255.0) blue:(129.0 / 255.0) alpha: 1], @"", nil];
    
    //calculate the the day 7 days ago from the start day
    NSDateComponents *startDayComps = [calendar components:NSWeekdayCalendarUnit fromDate:[self.startDate dateByAddingTimeInterval:-7*24*60*60]];
    
    // get the number of this day
    NSInteger startDayIndex = [startDayComps weekday] - 1;
    NSMutableArray *weekdaysForYAxis = [NSMutableArray arrayWithCapacity:7];
    for (NSUInteger last7DaysIndex = 0; last7DaysIndex < 7; last7DaysIndex++){
        [weekdaysForYAxis insertObject:[[df shortStandaloneWeekdaySymbols][startDayIndex] capitalizedString] atIndex:last7DaysIndex];
        startDayIndex--;
        if(startDayIndex < 0)
            startDayIndex = 6;
    }
    self.xAxisLabels = [[weekdaysForYAxis reverseObjectEnumerator] allObjects];
    self.xMaxValue = [_xAxisLabels count];
    
    NSMutableDictionary *dataTemp =[[NSMutableDictionary alloc] init];
    
    //aggregate data
    //Ionel temp data
   // for (NSUInteger k = 0; k < [self.xAxisLabels count]; k++)
   // [self.bottles addObject:[[BottleDaily alloc] initWithTime:(rand()%3)]];
     
        //
    for (NSUInteger i = 0; i < [self.xAxisLabels count]; i++) {
        
        for (BottleDaily *b in self.bottles) {
            NSDateComponents *comps = [calendar components:NSWeekdayCalendarUnit fromDate:b.date];
            if ([self.xAxisLabels[i] isEqualToString: [[df shortStandaloneWeekdaySymbols][[comps weekday] - 1] capitalizedString]]) {
                //b.times = 2.5;
                if(self.yMaxValue < b.times)
                {
                    self.yMaxValue = b.times;
                }
                
                NSDateFormatter *nowDateFormatter = [[NSDateFormatter alloc] init];
                [nowDateFormatter setDateFormat:@"c"];
                int weekdayNumber = [[nowDateFormatter stringFromDate:b.date] integerValue];
                [self.weekdays insertObject:[[NSNumber alloc] initWithInt:weekdayNumber] atIndex:i];
                //Ionel Hardcoded data for POC - keep it random
                //b.times = i + (rand()%7)/3;
                //
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:[NSNumber numberWithFloat:b.times] forKey:@"average"];
                [dataTemp setObject:dict forKey:self.xAxisLabels[i]];
            }
        }
//        //Ionel hardcode data;
//        float aux = 0.4 + (rand()%2)/2;
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        [dict setObject:[NSNumber numberWithFloat:aux] forKey:@"average"];
//        [dataTemp setObject:dict forKey:self.xAxisLabels[i]];
        ////
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
    //Ionel: enable user interaction for zoom to work
    //[plotSpace setAllowsUserInteraction:YES];
    
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
    textStyle.color = [CPTColor colorWithComponentRed:(52.0 / 255.0) green:(48.0 / 255.0) blue:(78.0 / 255.0) alpha:1]; //Ionel before:[CPTColor colorWithComponentRed:(151.0 / 255.0) green:(147.0 / 255.0) blue:(187.0 / 255.0) alpha:1];
    
    CPTMutableTextStyle *yTextStyle = [CPTMutableTextStyle textStyle];
    yTextStyle.fontName = @"Helvetica";
    yTextStyle.fontSize = 10;
    yTextStyle.textAlignment = NSTextAlignmentCenter;
    yTextStyle.color = [CPTColor colorWithComponentRed:(52.0 / 255.0) green:(48.0 / 255.0) blue:(78.0 / 255.0) alpha:1]; //Ionel before: [CPTColor colorWithComponentRed:(151.0 / 255.0) green:(147.0 / 255.0) blue:(187.0 / 255.0) alpha:1];
    
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

- (CPTFill *)barFillForBarPlot:(CPTBarPlot *)plot recordIndex:(NSUInteger)index
 {
     if(self.weekdays){
         if(self.weekdays && [self.weekdays count] > 0){
         int item = [[self.weekdays objectAtIndex:index] intValue];

         if (item == 7 || item == 1) {
            return [CPTFill fillWithColor:[CPTColor colorWithComponentRed:(151.0 / 255.0) green:(147.0 / 255.0) blue:(187.0 / 255.0) alpha:1]];
         }
         }
     }
     return nil;
 }
@end
