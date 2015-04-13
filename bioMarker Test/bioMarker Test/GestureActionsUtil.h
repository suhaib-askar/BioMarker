//
//  GestureActionsUtil.h
//  bioMarker Test
//
//  Created by Dylan T Mcguire on 2/6/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentNode.h"
#import "AnnotationModelUtil.h"
#import <UIKit/UIKit.h>

@interface GestureActionsUtil : NSObject

+(bool)pointExists:(float)x :(float)y: (float)offset: (AnnotatedFrameData*) currentFrameData;

+(ContentNode*)findPoint:(float)x :(float)y: (float)offset: (AnnotatedFrameData*) currentFrameData;

+(NSArray*) findNodesOnLine:(ContentNode*) node:(AnnotatedFrameData*) frameData;

+(UITouch*) getCurrentEventFromStack:(NSArray*) stack;

+(UITouch*) getPreviousEventFromStack:(NSArray*) stack;

+(NSString*) getCurrentTouchTypeFromStack:(NSArray*) stack;

+(NSString*) getPreviousTouchTypeFromStack:(NSArray*) stack;

@end
