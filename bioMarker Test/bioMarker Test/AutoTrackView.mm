//
//  AutoTrackView.m
//  bioMarker Test
//
//  Created by Bradley Cutshall on 1/22/15.
//  Copyright (c) 2015 Pete Willemsen. All rights reserved.
//

#import "AutoTrackView.h"

@implementation AutoTrackView


@synthesize autoTrackLogic;
@synthesize videoCamera;
@synthesize framesToVideo;


- (id)initWithCoder:(NSCoder *)aDecoder     //CHANGE: Changed because initwithframe isn't always called
{                                           //(http://stackoverflow.com/questions/1600248/uiviews-initwithframe-not-working)
    // Initialization code
    self = [super initWithCoder:aDecoder];
    if (self) {
        framesToVideo = [[FramesToVideo alloc] init];
        needsCVSetup = true;
        if (needsCVSetup) {
            self.autoTrackLogic = [[AutoTrack alloc] init];
            needsCVSetup = false;
        }
        self.videoCamera = [[CvVideoCamera alloc] initWithParentView:self];
        self.videoCamera.delegate = self;
        //self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack; // Uses the back camera
        self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront; // uses the front camera
        //self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480; // Starts to lag out really badly
        self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
        xScalar = self.frame.size.width / 288;
        yScalar = self.frame.size.height / 352;
        
        self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
        self.videoCamera.defaultFPS = 30;
        self.videoCamera.grayscaleMode = NO;
    }
    return self;
}

/*
 * Simple acessor method
 */
-(bool)isRecording {
    return [self.framesToVideo isRecording];
}

/*
 * Returns true if started false if stopped
 */
-(bool)startStopVideo {
    
    bool started = false;
    if(![self.videoCamera running]){
        // Start Camera
        [self.videoCamera start];
        started = true;
    } else {
        // Stop Camera
        [self.videoCamera stop];
        
    }
    return started;
}

/*
 * Needs to be implemented using the "FramesToVideoClass"
 * Here we can ask the user to name their video
 */
-(bool)startStopRecording {
    
    if([self.framesToVideo isRecording]) {
        // Stop recording and initiate save frames to video and such.
        [self.framesToVideo stopRecording];

    } else {
        
        // Start recording and initiate frame and point capture
        [self.framesToVideo startRecording];

    }
    return [self.framesToVideo isRecording];
}



/* Eventually this shoudl restart the actual recording
 * For now it just restarts the tracking logic
 */
-(bool)restartTracking {
    // Stop Camera
    [self startStopVideo];
    
    
    // Reset Points
    bool restarted = [autoTrackLogic resetPoints];
    vector<Point2f> points = [autoTrackLogic getGoodPoints][1];
    [pointsView paintViewWithPointsAndScalar: points : xScalar : yScalar];
    
    // Remove images in temporary folder
    // This is taken care of in FTV
    //[self.framesToVideo clearTmpDirectory];
    //[self.framesToVideo stopRecording];
    
    // Start camera back up (this is because the button problem...)
    [self startStopVideo];
    return restarted;
}

-(void)setPointsView:(AutoTrackPointsView*)view {
    pointsView = view;
}


/*
 * This is where the heavy work gets done.
 * Within this function we will process the video using 'AutoTrack.h',
 * record the video using 'FramesToVideo.h' and save the point data.
 */
#pragma mark - Protocol CvVideoCameraDelegate

#ifdef __cplusplus
- (void)processImage:(cv::Mat&)image;
{
    
    // Ensure the class is compiled
    if(needsCVSetup) {
        self.autoTrackLogic = [[AutoTrack alloc] init];
        //self.autoTrackLogic = [[AutoTrack alloc] initWithImage:image];
        needsCVSetup = false;
    }

    // Run tracking algorithm on the image
    [self.autoTrackLogic analyzeImage:image];
    
    // Paint plotted points to screen
    vector<Point2f> points = [autoTrackLogic getGoodPoints][1];
    
    //[pointsView paintViewWithPoints: points];
    [pointsView paintViewWithPointsAndScalar: points : xScalar : yScalar];
    CGPoint newPoint = [pointsView getNewPoint];
    
    // Add point if user requested
    if(newPoint.x > 0 && newPoint.y > 0) {
        NSLog(@"framePoint: added currentPoint: %f, %f", newPoint.x, newPoint.y);
        CGPoint modifiedPoint = CGPointMake((newPoint.x / xScalar), (newPoint.y / yScalar));
        [self.autoTrackLogic addPointWithCGPoint:modifiedPoint];
        //[self.autoTrackLogic addPointWithCGPoint:newPoint];
    }
    
    // Save frames to a video for later analysis
    if([self.framesToVideo isRecording]) {
        UIImage * img = [self UIImageFromCVMat: image];
        // Throws exception if the image is null
        if (img != nil) {
            // Leave it to FramesToVideo
            [framesToVideo saveFrameToStorage: img];
        }
    }

    
}
#endif



-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}

/*
 * This UIView does not dealloc when the UI leaves this view. We will
 * therefore explicitly clean up this UIView as best we can.
 */
-(bool)cleanupView{
    
    // Cleanup temp files left while creating a video
    [self.framesToVideo clearTmpDirectory];
    
    
    // Cleanup everything else
    [self.videoCamera stop];
    self.videoCamera = nil;
    self.autoTrackLogic = nil;
    pointsView = nil;
    
    
    return ((self.autoTrackLogic == nil) && (self.videoCamera == nil));
}

@end
