//
//  MovePointAnnotationGestureAction.h
//  bioMarker Test
//
//  Created by Dylan T Mcguire on 2/7/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GestureAction.h"
#import "annotateView.h"
#import "ChangeListener.h"

@interface MovePointAnnotationGestureAction : NSObject<GestureAction, ChangeListener> {
    
    annotateView* view;
    ContentNode* cachedNode;
    
}


-(id) initWithAnnotationView:(annotateView*) renderedView;

@end
