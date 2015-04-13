//
// Created by Dylan on 1/20/14.
// Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import "AnnotatedFrameData.h"
#import "NodeType.h"

@implementation AnnotatedFrameData

-(id)init {
    rootNode = [[ContentNode alloc] initWithType:ROOT_NODE_TYPE];
    return self;
}

-(id)initWithRootNode:(ContentNode *)node {
    rootNode = node;
    return self;
}

-(ContentNode *)getRootNode {
    return rootNode;
}

@end