////
////  BabyWeightMonthlyGraph.m
////  Flatland
////
////  Created by Pirlitu Vasilica on 12/11/13.
////  Copyright (c) 2013 Optaros. All rights reserved.
////
//
//#import "BabyWeightMonthlyGraph.h"
//
//@implementation BabyWeightMonthlyGraph
//
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}
//
///*
//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//}
//*/
//
//@end
//

//
//  BabyWeightGraph.m
//  Flatland
//
//  Created by Jochen Block on 14.05.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "BabyWeightMonthlyGraph.h"
#import "Weight.h"
#import "WeightGraphLandscapeVC.h"

@interface BabyWeightMonthlyGraph()

@property (nonatomic,copy) NSDictionary *data;
@property (nonatomic,copy) NSDictionary *sets;
@property (nonatomic, retain) NSMutableArray *weekdays;
@property (nonatomic, copy) NSArray *xAxisLabels;
@property (nonatomic, copy) NSMutableArray *yAxisLabels;
@property (nonatomic,copy) NSString *yAxisTitle;
@property (nonatomic) int xMaxValue;
@property (nonatomic) int yMaxValue;
@property (nonatomic) CGRect rect;
@property (nonatomic) NSMutableArray *positionsX;
@property (nonatomic) NSMutableArray *positionsY;
@property (nonatomic) NSArray
*hcData;

@property (nonatomic,copy) NSMutableDictionary *dataTemp;
@property (nonatomic,copy) NSMutableDictionary *dict;

@end

@implementation BabyWeightMonthlyGraph
@synthesize pinScale;
- (id)initWithFrame:(CGRect)frame {
    // force the correct size
    
    
    _rect = frame;
    
    self = [super initWithFrame:frame];
    
    NSLog(@"Pinscale:: %f", pinScale);
    _hcData = [NSArray arrayWithObjects:@"3.7 kg", @"4 kg", @"4.7 kg", @"5.8 kg", @"7 kg", nil];
    return self;
}

- (void)createGraph
{
    _positionsX = [[NSMutableArray alloc] init];
    _positionsY = [[NSMutableArray alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // initialize a date formatter to get localized week names and month names
    NSDateFormatter *df = [NSDateFormatter new];
    [df setCalendar:calendar];
    [df setLocale:[calendar locale]];
    
    self.yAxisTitle = @"kg"; //before: @"kg";
    self.yMaxValue = 0;
    self.sets = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:(224.0 / 255.0) green:(193.0 / 255.0) blue:(129.0 / 255.0) alpha: 1], @"", nil];
    
    // get the number of weeks
    NSMutableArray *weeksForYAxis = [NSMutableArray arrayWithCapacity:5];
    NSMutableArray *fullMonthNames = [NSMutableArray arrayWithCapacity:2];
    NSMutableArray *labelDates = [NSMutableArray arrayWithCapacity:2];
    NSString *year = [[NSString alloc] init];
    //NSMutableArray *weightY = [NSMutableArray arrayWithCapacity:5];
    for (NSUInteger i = 0; i < [self.weights count]; i++){
        Weight *weight = [self.weights objectAtIndex:i];
        
        NSDateFormatter *startDateFormatter = [[NSDateFormatter alloc] init];
        [startDateFormatter setDateFormat:@"dd"];
        
        if(i == 0){
            [labelDates addObject:[startDateFormatter stringFromDate:weight.endDate]];
            
            NSDateFormatter *startMonthFormatter = [[NSDateFormatter alloc] init];
            [startMonthFormatter setDateFormat:@"MMM"];
            NSString *month = [startMonthFormatter stringFromDate:weight.startDate];
            [fullMonthNames addObject:month];
            
            NSDateFormatter *yearFormatter = [[NSDateFormatter alloc] init];
            [yearFormatter setDateFormat:@"yyyy"];
            year = [yearFormatter stringFromDate:[NSDate new]];
        }
        
        if(i == [self.weights count] -1){
            [labelDates addObject:[startDateFormatter stringFromDate:weight.startDate]];
            
            NSDateFormatter *endMonthFormatter = [[NSDateFormatter alloc] init];
            [endMonthFormatter setDateFormat:@"MMM"];
            NSString *month = [endMonthFormatter stringFromDate:weight.endDate];
            [fullMonthNames addObject:month];
        }
        
        NSDateFormatter *endDateFormatter = [[NSDateFormatter alloc] init];
        [endDateFormatter setDateFormat:@"dd'\n'MMM"];
        
        NSString *label = [[NSString alloc] initWithFormat:@"%@ - %@",[startDateFormatter stringFromDate:weight.startDate],[endDateFormatter stringFromDate:weight.endDate]];
        [weeksForYAxis insertObject:label atIndex:i];
    }
    self.xAxisLabels = [[weeksForYAxis reverseObjectEnumerator] allObjects];
    self.xMaxValue = [_xAxisLabels count];
    
    if ([self.weights count]){
        self.parentViewControler.descriptionLabelText = [[NSString alloc] initWithFormat:@"%@ %@ - %@ %@ %@",labelDates[1], fullMonthNames[1],labelDates[0], fullMonthNames[0],year ];
        //self.parentViewControler.descriptionLabel.text = [[NSString alloc] initWithFormat:@"%@ %@ - %@ %@ %@",labelDates[1], fullMonthNames[1],labelDates[0], fullMonthNames[0],year ];
    }

    _dict = [[NSMutableDictionary alloc] init];
    _dataTemp = [[NSMutableDictionary alloc] init];
    _values = [[NSMutableArray alloc] initWithCapacity:180];
    //aggregate data
    int pos = [self.weights count] - 1;
    NSLog(@"Plot values::");
    
    for (NSUInteger j = 0; j < [self.weights count]; j++) {
        Weight *b = [self.weights objectAtIndex:j];
        //override for testing
        //b.weight = 10-j - 1.2*sqrt(j);
        ///
        NSLog(@"Punct %d : %f", j, b.weight);
        if(self.yMaxValue < b.weight)
        {
            self.yMaxValue = b.weight;
        }
        
        
        _dict = [[NSMutableDictionary alloc] init];
        [_dict setObject:[NSNumber numberWithDouble:b.weight] forKey:@"weight"];
        NSLog(@"eee: %@", [NSNumber numberWithDouble:b.weight]);
        [_dataTemp setObject:_dict forKey:self.xAxisLabels[pos]];
        pos--;
        NSLog(@"%f .. ", b.weight);
    }
    
    
    _data = _dataTemp;
    
    
    
    //Generate layout
    [self generateLayout];
}

- (void)generateLayout
{
    CGRect aRect = _rect;
    //Create graph from theme
	graph                               = [[CPTXYGraph alloc] initWithFrame:aRect];
    
	self.hostedGraph                    = graph;
    //Ionel: enable zoom
    self.allowPinchScaling = TRUE;
    ///
    graph.plotAreaFrame.masksToBorder   = NO;
    graph.paddingLeft                   = 23.0f;
    graph.paddingTop                    = 10.0f;
    if(self.xMaxValue == 5){
        graph.paddingRight              = 20.0f;
    }else{
        graph.paddingRight              = 0.0f;
    }
	graph.paddingBottom                 = 35.0f;
    
    CPTMutableLineStyle *borderLineStyle    = [CPTMutableLineStyle lineStyle];
	borderLineStyle.lineColor               = [CPTColor whiteColor];
	borderLineStyle.lineWidth               = 0.0f;
	graph.plotAreaFrame.borderLineStyle     = nil;
	graph.plotAreaFrame.paddingTop          = 0.0;
	graph.plotAreaFrame.paddingRight        = 0.0;
	graph.plotAreaFrame.paddingBottom       = 0.0;
	graph.plotAreaFrame.paddingLeft         = 25.0; //Ionel: before 30
    
	//Add plot space
	CPTXYPlotSpace *plotSpace       = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    
    //Ionel: enable user interaction for zoom to work
    [plotSpace setAllowsUserInteraction:YES];
    ///
    plotSpace.delegate              = self;
	plotSpace.yRange                = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0)
                                                                   length:CPTDecimalFromDouble(self.yMaxValue + 2)];
	plotSpace.xRange                = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(-0.65)
                                                                   length:CPTDecimalFromInt(self.xMaxValue + 0.65)];
    
    //Grid line styles
	CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
	majorGridLineStyle.lineWidth            = 0.0;
	majorGridLineStyle.lineColor            = [[CPTColor whiteColor] colorWithAlphaComponent:1.0];
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
	minorGridLineStyle.lineWidth            = 0.0;
	minorGridLineStyle.lineColor            = [[CPTColor whiteColor] colorWithAlphaComponent:1.0];
    
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    //textStyle.fontName = @"Helvetica";
    textStyle.fontSize = 10 + pinScale/5;
    textStyle.textAlignment = NSTextAlignmentCenter;
    textStyle.color = [CPTColor colorWithComponentRed:(52.0 / 255.0) green:(48.0 / 255.0) blue:(78.0 / 255.0) alpha:1];//[CPTColor colorWithComponentRed:(151.0 / 255.0) green:(147.0 / 255.0) blue:(187.0 / 255.0) alpha:1];
    
    
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
    
    // Define some custom labels for the data elements
    CPTXYAxis *y                    = axisSet.yAxis;
    y.title                 = self.yAxisTitle;
    y.titleOffset           = 26.0f;
    y.orthogonalCoordinateDecimal   = CPTDecimalFromInt(0);
	y.majorIntervalLength           = CPTDecimalFromInt(1);
    y.minorTicksPerInterval = 1;
    y.axisLineStyle = nil;
    y.labelingPolicy        = CPTAxisLabelingPolicyAutomatic; //before Automatic
    y.axisConstraints       = [CPTConstraints constraintWithLowerOffset:0.0];
    y.titleTextStyle = textStyle;
    y.labelTextStyle = textStyle;
    y.minorTickLineStyle = nil;
    y.majorGridLineStyle = nil;
    y.majorTickLineStyle = nil;
    //y.majorIntervalLength = CPTDecimalFromInt(self.yMaxValue / 2.5); //before nil
    ///////
    NSArray *customTickLocations = [NSArray arrayWithObjects:[NSDecimalNumber numberWithInt:2], [NSDecimalNumber numberWithInt:5], [NSDecimalNumber numberWithInt:8], [NSDecimalNumber numberWithInt:11], nil];
    //    int g = self.yMaxValue + 2;
    //    NSMutableArray *yAxisLabels = [[NSMutableArray alloc] init];
    //    for (int j=0; j< 4; j++){
    //        NSString *aux = [NSString stringWithFormat:@"%d kg", g/(j-3)];
    //        [yAxisLabels addObject:aux] ;
    //    }
    
    //    NSArray *yAxisLabels = [NSArray arrayWithArray:aux];
    NSArray *yAxisLabels = [NSArray arrayWithObjects:@"2 kg", @"4 kg", @"6 kg", @"8 kg", nil];
    NSUInteger labelLocation = 0;
    NSMutableArray *customLabels = [NSMutableArray arrayWithCapacity:[yAxisLabels count]];
    for (NSNumber *tickLocation in customTickLocations) {
        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText: [yAxisLabels objectAtIndex:labelLocation++] textStyle:x.labelTextStyle];
        newLabel.tickLocation = [tickLocation decimalValue];
        newLabel.offset = x.labelOffset + x.majorTickLength;
        //newLabel.rotation = M_PI/4;
        [customLabels addObject:newLabel];
        
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:0];
    y.labelFormatter = formatter;
    //y.axisLabels =  [NSSet setWithArray:customLabels];
    
    /*
     //X axis
     CPTXYAxis *y                    = axisSet.yAxis;
     y.orthogonalCoordinateDecimal   = CPTDecimalFromInt(0);
     y.majorIntervalLength           = CPTDecimalFromInt(1);
     y.minorTicksPerInterval         = 0;
     y.labelingPolicy                = CPTAxisLabelingPolicyNone;
     y.axisConstraints               = [CPTConstraints constraintWithLowerOffset:0.0];
     y.axisLineStyle = nil;
     y.labelTextStyle = textStyle;
     self.yAxisLabels = [[NSMutableArray alloc] init];
     int g = self.yMaxValue + 2;
     for (int j=0; j< 3; j++){
     NSString *aux = [NSString stringWithFormat:@"%d kg", g/(j+1)];
     [self.yAxisLabels addObject:aux] ;
     }
     
     //Y labels
     labelLocations = 0;
     NSMutableArray *customYLabels = [NSMutableArray array];
     for (NSString *labelText in self.yAxisLabels) {
     CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:labelText textStyle:x.labelTextStyle];
     newLabel.tickLocation   = [[NSNumber numberWithInt:labelLocations] decimalValue];
     newLabel.offset         = y.labelOffset + y.majorTickLength;
     //newLabel.rotation       = M_PI / 3;
     [customYLabels addObject:newLabel];
     labelLocations++;
     }
     y.axisLabels                    = [NSSet setWithArray:customYLabels];
     */
    /*
     //Y axis
     CPTXYAxis *y            = axisSet.yAxis;
     y.title                 = self.yAxisTitle;
     y.titleOffset           = 26.0f;
     y.minorTicksPerInterval = 1;
     y.axisLineStyle = nil;
     y.labelingPolicy        = CPTAxisLabelingPolicyFixedInterval; //before Automatic
     y.axisConstraints       = [CPTConstraints constraintWithLowerOffset:0.0];
     y.titleTextStyle = textStyle;
     y.labelTextStyle = textStyle;
     y.minorTickLineStyle = nil;
     y.majorGridLineStyle = nil;
     y.majorTickLineStyle = nil;
     y.majorIntervalLength = CPTDecimalFromInt(self.yMaxValue / 2.5); //before nil
     //y.labelOffset = 2;
     //y.labelingOrigin = CPTDecimalFromInt(2);
     //y.fillMode
     NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
     [formatter setMaximumFractionDigits:0];
     y.labelFormatter = formatter;
     */
    //Ionel add "kg" to each label in yAxis
    //    NSMutableArray *customYLabels = [NSMutableArray array];
    //    for (int i=0; i< [y.axisLabels count]; i++){
    //
    //        CPTAxisLabel *obj= [[y.axisLabels allObjects] objectAtIndex:i];
    //        //obj.contentLayer = [obj stringByAppendingString:@" kg"];
    //        //[obj contentLayer].contents = @"dsa";
    //        [customYLabels addObject:obj];
    //    }
    //    y.axisLabels = [NSSet setWithArray:customYLabels];
    
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
    //*Ionel: uncomment to enable touch on data points
    
    if (pinScale){
        sPlot.delegate = self;
        sPlot.plotSymbolMarginForHitDetection = 3;
    }
    
    ////
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor whiteColor]; //Ionel: before was clear
    lineStyle.lineWidth = 3.0f + pinScale/4;
    
    CPTMutableLineStyle *lineStyle2 = [CPTMutableLineStyle lineStyle];
    lineStyle2.lineColor = [CPTColor clearColor]; //Ionel: before was clear
    lineStyle2.lineWidth = 3.0f + pinScale/4;
    //416550
    sPlot.dataLineStyle = lineStyle2;
    sPlot.interpolation = CPTScatterPlotInterpolationCurved;
    
    CPTPlotSymbol* circlePlotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    circlePlotSymbol.fill = [CPTFill fillWithColor:[CPTColor blackColor]];
    circlePlotSymbol.size = CGSizeMake(8.0, 8.0);
    sPlot.plotSymbol = circlePlotSymbol;
    
    CPTScatterPlot *sPlot2 = [[CPTScatterPlot alloc] init];
    //sPlot2.delegate = self;
    sPlot2.dataSource = self;
    sPlot2.identifier = @"secondplot";
    
    //sPlot2.plotSymbolMarginForHitDetection = 9 + pinScale;
    sPlot2.dataLineStyle = lineStyle2;
    
    ////Ionel: above-below fancy lines filled between them
    CPTColor *aboveColor = [CPTColor colorWithComponentRed:(233.0/255.0) green:(233.0/255.0) blue:(233.0/255.0) alpha:1];
    CPTMutableLineStyle *lineStyleAbove = [CPTMutableLineStyle lineStyle];
    lineStyleAbove.lineColor = aboveColor;
    lineStyleAbove.lineWidth = 1.0f;
    
    // plots
    CPTScatterPlot *abovePlot = [[CPTScatterPlot alloc] init];
    abovePlot.dataSource = self;
    abovePlot.identifier = @"above";
    abovePlot.dataLineStyle = lineStyleAbove;
    abovePlot.interpolation = CPTScatterPlotInterpolationCurved;
    
    CPTScatterPlot *midPlot = [[CPTScatterPlot alloc] init];
    midPlot.dataSource = self;
    midPlot.identifier = @"mid";
    midPlot.dataLineStyle = lineStyle;
    midPlot.interpolation = CPTScatterPlotInterpolationCurved;
    
    
    CPTScatterPlot *belowPlot = [[CPTScatterPlot alloc] init];
    belowPlot.dataSource = self;
    belowPlot.identifier = @"below";
    belowPlot.dataLineStyle = lineStyleAbove;
    belowPlot.interpolation = CPTScatterPlotInterpolationCurved;
    
    abovePlot.areaBaseValue = CPTDecimalFromInteger(0);
    abovePlot.fillMode = kCAFillModeBoth;
    abovePlot.areaFill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:(240.0/255.0) green:(240.0/255.0) blue:(240.0/255.0) alpha:1]];
    //abovePlot.areaFill = [CPTFill fillWithGradient:[CPTGradient gradientWithBeginningColor:[CPTColor colorWithComponentRed:(240.0/255.0) green:(240.0/255.0) blue:(240.0/255.0) alpha:1] endingColor:[CPTColor whiteColor]]];
    
    belowPlot.fillMode = kCAFillModeBoth;
    belowPlot.areaFill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    belowPlot.areaBaseValue = CPTDecimalFromInteger(0);
    [graph addPlot:abovePlot toPlotSpace:plotSpace];
    [graph addPlot:belowPlot toPlotSpace:plotSpace];
    //[graph.plotAreaFrame setFill:fill];
    midPlot.shadow = [CPTShadow shadow];
    //Ionel: add middle line to graph
    [graph addPlot:midPlot toPlotSpace:plotSpace];
    
    
    //Ionel: add actual weight data plots in the end, so it renders above the fill
    //Plot
    BOOL firstPlot = YES;
    for (NSString *set in [[self.sets allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]) {
        CPTBarPlot *plot        = [CPTBarPlot tubularBarPlotWithColor:[CPTColor blueColor] horizontalBars:NO];
        plot.cornerRadius = 20.0;
        plot.lineStyle          = barLineStyle;
        plot.fill               = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:(52.0 / 255.0) green:(48.0 / 255.0) blue:(78.0 / 255.0) alpha:1]]; //before was black
        if (firstPlot) {
            plot.barBasesVary   = NO;
            firstPlot           = NO;
        } else {
            plot.barBasesVary   = YES;
        }
        plot.barWidth           = CPTDecimalFromFloat(0.01f + pinScale/2000); //before 0.05f
        plot.barsAreHorizontal  = NO;
        plot.barOffset          = [[NSDecimalNumber decimalNumberWithString:@"0.0"]
                                   decimalValue];
        plot.dataSource         = self;
        plot.identifier         = set;
        //moved down
        [graph addPlot:plot];
        //Ionel animation
        plot.anchorPoint = CGPointMake(0.0, 0.0);
        CABasicAnimation *scaling = [CABasicAnimation
                                     animationWithKeyPath:@"transform.translation.y"]; // s
        scaling.fromValue = [NSNumber numberWithFloat:80.0];
        scaling.toValue = [NSNumber numberWithFloat:0.0];
        scaling.duration = 2; // Duration
        scaling.removedOnCompletion = NO;
        scaling.fillMode = kCAFillModeForwards;
        //[plot addAnimation:scaling forKey:@"scaling"];
    }
    
    
    [graph addPlot:sPlot];
    
    [graph addPlot:sPlot2 toPlotSpace:plotSpace];
    
    sPlot.anchorPoint = CGPointMake(0.0, 0.0); // Moved anchor point,
    sPlot2.anchorPoint = CGPointMake(0.0, 0.0); // Moved anchor point,
    CABasicAnimation *scaling = [CABasicAnimation
                                 animationWithKeyPath:@"transform.translation.y"]; // s
    scaling.fromValue = [NSNumber numberWithFloat:80.0];
    scaling.toValue = [NSNumber numberWithFloat:0.0];
    scaling.duration = 2; // Duration
    scaling.removedOnCompletion = NO;
    scaling.fillMode = kCAFillModeForwards;
    //[sPlot addAnimation:scaling forKey:@"scaling"];
    //[sPlot2 addAnimation:scaling forKey:@"scaling"];
    
    
}

#pragma mark - CPTPlotDataSource methods

-(void)scatterPlot:(CPTScatterPlot *)plot plotSymbolWasSelectedAtRecordIndex:(NSUInteger)idx withEvent:(UIEvent *)event
{
    //WidgetView *v = [[WidgetView alloc] initWithFrame:CGRectMake(95 + (graph.hostingView.frame.size.width/6)*index + 3*index, 100, 40, 40)];
    //CGPoint x = [plotSpace plotAreaViewPointForDoublePrecisionPlotPoint:(double *) numberOfCoordinates:2];
    //Ionel: temp iPhone5 detection
    //float ip5 = 0;
    //ip5 = 44;
    int index = idx;
    float x = [[_positionsX objectAtIndex:index] floatValue];
    float y = [[_positionsX objectAtIndex:index] floatValue];
    //double *a =
    CGPoint u = [graph.defaultPlotSpace plotAreaViewPointForEvent:event]; //plotAreaViewPointForPlotPoint:(__bridge NSDecimal *)([NSDecimalNumber numberWithInteger:index]) numberOfCoordinates:2];
    NSLog(@"punct %d: %f %f", (int)index, u.x, u.y);
    x = 100 + (87-index-index)*index;
    y = 215 - (100 + (19+index)*index) - (index == 4 ? 3 : 0);
    if ([ [ UIScreen mainScreen ] bounds ].size.height == 568 ){
        x = 110 + (87-index-index)*index + (index*15) + (index == 4 ? 10 : 0);
    }
    
    //Ionel: proper data points coordinates
    //    NSValue *value = [self._adata objectAtIndex:index];
    //    CGPoint point = [value CGPointValue];
    //    NSString *number1 = [NSString stringWithFormat:@"%.2f", point.x];
    //    NSString *number2 = [NSString stringWithFormat:@"%.2f", point.y];
    ///
    
    //temp real dialog positions
    x = u.x+40;
    y= 320-u.y-69-40-30;
    //x = u.x;
    //y = u.y;
    WidgetView *v = [[WidgetView alloc] initWithFrame:CGRectMake(x, y, 40, 40)];
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    //l.text = [NSString stringWithFormat:@"%.1f kg", [[[_data objectForKey:[self.xAxisLabels objectAtIndex:index]] objectForKey:@"weight"] floatValue]];
    l.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    l.text = [_hcData objectAtIndex:index];    //l.transform = CGAffineTransformMakeRotation((M_PI/2));
    l.font = [UIFont systemFontOfSize:10.0f];
    l.textAlignment = NSTextAlignmentCenter;
    [v addSubview:l];
    //self.collapsesLayers = YES;
    [v setAlpha:0.0];
    //CGRect frame = v.frame;
    //[v setFrame:CGRectMake(x, y+50, v.frame.size.width, v.frame.size.height)];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    //[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:v cache:NO];
    [v setAlpha:1.0];
    //[v setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
    //           [vc.view addSubview:v];
    //self.babyGraph.hidden = NO;
    [UIView commitAnimations];
    
    
    for (UIView *t in [self.parentViewControler.view subviews]){
        if ([t isKindOfClass:[WidgetView class]])
            [t removeFromSuperview];
    }
    [self.parentViewControler.view addSubview:v];
    //[self addSubview:v];
    NSLog(@"plotSymbolWasSelectedAtRecordIndex %d", index);
}

//- (CPTPlotRange*) plotSpace:(CPTPlotSpace *)space willChangePlotRangeTo:(CPTPlotRange *)newRange forCoordinate:(CPTCoordinate)coordinate{
//    for (UIView *t in [self.parentViewControler.view subviews]){
//        if ([t isKindOfClass:[WidgetView class]])
//            [t removeFromSuperview];
//    }
//}
/*
 - (BOOL) plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDownEvent:(id)event atPoint:(CGPoint)point{
 
 int x = point.x;
 int y = 200- point.y;
 WidgetView *v = [[WidgetView alloc] initWithFrame:CGRectMake(x, y, 40, 40)];
 
 UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
 //l.text = [NSString stringWithFormat:@"%.1f kg", [[[_data objectForKey:[self.xAxisLabels objectAtIndex:index]] objectForKey:@"weight"] floatValue]];
 l.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
 l.text = @"ma"; //[_hcData objectAtIndex:index];    //l.transform = CGAffineTransformMakeRotation((M_PI/2));
 l.font = [UIFont systemFontOfSize:10.0f];
 l.textAlignment = NSTextAlignmentCenter;
 [v addSubview:l];
 self.collapsesLayers = YES;
 [v setAlpha:0.0];
 CGRect frame = v.frame;
 //[v setFrame:CGRectMake(x, y+50, v.frame.size.width, v.frame.size.height)];
 [UIView beginAnimations:nil context:nil];
 [UIView setAnimationDuration:1];
 //[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:v cache:NO];
 [v setAlpha:1.0];
 //[v setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
 //           [vc.view addSubview:v];
 //self.babyGraph.hidden = NO;
 [UIView commitAnimations];
 
 
 for (UIView *t in [self.parentViewControler.view subviews]){
 if ([t isKindOfClass:[WidgetView class]])
 [t removeFromSuperview];
 }
 [self.parentViewControler.view addSubview:v];
 
 
 
 return YES;
 }
 */
- (BOOL) plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDraggedEvent:(id)event atPoint:(CGPoint)point{
    if (pinScale)
        for (UIView *t in [self.parentViewControler.view subviews]){
            if ([t isKindOfClass:[WidgetView class]])
                [t removeFromSuperview];
        }
    return YES;
}

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return self.xAxisLabels.count;
}

- (double)doubleForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    double num = NAN;
    
    //X Value
    if (fieldEnum == CPTScatterPlotFieldX) {
        num = index;
    }
    
    else {
        if([plot.identifier isEqual:@""]){
            double offset = 0;
            if (((CPTBarPlot *)plot).barBasesVary) {
                for (NSString *set in [[self.sets allKeys] sortedArrayUsingSelector:@selector    (localizedCaseInsensitiveCompare:)]) {
                    if ([plot.identifier isEqual:set]) {
                        break;
                    }
                    offset += [[[_data objectForKey:[self.xAxisLabels objectAtIndex:index]] objectForKey:@"weight"] doubleValue];
                }
            }
            
            //Y Value
            if (fieldEnum == 1) {
                num = [[[_data objectForKey:[self.xAxisLabels objectAtIndex:index]] objectForKey:@"weight"] doubleValue] + offset;
            }
            
            //Offset for stacked bar
            else {
                num = offset;
            }
        }else{
            double offset = 0;
            for (NSString *set in [[self.sets allKeys] sortedArrayUsingSelector:@selector    (localizedCaseInsensitiveCompare:)]) {
                if ([plot.identifier isEqual:set]) {
                    break;
                }
                offset += [[[_data objectForKey:[self.xAxisLabels objectAtIndex:index]] objectForKey:@"weight"] doubleValue];
            }
            
            
            //Y Value
            if (fieldEnum == 1) {
                num = ((Weight*)[self.weights objectAtIndex:index]).weight;
                NSLog(@"mama2 : %f", num);
            }
            
            //Offset for stacked bar
            else {
                num = offset;
            }
        }
    }
    
    if(num == 0){
        //num = -2.0;
    }
    
    if(num >= 15.0){
        num = num - 0.2;
    }
    
    if(num >= 17.0){
        num = num - 0.2;
    }
    
    if(num >= 19.0){
        num = num - 0.7;
    }
    
    NSLog(@"%@ - %d - %d - %f", plot.identifier, index, fieldEnum, num);
    
    
    //Ionel
    //get (x, y) positions for data points
    if (fieldEnum == CPTScatterPlotFieldY){
        if ([plot.identifier isEqual:@"above"]) num = index+ 4.5 + 1.2*sqrt(index+1) + (num == 4 ? 1 : 0);
        if ([plot.identifier isEqual:@"below"]) num = index+ 0.4 + 1.2*sqrt(index+1) + (num == 4 ? 1 : 0);
        if ([plot.identifier isEqual:@"mid"]) num = index+ 2.5 + 1.2*sqrt(index+1) + (num == 4 ? 1 : 0);
        if ([plot.identifier isEqual:@"mainplot"]){
            
            [_positionsY addObject:[NSString stringWithFormat:@"%f", num]];
            
        }
        
    }
    if (fieldEnum == CPTScatterPlotFieldX){
        if (([plot.identifier isEqual:@"above"]) || ([plot.identifier isEqual:@"below"]) || ([plot.identifier isEqual:@"mid"])){
            if (num == 0) num = -0.3;
            if (num == self.xAxisLabels.count-1) num = self.xAxisLabels.count - 1 + 0.3;
        }
        if ([plot.identifier isEqual:@"mainplot"]){
            [_positionsX addObject:[NSString stringWithFormat:@"%f", num]];
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
    CPTColor *color = [CPTColor colorWithComponentRed:(52.0 / 255.0) green:(48.0 / 255.0) blue:(78.0 / 255.0) alpha:1];
    //pin dimensions - before: 8 and 5
    if([plot.identifier isEqual:@"mainplot"]){
        plotSymbol.symbolType = CPTPlotSymbolTypeEllipse;
        plotSymbol.size = CGSizeMake(9 + pinScale, 9 + pinScale);
        //get color from client's pic
        
        //Ionel override
        //if(index % 2 == 0){
        if (TRUE){
            plotSymbol.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
            symbolLineStyle.lineColor = color;
            plotSymbol.lineStyle = symbolLineStyle;
        }else{
            
            plotSymbol.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:(151.0 / 255.0) green:(147.0 / 255.0) blue:(187.0 / 255.0) alpha:1]];
        }
    }else if ([plot.identifier isEqual:@"secondplot"]){
        //Ionel override
        //if(index % 2 == 0){
        if (TRUE){
            float aux = 0;
            if (pinScale) aux = pinScale - 1;
            plotSymbol.symbolType = CPTPlotSymbolTypeEllipse;
            plotSymbol.size = CGSizeMake(7 + aux, 7 + aux);
            plotSymbol.fill = [CPTFill fillWithColor:color];
        }
        else{
            plotSymbol.symbolType = CPTPlotSymbolTypeNone;
        }
    }
    return plotSymbol;
}


@end
