//
//  FrameBuilder.h
//  bioMarker Test
//
//  Created by Bradley Cutshall on 3/5/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnnotationModelUtil.h"
#import "AnnotatedFrameData.h"
#import "AnnotatedVideoModel.h"
#import "ContentNode.h"

@interface ParserContext : NSObject {
    NSMutableArray* frameList;
    AnnotatedFrameData* currentFrameData;
    ContentNode* currentLimb;
}

-(void) setCurrentFrame:(AnnotatedFrameData*) frameData;

-(void)addLimb:(NSDictionary*)attributes;

-(void)addPointToCurrentLimb:(ContentNode*) contentNode;

-(ContentNode*)getCurrentLimb;

-(void)finishFrame;

-(void)setCurrentLimb:(ContentNode*) limb;

-(NSArray*) getFramesList;


@end
