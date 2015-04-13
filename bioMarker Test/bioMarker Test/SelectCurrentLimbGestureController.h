//
// Created by Dylan on 2/9/14.
// Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GestureAction.h"
#import "annotateView.h"


@interface SelectCurrentLimbGestureController : NSObject<GestureAction> {
    annotateView * view;
}

-(id) initWithAnnotationView:(annotateView *) renderedView;

@end