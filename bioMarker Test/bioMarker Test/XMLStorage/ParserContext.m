//
//  FrameBuilder.m
//  bioMarker Test
//
//  Created by Bradley Cutshall on 3/5/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import "ParserContext.h"

@implementation ParserContext

-(id)init{
    frameList = [[NSMutableArray alloc] init];
    return self;
}

-(void) setCurrentFrame:(AnnotatedFrameData*) frameData {
    currentFrameData = frameData;
}

-(void)addPointToCurrentLimb:(ContentNode*) contentNode {
    [currentLimb addChild:contentNode];
}

-(ContentNode*)getCurrentLimb {
    return currentLimb;
}

-(void)setCurrentLimb:(ContentNode *)limb {
    if (currentLimb != nil) {
        [AnnotationModelUtil addLimbToRootNode:currentFrameData :currentLimb];
    }
    currentLimb = limb;
}

-(void)finishFrame{
    if (currentLimb != nil) {
        [AnnotationModelUtil addLimbToRootNode:currentFrameData :currentLimb];
    }
    currentLimb = nil;
    [frameList addObject:currentFrameData];
}

-(NSArray*) getFramesList {
    return frameList;
}

@end
