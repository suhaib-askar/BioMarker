//
//  AutoTrack.m
//  bioMarker Test
//
//  Created by Bradley Cutshall on 1/20/15.
//  Copyright (c) 2015 Pete Willemsen. All rights reserved.
//

#import "AutoTrack.h"

@implementation AutoTrack

@synthesize currentLimb;
@synthesize currentFrameData;
/*
 * Default constructor
 */
-(AutoTrack*) init {
    // xLimit = X;
    // yLimit = Y;
    needsPointsSetup = true;
    image = *new Mat;
    prevGray = *new Mat;
    gray = *new Mat;
    windowSize = cv::Size(10,10);
    // points = *new cv::vector<cv::Point2f>(2);
    termCriteria = TermCriteria(CV_TERMCRIT_ITER|CV_TERMCRIT_EPS,20,0.03);
    maxPoints = 50;
    status = *new vector<uchar>;
    err = *new vector<float>;
    //vector<cv::Point2f> points[2];
    Mat grayImage = *new Mat;
    // Convert to gray image
    //cvtColor(inputImage, grayImage, CV_BGR2GRAY);
    
    return self;
}

/*
 * Constructor creates the OpenCV processing logic with the camera's width and height.
 * params : Int camera width, Int camera height
 */
-(AutoTrack*)initWithXY:(int)X :(int)Y {
    xLimit = X;
    yLimit = Y;
    needsPointsSetup = true;
    image = *new Mat;
    prevGray = *new Mat;
    gray = *new Mat;
    windowSize = cv::Size(10,10);
    // points = *new cv::vector<cv::Point2f>(2);
    termCriteria = TermCriteria(CV_TERMCRIT_ITER|CV_TERMCRIT_EPS,20,0.03);
    maxPoints = 50;
    status = *new vector<uchar>;
    err = *new vector<float>;
    //vector<cv::Point2f> points[2];
    Mat grayImage = *new Mat;
    // Convert to gray image
    //cvtColor(inputImage, grayImage, CV_BGR2GRAY);
    
    return self;

}

/*
 * Returns the number of good points to track
 */
-(int)getMaxPoints {
    //Ensure safety
    int numPoints = maxPoints;
    return numPoints;
}

/*
 * Expects !points < 0
 * param int points
 * return true if !points < 0
 */
-(bool)setMaxPoints:(int) numPoints {
    bool success = false;
    if(numPoints > -1) {
        maxPoints = numPoints;
        success = true;
    }
    return success;
}

-(vector<Point2f>*)getGoodPoints {
    return goodPoints;
}

////////////////
// C++ functions
////////////////
#ifdef __cplusplus

/*
 * This function takes the image from the controller and kicks off the processing
 * It can also return the processed image if needed
 */
-(Mat)analyzeImage : (Mat)inputImage {
    
    // The method returns a matrix size: Size(cols, rows) . When the matrix is more than 2-dimensional, the returned size is (-1, -1).
    BackgroundSubtractorGMG backSubGMG;
    Mat backgroundGray;
    
    
    if ((inputImage.rows > 1) && (inputImage.cols > 1)) {
        
        // Fatal error if the image is not colored to gray
        cvtColor(inputImage, gray, CV_BGR2GRAY);
        //bitwise_not(gray, gray); // Inverts image
        
        
        
        // Add points to goodPoints if necessary
        if((goodPoints[1].size() < maxPoints) && (needsPointsSetup == true)) {
            //[self addGoodPoints:gray];
            needsPointsSetup = false;
        }
        
        // Run Lucas-Kande algorithm on points arrays
        if(!goodPoints[0].empty()) {
            calcOpticalFlowPyrLK(prevGray, gray, goodPoints[0], goodPoints[1], status, err, windowSize,3, termCriteria, 0);
        }
        
        if(goodPoints[1].size() > 0) {
        //    [self removeFirstOutOfRangePoint ];
        }
        
        // Prepare for next frame, goodPoints[1] is the next points, [0] is old
        std::swap(goodPoints[1], goodPoints[0]);
        swap(prevGray, gray);
    
             
        //Mat grayCopy = gray;
        // Subtract background of image to obtain better image recognition.
        //backSubGMG.operator()(grayCopy, gray);
        
        
    }
    
    return gray;
}

-(void) modifyPoints {
    
}

-(bool) resetPoints {
    goodPoints[0].empty();
    goodPoints[1].empty();
    vector<Point2f> emptyPoints[2];
    // Prepare for next frame, goodPoints[1] is the next points, [0] is old
    std::swap(emptyPoints[0], goodPoints[0]);
    std::swap(emptyPoints[1], goodPoints[1]);
    needsPointsSetup = true;
    return true;
}


/*
 * Removes a point at the given index
 * returns the point removed
 */
-(void) removeFirstOutOfRangePoint {
    
    vector<Point2f> list = goodPoints[1];
    vector<Point2f> newList = list;
    Point2f p = list[0];
    bool found = false;
    int i = 0, x=0, y=0;
    
    
    // Find the first occurance of a out of range point
    while(!found) {
        i++;
        p = list[i-1];
        x= p.x;
        y = p.y;
        if (x > xLimit || x < 0) { found = true; }
        if (y > yLimit || y < 0) { found =true; }
        // And remove it
        if (found) {
            //list[i-1] = p;
            vector<Point2f> newList;
            //Point2f newPoint;
            
            for (int j=0; j < list.size(); j++) {
                
                if(j != (i-1)) {
                    newList.push_back( list[j] );
                }
            }
            std::swap(goodPoints[1], newList);
        }
        if (i > maxPoints) {
            found = true;
        }
    }
    

    //return newList;
}

-(void) addPointWithCGPoint : (CGPoint) point {
    NSLog(@"AutoTrackLogic: added currentPoint: %f, %f", point.x, point.y);
    goodPoints[0].push_back(cv::Point(point.x, point.y));
}

/*
 * Adds good points to track to the tracking list.
 * This function consumes a lot of resources, so use sparingly.
 */
-(void) addGoodPoints : (Mat)inputImage {
    NSLog(@"Adding");
    // Setup subpix
    goodFeaturesToTrack(inputImage, goodPoints[1], maxPoints, 0.01, 10, Mat(), 3, 0, 0.04);
    cornerSubPix(inputImage, goodPoints[1], windowSize, cv::Size(-1,-1), termCriteria);
}

#endif
@end
