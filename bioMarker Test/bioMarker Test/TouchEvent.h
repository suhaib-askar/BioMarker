//
//  TouchEvent.h
//  bioMarker Test
//
//  Created by Ryan E Grewatz on 2/10/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TouchEvent : NSObject {
    NSString* touchType;
    UITouch* touch;
}

-(id) initWithTouchAndType:(UITouch*) uiTouch: (NSString*) type;

-(NSString*) getTouchType;

-(UITouch*) getTouch;


@end
