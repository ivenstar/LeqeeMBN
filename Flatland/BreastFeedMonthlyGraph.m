//
//  BreastFeedMonthlyGraph.m
//  Flatland
//
//  Created by Pirlitu Vasilica on 12/10/13.
//  Copyright (c) 2013 Optaros. All rights reserved.
//

#import "BreastFeedMonthlyGraph.h"
#import "BreastWeekly.h"


@interface BreastFeedMonthlyGraph()

@property (nonatomic,copy) NSDictionary *sets;
@property (nonatomic,copy) NSArray *xAxisLabels;
@property (nonatomic,copy) NSString *yAxisTitle;
@property (nonatomic) int xMaxValue;
@property (nonatomic,copy) NSDictionary *data;
@property (nonatomic) int yMaxValue;

@end

@implementation BreastFeedMonthlyGraph


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@synthesize pinScale;
- (void)createGraph {
    self.breastfeedings = [self.breastfeedings reversedArray];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // initialize a date formatter to get localized week names and month names
    NSDateFormatter *df = [NSDateFormatter new];
    [df setCalendar:calendar];
    [df setLocale:[calendar locale]];
    
    self.yAxisTitle = T(@"%breastfeeding.feedingPerHour");
    
    self.sets = @{T(@"%breastfeeding.left"): [UIColor colorWithRGBString:@"#4b4a63"],
                  T(@"%breastfeeding.right"): [UIColor colorWithRGBString:@"#9793bb"]};
    
    self.yMaxValue = 0;
    
    // get the number of weeks
    NSMutableArray *weeksForYAxis = [NSMutableArray arrayWithCapacity:5];
    NSMutableArray *fullMonthNames = [NSMutableArray arrayWithCapacity:2];
    NSMutableArray *labelDates = [NSMutableArray arrayWithCapacity:2];
    NSString *year = [[NSString alloc] init];
    
    for (NSUInteger i = 0; i < [self.breastfeedings count]; i++){
        BreastWeekly *breast = [self.breastfeedings objectAtIndex:i];
        
        NSDateFormatter *startDateFormatter = [[NSDateFormatter alloc] init];
        [startDateFormatter setDateFormat:@"dd"];
        
        if(i == 0)
        {
            [labelDates addObject:[startDateFormatter stringFromDate:breast.date]];
            
            NSDateFormatter *startMonthFormatter = [[NSDateFormatter alloc] init];
            [startMonthFormatter setDateFormat:@"MMM"];
            NSString *month = [startMonthFormatter stringFromDate:breast.date];
            [fullMonthNames addObject:month];
            
            NSDateFormatter *yearFormatter = [[NSDateFormatter alloc] init];
            [yearFormatter setDateFormat:@"yy"];
            year = [yearFormatter stringFromDate:[NSDate new]];
        }
        
        if(i == [self.breastfeedings count] -1){
            [labelDates addObject:[startDateFormatter stringFromDate:breast.date]];
            
            NSDateFormatter *endMonthFormatter = [[NSDateFormatter alloc] init];
            [endMonthFormatter setDateFormat:@"MMM"];
            NSString *month = [endMonthFormatter stringFromDate:breast.date];
            [fullMonthNames addObject:month];
        }
        
        NSDateFormatter *endDateFormatter = [[NSDateFormatter alloc] init];
        NSDateFormatter *monthFormatter = [NSDateFormatter new];
        [endDateFormatter setDateFormat:@"dd"];
        [monthFormatter setDateFormat:@"MMM"];
        //NSString *label = [[NSString alloc] initWithFormat:@"%@ - %@%@",[startDateFormatter stringFromDate:bottle.startDate],[endDateFormatter stringFromDate:bottle.endDate], [monthFormatter stringFromDate:bottle.endDate]];
        NSString *label = [[NSString alloc] initWithFormat:@"%@ %@", [endDateFormatter stringFromDate:breast.date], [monthFormatter stringFromDate:breast.date]];
        if (breast.breastSide == BreastsideLeft)
        [weeksForYAxis addObject:label];
    }
    self.xAxisLabels = weeksForYAxis;
    self.xMaxValue = [_xAxisLabels count];
    self.parentVC.descriptionText = [[NSString alloc] initWithFormat:@"%@ %@ - %@ %@ %@",labelDates[0], fullMonthNames[0],labelDates[1], fullMonthNames[1], year];
    self.parentVC.shareStartDate = [[NSString alloc] initWithFormat:@"%@ %@",labelDates[0], fullMonthNames[0]];
    self.parentVC.shareEndDate = [[NSString alloc] initWithFormat:@"%@ %@ %@",labelDates[1], fullMonthNames[1],year];
    //self.parentViewControler.descriptionLabelText = [[NSString alloc] initWithFormat:@"%@ %@ - %@ %@ %@",labelDates[0], fullMonthNames[0],labelDates[1], fullMonthNames[1],year ];
    
    NSMutableDictionary *dataTemp =[[NSMutableDictionary alloc] init];
    
    //aggregate data
    int pos = 0;
    int k = 0;
    while (k<=8)
    {
        BreastWeekly *b = [self.breastfeedings objectAtIndex:k];
        BreastWeekly *br = [self.breastfeedings objectAtIndex:k+1];
        //b.average = 1.5;
        //br.average = 2.7;
        if(self.yMaxValue < b.average)
        {
            self.yMaxValue = b.average;
        }
        
        if(self.yMaxValue < br.average)
        {
            self.yMaxValue = br.average;
        }
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if (br.breastSide == BreastsideLeft) {
            [dict setObject:[NSNumber numberWithFloat:br.average] forKey:T(@"%breastfeeding.left")];
            [dict setObject:[NSNumber numberWithFloat:b.average] forKey:T(@"%breastfeeding.right")];
        }
        //else if (b.breastSide == BreastsiteRight)
        //    [dict setObject:[NSNumber numberWithInt:b.average] forKey:T(@"%breastfeeding.right")];
        
        [dataTemp setObject:dict forKey:self.xAxisLabels[pos]];
        pos++;
        k+=2;
    }
    
    
    self.data = dataTemp;
    
///////////////////////
    
    ///////
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    
//    // initialize a date formatter to get localized week names and month names
//    NSDateFormatter *df = [NSDateFormatter new];
//    [df setCalendar:calendar];
//    [df setLocale:[calendar locale]];
//    
//    self.yAxisTitle = T(@"%breastfeeding.feedingPerHour");
//    
//    self.sets = @{T(@"%breastfeeding.left"): [UIColor colorWithRGBString:@"#4b4a63"],
//                  T(@"%breastfeeding.right"): [UIColor colorWithRGBString:@"#9793bb"]};
//    
//    //calculate the the day 7 days ago from the start day
//    NSDateComponents *startDayComps = [calendar components:NSWeekdayCalendarUnit fromDate:[self.startDate dateByAddingTimeInterval:-7*24*60*60]];
//    
//    // get the number of this day
//    NSInteger startDayIndex = [startDayComps weekday] - 1;
//    NSMutableArray *weekdaysForYAxis = [NSMutableArray arrayWithCapacity:7];
//    for (NSUInteger last7DaysIndex = 0; last7DaysIndex < 7; last7DaysIndex++){
//        [weekdaysForYAxis insertObject:[[df shortStandaloneWeekdaySymbols][startDayIndex] capitalizedString] atIndex:last7DaysIndex];
//        startDayIndex--;
//        if(startDayIndex < 0)
//            startDayIndex = 6;
//    }
//    self.xAxisLabels = [[weekdaysForYAxis reverseObjectEnumerator] allObjects];
//    self.xMaxValue = [_xAxisLabels count];
    
    //NSMutableDictionary *dataTemp = [[NSMutableDictionary alloc] init];
    
//    //aggregate data
//    for (NSUInteger i = 0; i < [self.xAxisLabels count]; i++) {
//        NSInteger left = 0;
//        NSInteger right = 0;
//        for (BreastWeekly *b in self.breastfeedings)
//        {
//            NSDateComponents *comps = [calendar components:NSWeekdayCalendarUnit fromDate:b.date];
//            if ([self.xAxisLabels[i] isEqualToString: [[df shortStandaloneWeekdaySymbols][[comps weekday] - 1] capitalizedString]]) {
//                if (b.breastSide == BreastsideLeft)
//                {
//                    left++;
//                }
//                else
//                {
//                    right++;
//                }
//            }
//        }
    
        //find the maximum value
        //self.yMaxValue = left > self.yMaxValue ? left : (right > self.yMaxValue ? right : self.yMaxValue);
        
        //Ionel: hardcoded values
        //left = 2.5 + (rand()%2);
        //right = 1.5 + (rand()%3);
        ///
        
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        [dict setObject:[NSNumber numberWithInt:left] forKey:T(@"%breastfeeding.left")];
//        [dict setObject:[NSNumber numberWithInt:right] forKey:T(@"%breastfeeding.right")];
//        
//        [dataTemp setObject:dict forKey:self.xAxisLabels[i]];
//    }
//    
//    self.yMaxValue = 3;
//    
//    self.data = dataTemp;
    
    //Generate layout
    [self generateLayout];
}


- (void)generateLayout {
    
    //Create graph from theme
    graph     = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    
	self.hostedGraph                    = graph;
    graph.plotAreaFrame.masksToBorder   = NO;
    graph.paddingLeft                   = 23.0f;
    graph.paddingTop                    = 10.0f;
    graph.paddingRight                  = 20.0f;
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
    textStyle.color = [CPTColor colorWithComponentRed:(52.0 / 255.0) green:(48.0 / 255.0) blue:(78.0 / 255.0) alpha:1]; //Ionel: before: [CPTColor colorWithComponentRed:(151.0 / 255.0) green:(147.0 / 255.0) blue:(187.0 / 255.0) alpha:1];
    
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
    for (NSString *labelText in self.xAxisLabels) {
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
    y.titleTextStyle = textStyle;
    y.labelTextStyle = textStyle;
    y.minorTickLineStyle = nil;
    y.majorGridLineStyle = nil;
    y.majorTickLineStyle = nil;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:0];
    y.labelFormatter = formatter;
    
    
    /////////
    
    
    ///////////
    
    
    
    //Create a bar line style
    CPTMutableLineStyle *barLineStyle   = [[CPTMutableLineStyle alloc] init];
    barLineStyle.lineWidth              = 0.0;
    barLineStyle.lineColor              = [CPTColor whiteColor];
    
    //Plot
    BOOL firstPlot = YES;
    for (NSString *set in [[self.sets allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]) {
        CPTBarPlot *plot        = [CPTBarPlot tubularBarPlotWithColor:[CPTColor blueColor] horizontalBars:NO];
        plot.cornerRadius = 20.0;
        plot.lineStyle          = barLineStyle;
        CGColorRef color        = ((UIColor *)[self.sets objectForKey:set]).CGColor;
        plot.fill               = [CPTFill fillWithColor:[CPTColor colorWithCGColor:color]];
        if (firstPlot) {
            firstPlot           = NO;
            plot.barOffset      = CPTDecimalFromFloat(-0.2f);
        } else {
            plot.barOffset      = CPTDecimalFromFloat(0.2f);
        }
        plot.barWidth           = CPTDecimalFromFloat(0.3f);
        plot.barsAreHorizontal  = NO;
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
    
//    //Add legend
//    CPTLegend *theLegend      = [CPTLegend legendWithGraph:graph];
//    theLegend.numberOfRows	  = 1;
//    theLegend.swatchSize	  = CGSizeMake(10.0, 10.0);
//    theLegend.textStyle       = textStyle;
//    theLegend.paddingLeft	  = 10.0;
//    theLegend.paddingTop	  = 10.0;
//    theLegend.paddingRight	  = 10.0;
//    graph.legend              = theLegend;
//    graph.legendAnchor        = CPTRectAnchorBottomRight;
//    graph.legendDisplacement  = CGPointMake(0.0, -5.0);
}

#pragma mark - CPTPlotDataSource methods

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [self.xAxisLabels count];
}

- (double)doubleForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    double num = NAN;
    
    if ( [plot isKindOfClass:[CPTBarPlot class]] ) {
        switch ( fieldEnum ) {
            case CPTBarPlotFieldBarLocation:
                num = [[NSNumber numberWithInteger:index] doubleValue];
                break;
                
            case CPTBarPlotFieldBarTip:
                for (NSString *set in [[self.sets allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]) {
                    if ([plot.identifier isEqual:set]) {
                        num = [[[self.data objectForKey:[self.xAxisLabels objectAtIndex:index]] objectForKey:set] doubleValue];
                    }
                }
                break;
        }
    }
    return num;
}


@end
