//
//  BottlefeedingMonthlyGraph.m
//  Flatland
//
//  Created by Jochen Block on 13.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "BottlefeedingMonthlyGraph.h"
#import "BottleMonthly.h"

@interface BottlefeedingMonthlyGraph()
@property (nonatomic,copy) NSDictionary *data;
@property (nonatomic,copy) NSDictionary *sets;
@property (nonatomic, copy) NSArray *xAxisLabels;
@property (nonatomic,copy) NSString *yAxisTitle;
@property (nonatomic) int xMaxValue;
@property (nonatomic) int yMaxValue;
@end

@implementation BottlefeedingMonthlyGraph

- (void)createGraph
{
    [self icnhLocalizeView];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //reverse array
    self.bottles = [self.bottles reversedArray];
    
    // initialize a date formatter to get localized week names and month names
    NSDateFormatter *df = [NSDateFormatter new];
    [df setCalendar:calendar];
    [df setLocale:[calendar locale]];
    
    self.yAxisTitle = T(@"%bottlefeeding.yAxis");
    self.yMaxValue = 0;
    self.sets = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:(224.0 / 255.0) green:(193.0 / 255.0) blue:(129.0 / 255.0) alpha: 1], @"", nil];
    
    // get the number of month
    NSMutableArray *monthForYAxis = [NSMutableArray arrayWithCapacity:[self.bottles count]];
    NSMutableArray *monthFullName = [NSMutableArray arrayWithCapacity:[self.bottles count]];
    NSString *year = [[NSString alloc] init];
    NSString *yearStart = [[NSString alloc] init];
    for (NSUInteger i = 0; i < [self.bottles count]; i++){
        BottleMonthly *bottle = [self.bottles objectAtIndex:i];

        NSString * dateString = bottle.month;
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM"];
        NSDate* myDate = [dateFormatter dateFromString:dateString];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM"];
        NSString *stringFromDate = [formatter stringFromDate:myDate];
        //make Ox months in 4 letter format, remove dot
        if ([stringFromDate length] > 3) stringFromDate = [stringFromDate substringToIndex:4];
        //
        NSDateFormatter *formatterFullName = [[NSDateFormatter alloc] init];
        [formatterFullName setDateFormat:@"MMM"];
        NSString *stringFromDateFullName = [formatterFullName stringFromDate:myDate];
        if(i == 0){
            NSDateFormatter *formatterYear = [[NSDateFormatter alloc] init];
            [formatterYear setDateFormat:@"yyyy"];
            yearStart = [formatterYear stringFromDate:[[NSDate new] dateByAddingTimeInterval:-365*24*60*60]];
        }
        
        if(i == [self.bottles count] -1){
            NSDateFormatter *formatterYear = [[NSDateFormatter alloc] init];
            [formatterYear setDateFormat:@"yyyy"];
            year = [formatterYear stringFromDate:[NSDate new]];
        }
        
        [monthFullName addObject:stringFromDateFullName];
        [monthForYAxis addObject:stringFromDate];
    }
    
    self.xAxisLabels = monthForYAxis;
    self.xMaxValue = [_xAxisLabels count];
    
    if ([self.bottles count]) {
    NSString *labelText = [[NSString alloc] initWithFormat:@"%@ %@ - %@ %@", monthFullName[0], yearStart, monthFullName[[self.bottles count]-1], year];
    self.parentViewControler.descriptionLabelText = labelText;
        self.parentViewControler.shareStartDate = [[NSString alloc] initWithFormat:@"%@ %@",monthFullName[0], yearStart];
        self.parentViewControler.shareEndDate = [[NSString alloc] initWithFormat:@"%@ %@",monthFullName[[self.bottles count]-1], year];
    }
    NSMutableDictionary *dataTemp =[[NSMutableDictionary alloc] init];
    
    //aggregate data
    //int pos = 6;
    int pos = [self.bottles count]-1;
    for (NSUInteger i = 0; i < [self.bottles count]; i++){
        BottleMonthly *b = [self.bottles objectAtIndex:pos];
        //b.average = 4.5;
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
    
    CPTMutableTextStyle *xTextStyle = [CPTMutableTextStyle textStyle];
    xTextStyle.fontName = @"Helvetica";
    xTextStyle.fontSize = 9;
    xTextStyle.textAlignment = NSTextAlignmentCenter;
    xTextStyle.color = [CPTColor colorWithComponentRed:(52.0 / 255.0) green:(48.0 / 255.0) blue:(78.0 / 255.0) alpha:1];
    
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
    x.labelTextStyle = xTextStyle;
    
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
     switch (index) {
     case 0: case 1:
     {
        return [CPTFill fillWithColor:[CPTColor colorWithComponentRed:(224.0 / 255.0) green:(193.0 / 255.0) blue:(129.0 / 255.0) alpha: 1]];
        break;
     }
     case 2: case 3:
     {
        return [CPTFill fillWithColor:[CPTColor colorWithComponentRed:(135.0 / 255.0) green:(175.0 / 255.0) blue:(203.0 / 255.0) alpha:1]];
        break;
    }
     case 4: case 5:
     {
         return [CPTFill fillWithColor:[CPTColor colorWithComponentRed:(1940 / 255.0) green:(162.0 / 255.0) blue:(178.0 / 255.0) alpha:1]];
         break;
     }
     default:
         return [CPTFill fillWithColor:[CPTColor colorWithComponentRed:(169.0 / 255.0) green:(192.0 / 255.0) blue:(153.0 / 255.0) alpha:1]];
        break;
    }
 
     return nil;
 }

@end
