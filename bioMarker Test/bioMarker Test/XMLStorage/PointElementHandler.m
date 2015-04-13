//
//  PointElementHandler.m
//  bioMarker Test
//
//  Created by Dylan T Mcguire on 3/19/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import "PointElementHandler.h"

@implementation PointElementHandler

-(id) initWithParserContext:(ParserContext *)context {
    parserContext = context;
    return self;
}

-(void) handleElementStart:(NSDictionary *)attributes {
    float x = [[attributes objectForKey:@"x"] floatValue];
    float y = [[attributes objectForKey:@"y"] floatValue];
    NSString* name = [attributes objectForKey:@"name"];
    
    CGPoint point = CGPointMake(x, y);
    NSValue * pointValue = [NSValue valueWithCGPoint:point];
    
    ContentNode* pointNode = [AnnotationModelUtil createPointNodeWithName:name];
    [pointNode setAttribute:POINT_ATTRIBUTE : pointValue];
    
    [[parserContext getCurrentLimb] addChild:pointNode];
}

-(void) handleElementEnd {
    
}

@end
