//
//  AnalysisView.h
//  bioMarker Test
//
//  Created by Ryan Grewatz on 10/13/13.
//  Copyright (c) 2013 Pete Willemsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
@interface AnalysisView : UIView{
    UIPopoverController *imagePickerPopoverController;
    CPTGraph *graph;
    
}


-(void)configureWithDataSource:(UIViewController<CPTPlotDataSource>*) dataSource;

@property(nonatomic,strong) UIPopoverController *imagePickerPopoverController;
@property (nonatomic, strong) CPTGraphHostingView *hostView;
@property (nonatomic, strong) CPTTheme *selectedTheme;

@end
