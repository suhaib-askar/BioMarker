//
//  AnnotationGestureController.m
//  bioMarker Test
//
//  Created by Dylan T Mcguire on 2/6/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import "GestureController.h"
#import "TouchEvent.h"

@implementation GestureController
    

- (id)init {
    gestureActions = [[NSMutableArray alloc] init];
    eventStack = [[NSMutableArray alloc] init];
    return self;
}


- (bool)runGestureActions:(UITouch *)event: (NSString*) touchType{
    
    TouchEvent* touchEvent = [[TouchEvent alloc] initWithTouchAndType:event :touchType];
    [eventStack addObject:touchEvent];
    
    bool gesturePreformed = false;
    
    for (id<GestureAction> gestureAction in gestureActions) {
        if ([gestureAction didPreformGesture:eventStack : touchType]) {
            gesturePreformed = true;
            [gestureAction preformAction:eventStack];
        }
    }
    
    return gesturePreformed;
}


-(void) addGestureAction:(id<GestureAction>) gestureAction {
    [gestureActions addObject:gestureAction];
}

-(void) removeGestureAction:(id<GestureAction>) gestureAction {
    [gestureActions removeObject:gestureAction];
}

-(void) clearEventStack {
    [eventStack removeAllObjects];
}


@end
