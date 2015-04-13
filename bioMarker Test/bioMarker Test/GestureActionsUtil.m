//
//  GestureActionsUtil.m
//  bioMarker Test
//
//  Created by Dylan T Mcguire on 2/6/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import "GestureActionsUtil.h"
#import "TouchEvent.h"

@implementation GestureActionsUtil


+(bool)pointExists:(float)x :(float)y: (float)offset: (AnnotatedFrameData*) currentFrameData {
    return ( [self findPoint:x :y :offset :currentFrameData] != NULL);
}

+(ContentNode*)findPoint:(float)x :(float)y: (float)offset: (AnnotatedFrameData*) currentFrameData {
    //compensate for offset
    //x+=offset;
    //y-=offset;
    for(ContentNode * contentNode in [AnnotationModelUtil getAllPointNodes:currentFrameData]) {
        CGPoint point = [(NSValue *)[contentNode getAttribute:POINT_ATTRIBUTE] CGPointValue];
        
        if (fabsf(x - point.x) <25 && fabsf(y - point.y) < 25) {
            return contentNode;
        }
        
    }
    return NULL;
}


+(NSArray*) findNodesOnLine:(ContentNode*) node:(AnnotatedFrameData*) frameData {
    CGPoint b = [(NSValue *)[node getAttribute:POINT_ATTRIBUTE] CGPointValue];
    NSArray* pointNodes = [AnnotationModelUtil getAllPointNodes:frameData];
    int numPointNodes = pointNodes.count;
    NSMutableArray* pair = [[NSMutableArray alloc] init];
    for (int index = 0; index < numPointNodes-1; index++) {
        ContentNode* nodeA = pointNodes[index];
        ContentNode* nodeC = pointNodes[index +1];
        CGPoint a = [(NSValue *)[nodeA getAttribute:POINT_ATTRIBUTE] CGPointValue];
        CGPoint c = [(NSValue *)[nodeC getAttribute:POINT_ATTRIBUTE] CGPointValue];
        
        float crossproduct = (c.y - a.y) * (b.x - a.x) - (c.x - a.x) * (b.y - a.y);
        float dotproduct = (c.x - a.x) * (b.x - a.x) + (c.y - a.y)*(b.y - a.y);
        float squaredlengthba = (b.x - a.x)*(b.x - a.x) + (b.y - a.y)*(b.y - a.y);
        
        if ( fabsf(crossproduct) < 500.0 && dotproduct > 0 && dotproduct < squaredlengthba) {
            [pair addObject:nodeA];
            [pair addObject:nodeC];
        }
    }
    return pair;
}


+(UITouch*) getCurrentEventFromStack:(NSArray*) stack {
    int size = [stack count];
    TouchEvent* touchEvent = stack[size - 1];
    return [touchEvent getTouch];
}

+(UITouch*) getPreviousEventFromStack:(NSArray*) stack {
    int size = [stack count];
    if (size >= 2) {
        TouchEvent* touchEvent = stack[size - 2];
        return [touchEvent getTouch];
    }
    return nil;
}


+(NSString*) getCurrentTouchTypeFromStack:(NSArray*) stack{
    int size = [stack count];
    TouchEvent* touchEvent = stack[size - 1];
    return [touchEvent getTouchType];
}

+(NSString*) getPreviousTouchTypeFromStack:(NSArray*) stack{
    int size = [stack count];
    if (size >= 2) {
        TouchEvent* touchEvent = stack[size - 2];
        return [touchEvent getTouchType];
    }
    return nil;
}

@end
