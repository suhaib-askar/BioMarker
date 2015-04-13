//
// Created by Dylan on 1/20/14.
// Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnnotatedFrameData.h"


@interface AnnotationModelUtil : NSObject

+(NSArray*) getAllPointNodesFromRoot:(ContentNode*) rootNode;

+(NSArray *) getLimbNodes:(AnnotatedFrameData *) frameData;

+ (ContentNode *)getLimbNodeWithName:(AnnotatedFrameData *) frameData: (NSString *)attributeValue;

+(NSArray *) getPointNodesForLimb:(AnnotatedFrameData *) frameData: (NSString *) limbName;

+(NSArray *) getPointNodesForLimbNode:(ContentNode *)limbNode;

+(ContentNode *) createLimbNodeWithName:(NSString *) name;

+ (ContentNode *)createPointNodeWithName:(NSString *)name;

+(NSArray *) getAllPointNodes:(AnnotatedFrameData *)frameData;

+(ContentNode*) getLimbForPointNode:(ContentNode*) pointNode;

+(ContentNode*) getPointWithNameFromLimbWithName:(NSString*)pointName:(NSString*)limbName:(AnnotatedFrameData*) frameData;

+(void)copyNode:(ContentNode *)nodeToCopy: (ContentNode *) copiedNode;

+(void) addPointNodeToLimb:(AnnotatedFrameData *) frameData: (NSString *) limbName: (ContentNode *) pointNode;

+(void) addLimbToRootNode:(AnnotatedFrameData *) frameData:(ContentNode *) limbNode;

+(void) removeNodeFromFrame:(AnnotatedFrameData*)frameData: (ContentNode*) node;

+(void) recursiveRemove:(ContentNode*) curNode: (ContentNode*) nodeToRemove;

//For save and load compatibility pretend these aren't here

+(NSDictionary *) getSelectedPointsMap:(AnnotatedFrameData *) frameData;

+(NSDictionary *) getConnectionSets:(AnnotatedFrameData *) frameData;

+(void) addSelectedPointToRootNode:(AnnotatedFrameData *) frameData: (NSString *) name: (NSValue *) point;

+(void) movePointsUnderLimbNode:(AnnotatedFrameData *) frameData: (NSString *) limbName: (NSArray *) pair;

@end