//
//  RemovePointAnnotationGestureAction.m
//  bioMarker Test
//
//  Created by Dylan T Mcguire on 2/6/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import "RemovePointAnnotationGestureAction.h"
#import "GestureActionsUtil.h"
#import "TouchType.h"
#import "DeletePointAlertViewHandler.h"

@implementation RemovePointAnnotationGestureAction


- (id)initWithAnnotationView:(annotateView *)_view {
    view = _view;
    return self;
}

-(bool) didPreformGesture:(NSArray*)eventStack: (NSString*) touchType{
    UITouch* event = [GestureActionsUtil getCurrentEventFromStack:eventStack];
    
    if (![touchType isEqualToString:TOUCHES_DOWN] || [event tapCount] != 2) {
        return false;
    }
    
    CGPoint point = [event locationInView:view];
    
    if ([GestureActionsUtil pointExists:point.x :point.y :40 :view.currentFrameData]) {
        return true;
    }
    
    return false;
}

-(void) preformAction:(NSArray*)eventStack{
    [view setAlertViewHandler:[[DeletePointAlertViewHandler alloc] initWithAnnotateView:view andEventStack: eventStack]];
    UITouch* event = [GestureActionsUtil getCurrentEventFromStack:eventStack];
    CGPoint point = [event locationInView:view];
    
    ContentNode* nodeToRemove = [GestureActionsUtil findPoint:point.x :point.y :40 :view.currentFrameData];
    
    NSMutableString* message = [[NSMutableString alloc] initWithString:@"Remove point "];
    [message appendString:(NSString*)[nodeToRemove getAttribute: NAME_ATTRIBUTE]];
    [message appendString:@"?"];
    
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTitle:@"Confirm"];
    [alert setMessage:message];
    [alert setDelegate:view];
    [alert addButtonWithTitle:@"Cancel"];
    [alert addButtonWithTitle:@"Yes"];
    [alert show];

}

@end
