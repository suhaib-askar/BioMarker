//
//  RemovePointAnnotationGestureAction.h
//  bioMarker Test
//
//  Created by Dylan T Mcguire on 2/6/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GestureAction.h"
#import "annotateView.h"

@interface RemovePointAnnotationGestureAction : NSObject<GestureAction> {
    annotateView* view;
}

-(id) initWithAnnotationView:(annotateView*) renderedView;

@end
