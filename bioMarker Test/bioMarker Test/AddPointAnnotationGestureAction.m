//
//  AddPointAnnotationGestureAction.m
//  bioMarker Test
//
//  Created by Dylan T Mcguire on 2/6/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import "AddPointAnnotationGestureAction.h"
#import "TouchType.h"
#import "GestureActionsUtil.h"
#import "AddPointAlertViewHandler.h"

@implementation AddPointAnnotationGestureAction

-(id)initWithAnnotationView:(annotateView *)view {
    _view = view;
    return self;
}


-(bool)didPreformGesture:(NSArray *)eventStack :(NSString *)touchType{
    UITouch* event = [GestureActionsUtil getCurrentEventFromStack:eventStack];
    if (![touchType isEqualToString:TOUCHES_DOWN] || [self wasPartofDoubleTap:eventStack] || _view.currentLimb == nil) {
        return false;
    }
    
    CGPoint point = [event locationInView:_view];
    
    if ([GestureActionsUtil pointExists:point.x :point.y :0 : _view.currentFrameData]) {
        return false;
    }
    
    return true;
}


-(void)preformAction:(NSArray *)eventStack{
    UITouch* event = [GestureActionsUtil getCurrentEventFromStack:eventStack];
    CGPoint point = [event locationInView:_view];
    _view.currentPoint = point;
    
    [_view setAlertViewHandler:[[AddPointAlertViewHandler alloc] initWithAnnotationView:_view]];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Title"
                                                    message:@"Please enter your text:"
                                                    delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"Done", nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.placeholder = @"Enter some text";
    
    [alert setDelegate:_view];
    
    [alert show];

}


-(bool) wasPartofDoubleTap:(NSArray*) eventStack {
    UITouch* curEvent = [GestureActionsUtil getCurrentEventFromStack:eventStack];
    UITouch* prevEvent = [GestureActionsUtil getPreviousEventFromStack: eventStack];
    
    if (prevEvent != nil) {
        NSTimeInterval curTime = [curEvent timestamp];
        NSTimeInterval prevTime = [prevEvent timestamp];
        
        if (curTime - prevTime < 1) {
            return true;
        }
    }
    
    return false;
}


@end
