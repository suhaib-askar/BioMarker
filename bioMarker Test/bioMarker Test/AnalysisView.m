//
//  AnalysisView.m
//  bioMarker Test
//
//  Created by Ryan Grewatz on 10/13/13.
//  Copyright (c) 2013 Pete Willemsen. All rights reserved.
//

#import "AnalysisView.h"
//#import "CorePlot-CocoaTouch.h"
@implementation AnalysisView

@synthesize imagePickerPopoverController;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        graph = [[CPTGraph alloc] init];
        
    }
        // Initialization code
    return self;
}


-(void) configureWithDataSource:(UIViewController<CPTPlotDataSource> *)dataSource {
    // 1 - Create and initialize graph
    //CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    self.hostView.hostedGraph = graph;
    graph.paddingLeft = 0.0f;
    graph.paddingTop = 200.0f;
    graph.paddingRight = 0.0f;
    graph.paddingBottom = 0.0f;
    graph.axisSet = nil;
    // 2 - Set up text style
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color = [CPTColor grayColor];
    textStyle.fontName = @"Helvetica-Bold";
    textStyle.fontSize = 16.0f;
    // 3 - Configure title
    NSString *title = @"X point graph";
    graph.title = title;
    graph.titleTextStyle = textStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, -12.0f);
    // 4 - Set theme
    self.selectedTheme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [graph applyTheme:self.selectedTheme];
    
    
}


-(void) drawGraph:(NSDictionary*) frames{
    graph.bounds = self.bounds;
    /*Graph of x coordinates over time                                              | *
      for each frame in the data:                                         Time(sec) |   *
        get the times and x coordinates                                             | *
        set graph ends to largest time, and x coordinates (to contain all data)     |       *
        set each point of the frames into the time and x coordinates                |______________*
                                                                                      x-coordinate
     */
    
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
}



@end
