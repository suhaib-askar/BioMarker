//
//  LimbTracker.m
//  bioMarker Test
//
//  Created by Dylan T Mcguire on 3/28/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import "LimbTracker.h"

@implementation LimbTracker


-(void) positionLimbsForNextFrame:(UIImage *)currentFrame :(UIImage *)nextFrame :(ContentNode *)rootNode {
    [AnnotationModelUtil getAllPointNodesFromRoot: rootNode];
}

@end
