//
//  GestureAction.h
//  bioMarker Test
//
//  Created by Dylan T Mcguire on 2/6/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AnnotatedFrameData.h"

@protocol GestureAction <NSObject>

-(bool) didPreformGesture: (NSArray*) eventStack: (NSString*) touchType;

-(void) preformAction: (NSArray*) eventStack;

@end
