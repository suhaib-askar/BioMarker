//
//  AnalysisViewController.m
//  bioMarker Test
//
//  Created by Ryan Grewatz on 10/13/13.
//  Copyright (c) 2013 Pete Willemsen. All rights reserved.
//

#import "AnalysisViewController.h"
#import "frameData.h"
#import <MobileCoreServices/UTCoreTypes.h>
# import "JointAngleOverTime2DAnalyser.h"
#import "AnnotationModelUtil.h"
#import "PointVelocityAnalyser.h"
@implementation AnalysisViewController
@synthesize hostView = hostView_;

#pragma mark - UIViewController lifecycle methods
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startMediaBrowserFromViewController:self usingDelegate:self usingSender:nil];
}

#pragma mark - Chart behavior
-(void)initPlot {
    [self configureHost];
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
}

-(void)configureHost {
    self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:self.view.bounds];
    self.hostView.allowPinchScaling = YES;
    [self.view addSubview:self.hostView];
}

-(void)configureGraph {
    // 1 - Create the graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    [graph applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
    self.hostView.hostedGraph = graph;
    // 2 - Set graph title
    NSString *title = @"";
    graph.title = title;
    // 3 - Create and set text style
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor whiteColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 16.0f;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, 10.0f);
    // 4 - Set padding for plot area
    [graph.plotAreaFrame setPaddingLeft:30.0f];
    [graph.plotAreaFrame setPaddingBottom:30.0f];
    // 5 - Enable user interactions for plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
}

-(void)configurePlots {    
    /*
     * So for now we'll just use this list of colors to give each plot 
     * it's own color. Someday we might want to be more clever..
     */
    NSMutableArray *cptColors = [[NSMutableArray alloc] init];
    [cptColors addObject:[CPTColor blueColor]];
    [cptColors addObject:[CPTColor redColor]];
    [cptColors addObject:[CPTColor greenColor]];
    [cptColors addObject:[CPTColor orangeColor]];
    [cptColors addObject:[CPTColor magentaColor]];
    [cptColors addObject:[CPTColor purpleColor]];
    [cptColors addObject:[CPTColor brownColor]];
    [cptColors addObject:[CPTColor grayColor]];
    [cptColors addObject:[CPTColor whiteColor]];
    
    int colorIndex = 0;
    
    NSArray* identifiers = [currentAnnotationAnalyzer listIdentifiers];
    CPTGraph *graph = self.hostView.hostedGraph;
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    
    for (NSString* ident in identifiers) {
        CPTScatterPlot *plot = [[CPTScatterPlot alloc] init];
        plot.dataSource = self;
        plot.identifier = ident;
        plot.title = ident;
        [graph addPlot:plot toPlotSpace:plotSpace];
        CPTColor *color = cptColors[colorIndex];
        
        //set up plot space
        [plotSpace scaleToFitPlots:[NSArray arrayWithObjects:plot, nil]];
        CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
        [xRange expandRangeByFactor:CPTDecimalFromCGFloat(1.1f)];
        plotSpace.xRange = xRange;
        CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
        [yRange expandRangeByFactor:CPTDecimalFromCGFloat(1.2f)];
        plotSpace.yRange = yRange;
        // 4 - Create styles and symbols
        CPTMutableLineStyle *lineStyle = [plot.dataLineStyle mutableCopy];
        lineStyle.lineWidth = 2.5;
        lineStyle.lineColor = color;
        plot.dataLineStyle = lineStyle;
        CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
        symbolLineStyle.lineColor = color;
        CPTPlotSymbol *symbol = [CPTPlotSymbol ellipsePlotSymbol];
        symbol.fill = [CPTFill fillWithColor:color];
        symbol.lineStyle = symbolLineStyle;
        symbol.size = CGSizeMake(6.0f, 6.0f);
        plot.plotSymbol = symbol;
        
        colorIndex++;
    }
    
    
    graph.legend = [CPTLegend legendWithGraph:graph];
    graph.legend.fill = [CPTFill fillWithColor:[CPTColor darkGrayColor]];
    graph.legend.cornerRadius = 5.0;
    graph.legend.swatchSize = CGSizeMake(25.0, 25.0);
    graph.legendAnchor = CPTRectAnchorBottom;
    graph.legendDisplacement = CGPointMake(0.0, 12.0);

}

-(void)configureAxes {
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    
    axisTitleStyle.color = [CPTColor whiteColor];
    axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontSize = 12.0f;
    
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 2.0f;
    axisLineStyle.lineColor = [CPTColor whiteColor];
    CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc] init];
    /*axisTextStyle.color = [CPTColor whiteColor];
    axisTextStyle.fontName = @"Helvetica-Bold";
    axisTextStyle.fontSize = 11.0f;
    CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [CPTColor whiteColor];
    tickLineStyle.lineWidth = 2.0f;
    CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [CPTColor blackColor];
    tickLineStyle.lineWidth = 1.0f;
    // 2 - Get axis set
     */
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
    
    CPTAxis *y = axisSet.yAxis;
    CPTAxis *x = axisSet.xAxis;
    y.majorIntervalLength = CPTDecimalFromString(@"20");
/*
    y.title = @"Degrees";
    y.titleTextStyle = axisTitleStyle;
    y.titleOffset = -40.0f;
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    y.labelTextStyle = axisTextStyle;
    y.labelOffset = 16.0f;
    x.title = @"Seconds";
    x.titleTextStyle = axisTitleStyle;
    x.titleOffset = -40.0f;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.labelTextStyle = axisTextStyle;
    x.labelOffset = 16.0f;
    y.majorTickLineStyle = axisLineStyle;
    y.majorTickLength = 4.0f;
    y.minorTickLength = 2.0f;
    y.tickDirection = CPTSignPositive;
    NSInteger majorIncrement = 10;
    NSInteger minorIncrement = 5;
    CGFloat yMax = 700.0f;  // should determine dynamically based on max price
    NSMutableSet *yLabels = [NSMutableSet set];
    NSMutableSet *yMajorLocations = [NSMutableSet set];
    NSMutableSet *yMinorLocations = [NSMutableSet set];
    y.axisLabels = yLabels;
    y.majorTickLocations = yMajorLocations;
    y.minorTickLocations = yMinorLocations;
     */
    //[self.hostView.hostedGraph.defaultPlotSpace scaleToFitPlots:[self.hostView.hostedGraph allPlots]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    analysisView = (AnalysisView *) self.view;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)AnalyzeVideoAction:(UIButton *)sender {
    /*
    //framedata = getVideoData(UniqueVideoIdentifier);
    //do meaningful manipulations. (for now X coordinates based on time)     |    *
    //place data into graph                                                  |      *
                                                                 xCoordinate |  *       *
                                                                             |*
                                                                             |______________*
                                                                                Time(sec)
     */
    
    // Since this is a delegate of the UIImagePickerController, we specify self below for the arguments.
    // This allows tapping the annotate button (this action) to open the UIImagePickerController resulting in the
    // user being able to select a video frmo the media library.
  
}

-(BOOL)startMediaBrowserFromViewController:(UIViewController *)controller usingDelegate:(id)delegate usingSender:(id)sender {
    
    // BIG NOTE!  The UIImagePickerController is not available on the iPad the way I'm presenting it below.  Instead, we
    // need to use a UIPopoverController to do the pop-up picker.
    
    // 1 - Validate the argument data
    //
    // Make sure the UIImagePickerControllerSourceTypeSavedPhotosAlbum is actually on the device.  This is the source of
    // the media we're seeking.  If not there, then picker may attempt to select video from sources that don't exist,
    // resulting in a crash of the app.
    //
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (delegate == nil)
        || (controller == nil)) {
        return NO;
    }
    
    // 2 - Get image picker
    //
    // If source is available, create a UIImagePickerController (called mediaUI here).  Only interested in video for
    // this pass, so kUTTypeMovie is the only type set in the NSArray below.
    //
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    mediaUI.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *) kUTTypeMovie, nil];
    
    // Hides the controls for moving and scaling pictures, or for
    // trimming movies.  TO instead show the controls, use YES
    mediaUI.allowsEditing = YES;
    mediaUI.delegate = delegate;
    
    // 3 - Display image picker - doesn't work in iPad
    //     [controller presentModalViewController:mediaUI animated:YES];
    
    // Instead, need to create a popovercontroller to manage the presentation
    if (![imagePickerPopoverController isPopoverVisible]) {
        
        // Popover is not visible so get one ready
        imagePickerPopoverController = [[UIPopoverController alloc] initWithContentViewController:mediaUI];
        imagePickerPopoverController.delegate = delegate;
        [imagePickerPopoverController presentPopoverFromRect:CGRectMake(10.0f, 10.0f, 10.0f, 10.0f) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    }
    
    return YES;
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSError *error = nil;

    // 1 - Get the media type
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    // 2 - Dismiss the image picker
    [imagePickerPopoverController dismissPopoverAnimated:NO];
    
    
    
    imageURL = [info valueForKey: UIImagePickerControllerReferenceURL];
    
    //NSMutableString *filename = [[[[imageURL path] lastPathComponent] stringByDeletingPathExtension] mutableCopy];
    NSMutableString *filename = [[NSMutableString alloc] init];
    for(int i = 0; i < [[imageURL absoluteString] length]; i++) {
        char c = [[imageURL absoluteString] characterAtIndex:i];
        if(c != '/') {
            [filename appendString:[NSString stringWithFormat:@"%c", c]];
        }
    }
    annotatedVideoModel = [[AnnotatedVideoModel alloc] initWithVideoName:[filename mutableCopy]];
    //?id=...&
    
    if([annotatedVideoModel inStorage]) {
        [annotatedVideoModel loadFrames];
    }
    
    //initializing list of anaysers here. Might want to think about doing this in a formal init method.
    //When we get to the point where we have more than one analyser this list should be shown somewhere in
    //the UI in a way that the user can select which analysis to preform.
    annotationAnalysers = [[NSMutableArray alloc] init];
    [annotationAnalysers addObject:[[JointAngleOverTime2DAnalyser alloc] initWithAnnotatedVideoModel:annotatedVideoModel]];
    [annotationAnalysers addObject:[[PointVelocityAnalyser alloc] initWithAnnotatedVideoModel:annotatedVideoModel]];
    currentAnnotationAnalyzer = annotationAnalysers[1];
    [self reload];
}

#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [annotatedVideoModel getAllFrames].count;
}

-(NSArray *)listJoints:(ContentNode *) limbNode {
    NSMutableArray* joints = [[NSMutableArray alloc] init];

    NSArray * pointNodes = [AnnotationModelUtil getPointNodesForLimbNode:limbNode];


    if([pointNodes count] > 2) {
        joints = [pointNodes subarrayWithRange:NSMakeRange(1, [pointNodes count] - 2)];
    }

    return joints;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    float videoTime = index;
    videoTime = videoTime/10;

    NSString *identifierLabel = (NSString*)plot.identifier;
    
    if(fieldEnum == CPTScatterPlotFieldX){
        return [currentAnnotationAnalyzer getXPlotValue:identifierLabel :videoTime];
    }
    
    if(fieldEnum == CPTScatterPlotFieldY){
        return [currentAnnotationAnalyzer getYPlotValue:identifierLabel :videoTime];
    }
}


- (IBAction)changeAnalyser:(id)sender {
    UIButton* button = (UIButton*) sender;
    NSString* title = [button currentTitle];
    for (id<FrameAnnotationAnalyser> analyser in annotationAnalysers) {
        if ([title isEqualToString:[analyser getLabel]]) {
            currentAnnotationAnalyzer = analyser;
        }
    }
    [self reload];
}

-(void) reload {
    [self.view.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [self initPlot];
    [self loadToolBar];
    
}

-(void) loadToolBar {
    

    UIView* controlPanel = [[UIView alloc] init];
    controlPanel.frame = CGRectMake(0, 60, self.view.bounds.size.width, 60.0);
    [controlPanel setBackgroundColor:[UIColor lightGrayColor]];
    int buttonX = 50;
    for (id<FrameAnnotationAnalyser> analyser in annotationAnalysers) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self
                   action:@selector(changeAnalyser:)
         forControlEvents:UIControlEventTouchDown];
        [button setTitle:[analyser getLabel] forState:UIControlStateNormal];
        button.frame = CGRectMake(buttonX, 10, 120, 40.0);
        [[button layer] setBorderWidth:2.0f];
        [[button layer] setBorderColor:[UIColor grayColor].CGColor];
        [button setTitleColor:[UIColor colorWithRed:.196 green:0.3098 blue:0.52 alpha:1.0] forState:UIControlStateNormal];
        if ([analyser isEqual:currentAnnotationAnalyzer]) {
            [button setBackgroundColor:[UIColor grayColor]];
        }
        buttonX += 150;
        [controlPanel addSubview:button];
    }
    
    [self.view addSubview:controlPanel];
}


@end
