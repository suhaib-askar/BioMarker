//
// Created by Dylan on 1/20/14.
// Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NodeType.h"
#import "AttributeKey.h"

@interface ContentNode : NSObject {

    NSString * nodeType;
    NSMutableArray *children;
    NSMutableDictionary *attributes;
    ContentNode * parent;

}

-(id) initWithType: (NSString *) type;

-(NSArray *) getChildren;
-(NSObject *) getAttribute: (NSString*) attributeKey;
-(NSString *) getType;
-(NSDictionary *)getAttributes;
-(ContentNode *) getParent;
-(void) setType:(NSString *) type;
-(void) setAttribute:(NSString *) attributeKey: (NSObject *) value;
-(void) addChild:(ContentNode *) child;
-(void) removeChild:(ContentNode *) node;
-(void) setParent:(ContentNode *) node;

@end