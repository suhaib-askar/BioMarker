//
//  annotateView.h
//  bioMarker Test
//
//  Created by Pete Willemsen on 9/25/12.
//  Copyright (c) 2012 Pete Willemsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnnotatedFrameData.h"
#import "GestureController.h"
#import "AlertViewHandler.h"
#import "ChangeNotifier.h"
#import "AnnotationModelValidationService.h"
@interface annotateView : UIView
{
    UIImage* currentFrameImage;
    float offset;
    bool prevPointSet;
    bool isMovingPoint;
    CGPoint previousPoint, movingPoint;
    NSString* movingPointLabel;
   // NSMutableDictionary* connectionSets;
    NSMutableString *prevPointLabel;
    NSMutableString *currentPointLabel;
    NSString* currentConnection;
    NSMutableString* currentLimb;
    ContentNode * movingPointNode;
    id<AlertViewHandler> alertViewHandler;
}

-(void) viewChangedOrientation:(bool)isPortrait;
-(bool) pointExists:(float) x :(float) y;
-(NSString*) findPoint:(float) x :(float) y;
-(void) setAlertViewHandler:(id<AlertViewHandler>) handler;
-(UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize;

@property(nonatomic,retain) UIImage* currentFrameImage;
//@property(nonatomic,strong) NSMutableDictionary* drawnPoints;
//@property(nonatomic, strong) NSMutableDictionary* connectionSets;
@property(nonatomic, strong) NSMutableString * currentLimb;
@property(nonatomic, strong) AnnotatedFrameData * currentFrameData;
@property(nonatomic, strong) GestureController* gestureController;
@property(nonatomic, strong) AnnotationModelValidationService* validationService;
@property CGPoint currentPoint;
@property ChangeNotifier* changeNotifier;

@end
