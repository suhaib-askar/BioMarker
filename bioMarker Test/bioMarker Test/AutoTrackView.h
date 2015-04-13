//
//  AutoTrackView.h
//  bioMarker Test
//
//  Created by Bradley Cutshall on 1/22/15.
//  Copyright (c) 2015 Pete Willemsen. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <opencv2/highgui/cap_ios.h>
#import "AutoTrack.h"
#import "AutoTrackPointsView.h"
#import "FramesToVideo.h"

using namespace cv;


@interface AutoTrackView : UIView <CvVideoCameraDelegate> {
    
    vector<Point2f> pointsVector;
    AutoTrackPointsView* pointsView;
    CvVideoCamera* videoCamera;
    AutoTrack* autoTrackLogic;
    bool needsCVSetup;
    float xScalar;
    float yScalar;

}

-(bool)startStopVideo;
-(bool)restartTracking;
-(bool)startStopRecording;
-(bool)isRecording;
-(void)setPointsView :(AutoTrackPointsView*)view;
-(bool)cleanupView; // Returns true if cleaned, false otherwise
-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat;


@property (nonatomic, retain) CvVideoCamera* videoCamera;
@property (nonatomic, retain) AutoTrack* autoTrackLogic;
@property (nonatomic, retain) FramesToVideo * framesToVideo;
//@property (nonatomic, retain) AutoTrackCamera* cvVideoCamera;



@end

