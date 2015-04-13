//
//  TouchEvent.m
//  bioMarker Test
//
//  Created by Ryan E Grewatz on 2/10/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import "TouchEvent.h"

@implementation TouchEvent

-(id) initWithTouchAndType:(UITouch *)uiTouch :(NSString *)type {
    touch = uiTouch;
    touchType = type;
    return self;
}

-(NSString*) getTouchType {
    return touchType;
}

-(UITouch*) getTouch {
    return touch;
}

@end
