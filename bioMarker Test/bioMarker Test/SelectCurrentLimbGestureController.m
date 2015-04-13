//
// Created by Dylan on 2/9/14.
// Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import "SelectCurrentLimbGestureController.h"
#import "TouchType.h"
#import "GestureActionsUtil.h"

@implementation SelectCurrentLimbGestureController

-(id)initWithAnnotationView:(annotateView *)renderedView {
    view = renderedView;
    return self;
}


-(bool)didPreformGesture:(NSArray *)eventStack :(NSString *)touchType {
    if (![touchType isEqualToString:TOUCHES_DOWN]) {
        return false;
    }

    UITouch* touch = [GestureActionsUtil getCurrentEventFromStack:eventStack];

    CGPoint point = [touch locationInView:view];

    if ([GestureActionsUtil pointExists:point.x :point.y :0 :view.currentFrameData]) {
        return true;
    }

    return false;

}


-(void)preformAction:(NSArray *)eventStack {
    UITouch* touch = [GestureActionsUtil getCurrentEventFromStack:eventStack];

    CGPoint point = [touch locationInView:view];
    ContentNode * pointNode = [GestureActionsUtil findPoint:point.x :point.y :0 :view.currentFrameData];
    ContentNode * limb = [pointNode getParent];
    NSString * limbName = (NSString*)[limb getAttribute:NAME_ATTRIBUTE];
    
    view.currentLimb = limbName;

}

@end