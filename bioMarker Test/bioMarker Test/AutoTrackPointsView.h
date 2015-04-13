//
//  AutoTrackPointsView.h
//  bioMarker Test
//
//  Created by Bradley Cutshall on 2/10/15.
//  Copyright (c) 2015 Pete Willemsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/highgui/cap_ios.h>
#import "ChangeNotifier.h"
#import "GestureController.h"
#import "AlertViewHandler.h"
#import "TouchType.h"
using namespace cv;

@interface AutoTrackPointsView : UIView {
    vector<Point2f> pointsVector;
    bool hasNewPoint;
    CGPoint newCGPoint;
    float xScalar;
    float yScalar;
}

//-(void)paintViewWithPoints: (vector<Point2f>) points;
-(void)paintViewWithPointsAndScalar: (vector<Point2f>) points : (float) X : (float) Y;
-(CGPoint)getNewPoint;

@property(nonatomic, strong) GestureController* gestureController;

@end
