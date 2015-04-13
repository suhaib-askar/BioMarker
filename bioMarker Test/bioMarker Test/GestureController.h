//
//  AnnotationGestureController.h
//  bioMarker Test
//
//  Created by Dylan T Mcguire on 2/6/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnnotatedFrameData.h"
#import "GestureAction.h"

@interface GestureController : NSObject {
    
    NSMutableArray* gestureActions;
    NSMutableArray* eventStack;
}

-(bool) runGestureActions:(UITouch*)event: (NSString*) touchType;


-(void) addGestureAction:(id<GestureAction>) gestureAction;

-(void) removeGestureAction:(id<GestureAction>) gestureAction;

-(void) clearEventStack;

@end
