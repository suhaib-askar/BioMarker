//
//  AnalysisViewController.h
//  bioMarker Test
//
//  Created by Ryan Grewatz on 10/13/13.
//  Copyright (c) 2013 Pete Willemsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnalysisView.h"
#import "frameData.h"
#import "AnnotatedVideoModel.h"
#import "FrameAnnotationAnalyser.h"
@interface AnalysisViewController : UIViewController<CPTPlotDataSource>{
    UIPopoverController *imagePickerPopoverController;
    AnalysisView *analysisView;
    NSURL *imageURL;
    AnnotatedVideoModel *annotatedVideoModel;
    NSMutableArray* annotationAnalysers;
    id<FrameAnnotationAnalyser> currentAnnotationAnalyzer;
}
@property(nonatomic,retain) UIPopoverController *imagePickerPopoverController;
@property(nonatomic,retain) NSURL *imageURL;
@property (nonatomic, strong) CPTGraphHostingView *hostView;
- (IBAction)AnalyzeVideoAction:(UIButton *)sender;
- (IBAction)changeAnalyser:(id)sender;
- (NSArray*) listJoints:(ContentNode *)limbNode;
@end
