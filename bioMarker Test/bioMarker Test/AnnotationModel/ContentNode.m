//
// Created by Dylan on 1/20/14.
// Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import "ContentNode.h"


@implementation ContentNode

-(id)init{
    nodeType = nil;
    children = [[NSMutableArray alloc] init];
    attributes = [[NSMutableDictionary alloc] init];
    return self;
}

-(id)initWithType:(NSString *)type {
    nodeType = type;
    children = [[NSMutableArray alloc] init];
    attributes = [[NSMutableDictionary alloc] init];
    return self;
}

-(NSArray *)getChildren {
    return children;
}

-(NSObject *)getAttribute:(NSString*)attributeKey {
    return [attributes objectForKey:attributeKey];
}

-(NSString *)getType {
    return nodeType;
}

- (NSDictionary *)getAttributes {
    return attributes;
}

- (ContentNode *)getParent {
    return parent;
}

- (void)setType:(NSString *)type {
    nodeType = type;
}

-(void)setAttribute:(NSString *)attributeKey :(NSObject *)value {
    [attributes setObject:value forKey:attributeKey];
}

-(void)addChild:(ContentNode *)child {
    [child setParent: self];
    [children addObject:child];
}

-(void)removeChild:(ContentNode *)node {
    [children removeObject:node];
}

-(void)setParent:(ContentNode *)node {
    parent = node;
}

@end