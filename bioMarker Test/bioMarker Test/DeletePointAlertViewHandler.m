//
//  DeletePointAlertViewHandler.m
//  bioMarker Test
//
//  Created by Dylan on 3/22/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import "DeletePointAlertViewHandler.h"
#import "GestureActionsUtil.h"

@implementation DeletePointAlertViewHandler

-(id) initWithAnnotateView:(annotateView*)annotationView andEventStack:(NSArray *)stack{
    view = annotationView;
    eventStack = stack;
    return self;
}

-(void)handleAlertViewButtonClick:(UIAlertView *)alert :(NSInteger)buttonIndex {
    //ignore the cancel button
    if(buttonIndex > 0) {
        UITouch* event = [GestureActionsUtil getCurrentEventFromStack:eventStack];
        CGPoint point = [event locationInView:view];
        
        ContentNode* nodeToRemove = [GestureActionsUtil findPoint:point.x :point.y :40 :view.currentFrameData];
        
        [AnnotationModelUtil removeNodeFromFrame:view.currentFrameData :nodeToRemove];
        
        NSArray* limbNodes = [AnnotationModelUtil getLimbNodes:view.currentFrameData];
        
        //remove the limb if it no longer has any children
        for (ContentNode* limb in limbNodes) {
            if ([[limb getChildren] count] == 0) {
                [AnnotationModelUtil removeNodeFromFrame:view.currentFrameData : limb];
            }
        }
        
        
        limbNodes = [AnnotationModelUtil getLimbNodes:view.currentFrameData];
        
        //set the current limb to something other than what was just deleted
        if ([limbNodes count] > 0) {
            view.currentLimb = (NSString*)[limbNodes[0] getAttribute:NAME_ATTRIBUTE];
        }
        else {
            view.currentLimb = nil;
        }
    }
}

@end
