//
// Created by Dylan on 1/20/14.
// Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import "AnnotationModelUtil.h"
#import "frameData.h"
#import "ContentNode.h"
#import "AttributeKey.h"


@implementation AnnotationModelUtil

+(NSArray*) getAllPointNodesFromRoot:(ContentNode*) rootNode {
    
}

+ (NSArray *)getLimbNodes:(AnnotatedFrameData *)frameData {
    ContentNode * rootNode = [frameData getRootNode];

    NSMutableArray * limbNodes = [[NSMutableArray alloc] init];

    for (ContentNode * child in [rootNode getChildren]) {
        if ([LIMB_NODE_TYPE isEqualToString:[child getType]]) {
            [limbNodes addObject:child];
        }
    }

    return limbNodes;

}

+ (ContentNode *)getLimbNodeWithName:(AnnotatedFrameData *) frameData: (NSString *)attributeValue {

    for (ContentNode * limbNode in [self getLimbNodes:frameData]) {
        if ([(NSString *)[limbNode getAttribute:NAME_ATTRIBUTE] isEqualToString: attributeValue]) {
            return limbNode;
        }
    }

    return nil;
}

+ (NSArray *)getPointNodesForLimb:(AnnotatedFrameData *)frameData :(NSString *)limbName {
    NSMutableArray * pointNodes = [[NSMutableArray alloc] init];

    for (ContentNode * child in [self getLimbNodes: frameData]) {
        if ([limbName isEqualToString:[child getAttribute: NAME_ATTRIBUTE]]) {
            for (ContentNode * limbChild in [child getChildren]) {
                if ([POINT_NODE_TYPE isEqualToString:[limbChild getType]]) {
                    [pointNodes addObject:limbChild];
                }
            }
        }
    }

    return pointNodes;

}

+ (NSArray *)getPointNodesForLimbNode: (ContentNode *)limbNode {
    NSMutableArray * pointNodes = [[NSMutableArray alloc] init];

    for (ContentNode * childNode in [limbNode getChildren]) {
        if ([POINT_NODE_TYPE isEqualToString:[childNode getType]]) {
            [pointNodes addObject:childNode];
        }
    }

    return pointNodes;

}

+(ContentNode*) getPointWithNameFromLimbWithName:(NSString*)pointName:(NSString*)limbName:(AnnotatedFrameData*) frameData {
    NSArray* pointNodes = [AnnotationModelUtil getPointNodesForLimb:frameData :limbName];
    
    for (ContentNode* pointNode in pointNodes) {
        NSString* pointNodeName = (NSString*)[pointNode getAttribute:NAME_ATTRIBUTE];
        if ([pointNodeName isEqualToString:pointName]) {
            return pointNode;
        }
    }
    return nil;
}

+ (ContentNode *)createLimbNodeWithName:(NSString *)name {
    ContentNode * node = [[ContentNode alloc] initWithType:LIMB_NODE_TYPE];
    [node setAttribute:NAME_ATTRIBUTE :name];
    return node;
}

+ (ContentNode *)createPointNodeWithName:(NSString *)name {
    ContentNode * node = [[ContentNode alloc] initWithType:POINT_NODE_TYPE];
    [node setAttribute:NAME_ATTRIBUTE :name];
    return node;
}

+(ContentNode*) getLimbForPointNode:(ContentNode*)pointNode {
    if (pointNode == nil) {
        return nil;
    }
    ContentNode* parentNode = [pointNode getParent];
    if ([[parentNode getType] isEqualToString:LIMB_NODE_TYPE]) {
        return parentNode;
    }
    else {
        return [AnnotationModelUtil getLimbForPointNode:parentNode];
    }
}

+ (NSArray *)getAllPointNodes:(AnnotatedFrameData *)frameData {
    NSMutableArray * pointNodes = [[NSMutableArray alloc] init];
    for(ContentNode * limbNode in [self getLimbNodes:frameData]) {
        [pointNodes addObjectsFromArray: [self getPointNodesForLimb:frameData : [limbNode getAttribute:NAME_ATTRIBUTE]]];
    }
    return pointNodes;
}

+ (void)copyNode:(ContentNode *)nodeToCopy: (ContentNode *) copiedNode{
    [copiedNode setType:[[nodeToCopy getType] copy]];
    for (NSString * attKey in [nodeToCopy getAttributes]) {
        NSObject * value = [[nodeToCopy getAttribute:attKey] copy];
        [copiedNode setAttribute:attKey :value];
    }

    for (ContentNode * child in [nodeToCopy getChildren]) {
        ContentNode * newNode = [[ContentNode alloc] init];
        [self copyNode:child :newNode];
        [copiedNode addChild:newNode];
    }
}

+ (void)addPointNodeToLimb:(AnnotatedFrameData *)frameData :(NSString *)limbName :(ContentNode *)pointNode {
    ContentNode *limbNode = [self getLimbNodeWithName:frameData:limbName];
    [limbNode addChild:pointNode];
}

+(void)addLimbToRootNode:(AnnotatedFrameData *)frameData :(ContentNode *)limbNode {
    ContentNode * rootNode = [frameData getRootNode];
    [rootNode addChild:limbNode];
}


+(void) removeNodeFromFrame:(AnnotatedFrameData *)frameData :(ContentNode *)node {
    ContentNode* rootNode = [frameData getRootNode];
    [AnnotationModelUtil recursiveRemove: rootNode: node];
    
}
        
+(void) recursiveRemove:(ContentNode*) curNode: (ContentNode*) nodeToRemove {
    
    if ([[curNode getChildren] containsObject:nodeToRemove]) {
        [curNode removeChild: nodeToRemove];
    }
    
    else {
        for (ContentNode* child in [curNode getChildren]) {
            [AnnotationModelUtil recursiveRemove: child: nodeToRemove];
        }
    }
    
}
 
//For save and load compatibility pretend these aren't here

+(NSDictionary *)getSelectedPointsMap:(AnnotatedFrameData *)frameData {

    NSMutableDictionary * selectedPointsMap = [[NSMutableDictionary alloc] init];

    for (ContentNode *limbNode in [self getLimbNodes:frameData]) {
        for (ContentNode *limbChild in [limbNode getChildren]) {
            if ([POINT_NODE_TYPE isEqualToString:[limbChild getType]]) {
                NSString * name = [limbChild getAttribute:NAME_ATTRIBUTE];
                NSObject * point = [limbChild getAttribute:POINT_ATTRIBUTE];
                [selectedPointsMap setObject:point forKey:name];
            }
        }
    }

    return selectedPointsMap;

}

+ (NSDictionary *)getConnectionSets:(AnnotatedFrameData *)frameData {

    NSMutableDictionary * connectionSets = [[NSMutableDictionary alloc] init];

    for (ContentNode * limbNode in [self getLimbNodes:frameData]) {
        NSString * limbName = (NSString *)[limbNode getAttribute:NAME_ATTRIBUTE];
        NSArray *children = [limbNode getChildren];
        NSMutableArray * pairs = [[NSMutableArray alloc] init];
        for (int i = 0; i < children.count; i++) {
            if ((i + 1) < children.count) {
                NSMutableArray * pair = [[NSMutableArray alloc] init];
                NSString * pointName1 = (NSString *)[children[i] getAttribute:NAME_ATTRIBUTE];
                NSString * pointName2 = (NSString *)[children[i+1] getAttribute:NAME_ATTRIBUTE];
                [pair addObject:pointName1];
                [pair addObject:pointName2];
                [pairs addObject:pair];
            }
        }
        [connectionSets setObject:pairs forKey:limbName];
    }

    return connectionSets;

}

+ (void)addSelectedPointToRootNode:(AnnotatedFrameData *)frameData :(NSString *)name :(NSValue *)point {
    ContentNode * rootNode = [frameData getRootNode];
    ContentNode * pointNode = [[ContentNode alloc] initWithType:POINT_NODE_TYPE];
    [pointNode setAttribute: NAME_ATTRIBUTE: name];
    [pointNode setAttribute: POINT_ATTRIBUTE: point];
    [rootNode addChild:pointNode];
}

+ (void)movePointsUnderLimbNode:(AnnotatedFrameData *)frameData :(NSString *)limbName :(NSArray *)pair {
    ContentNode *rootNode = [frameData getRootNode];
    ContentNode *limbNode = [AnnotationModelUtil getLimbNodeWithName:frameData:limbName];

    NSArray * children = [[rootNode getChildren] copy];
    for (NSString *  name in pair) {
        for (ContentNode * child in children) {
            if ([name isEqualToString:[child getAttribute: NAME_ATTRIBUTE]]) {
                if (![[limbNode getChildren] containsObject:child]) {
                    [limbNode addChild:child];
                    [rootNode removeChild:child];
                }
            }
        }
    }

}



@end