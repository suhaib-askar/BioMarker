//
//  MovePointAnnotationGestureAction.m
//  bioMarker Test
//
//  Created by Dylan T Mcguire on 2/7/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import "MovePointAnnotationGestureAction.h"
#import "TouchType.h"
#import "GestureActionsUtil.h"


@implementation MovePointAnnotationGestureAction

-(id)initWithAnnotationView:(annotateView *)renderedView {
    view = renderedView;
    return self;
}

-(bool)didPreformGesture:(NSArray *)eventStack :(NSString *)touchType {
    if (![touchType isEqualToString:TOUCHES_MOVED]) {
        return false;
    }
    UITouch* event = [GestureActionsUtil getCurrentEventFromStack: eventStack];
    CGPoint point = [event locationInView:view];
    
    if (cachedNode != nil){
       // if ([self touchIsOnCachedNode:point]) {
            return true;
        //}
    }
    if ([GestureActionsUtil pointExists:point.x :point.y :0 :view.currentFrameData]) {
        cachedNode = [GestureActionsUtil findPoint:point.x :point.y :0 :view.currentFrameData];
        return true;
    }
    
    return false;
}

-(void)preformAction:(NSArray *)eventStack {
    UITouch* event = [GestureActionsUtil getCurrentEventFromStack: eventStack];
    CGPoint point = [event locationInView:view];
    [cachedNode setAttribute:POINT_ATTRIBUTE :[NSValue valueWithCGPoint:point]];
}

-(void)changeOccured {
    cachedNode = nil;
}

/*

-(bool) touchIsOnCachedNode:(CGPoint) touchPoint {
    CGPoint nodePoint = [(NSValue *)[cachedNode getAttribute:POINT_ATTRIBUTE] CGPointValue];
    
    if (fabsf(touchPoint.x - nodePoint.x) <50 && fabsf(touchPoint.y - nodePoint.y) < 50) {
        return true;
    }
    return false;
}
*/
@end
