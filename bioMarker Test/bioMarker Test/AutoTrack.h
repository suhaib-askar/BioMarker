//
//  AutoTrack.h
//  bioMarker Test
//
//  Created by Bradley Cutshall on 1/20/15.
//  Copyright (c) 2015 Pete Willemsen. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "AnnotatedFrameData.h"
#import "AnnotationModelValidationService.h"
#import "AnnotationModelUtil.h"

using namespace cv;

@interface AutoTrack : NSObject {
    Mat image;
    Mat prevGray;
    Mat gray;
    vector<Point2f> goodPoints[2];
    vector<uchar> status;
    vector<float> err;
    TermCriteria termCriteria;
    cv::Size windowSize;
    Point2f pt; // Temp testing point
    bool needsPointsSetup;
    int maxPoints, xLimit, yLimit;
    NSMutableString* currentLimb;
}

// Functions
-(AutoTrack*)init;
-(AutoTrack*)initWithXY : (int) X : (int) Y;
-(vector<Point2f>*)getGoodPoints;
// Getters setters
-(int)getMaxPoints;
-(bool)setMaxPoints : (int) numPoints;
-(bool)resetPoints;

// C++ functions
#ifdef __cplusplus
-(Mat)analyzeImage : (Mat)image;
-(void)addGoodPoints: (Mat)inputImage;
-(void) addPointWithCGPoint : (CGPoint) point;
#endif

@property(nonatomic, strong) NSMutableString * currentLimb;
@property(nonatomic, strong) AnnotatedFrameData * currentFrameData;

@end
