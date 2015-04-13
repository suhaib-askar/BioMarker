//
//  AddPointAlertViewHandler.m
//  bioMarker Test
//
//  Created by Dylan T Mcguire on 2/7/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import "AddPointAlertViewHandler.h"
#import "ContentNode.h"
#import "AnnotationModelUtil.h"
#import "GestureActionsUtil.h">

@implementation AddPointAlertViewHandler

-(id)initWithAnnotationView:(annotateView *)annotateView {
    view = annotateView;
    return self;
}

-(void) handleAlertViewButtonClick:(UIAlertView *)alert :(NSInteger)buttonIndex {
    //ignore the cancel button
    if(buttonIndex > 0) {
        UITextField *textField = [alert textFieldAtIndex:0];
        NSString *text = textField.text;
        if(text == nil || [text length] == 0) {
            return;
        } else {
            
            ContentNode * pointNode = [AnnotationModelUtil createPointNodeWithName:text];
            [pointNode setAttribute:POINT_ATTRIBUTE :[NSValue valueWithCGPoint:view.currentPoint]];
            [GestureActionsUtil findNodesOnLine:pointNode : view.currentFrameData];
            [AnnotationModelUtil addPointNodeToLimb:view.currentFrameData :view.currentLimb :pointNode];
        }
    }
}

@end
