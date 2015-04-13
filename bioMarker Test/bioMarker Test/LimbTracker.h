//
//  LimbTracker.h
//  bioMarker Test
//
//  Created by Dylan T Mcguire on 3/28/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnnotationModelUtil.h"

@interface LimbTracker : NSObject

-(void) positionLimbsForNextFrame:(UIImage*) currentFrame:(UIImage*) nextFrame:(ContentNode*) rootNode;

@end
