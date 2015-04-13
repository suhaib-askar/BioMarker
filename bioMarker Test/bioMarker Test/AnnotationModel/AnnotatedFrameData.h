//
// Created by Dylan on 1/20/14.
// Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ContentNode.h"

@interface AnnotatedFrameData : NSObject {

    ContentNode * rootNode;

}
-(id) initWithRootNode: (ContentNode *) node;
-(ContentNode *) getRootNode;

@property(nonatomic) float frameTimeStamp;

@end