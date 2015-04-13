//
//  LimbElementHandler.m
//  bioMarker Test
//
//  Created by Dylan T Mcguire on 3/19/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import "LimbElementHandler.h"

@implementation LimbElementHandler

-(id) initWithParserContext:(ParserContext *)context {
    parserContext = context;
    return self;
}

-(void) handleElementStart:(NSDictionary *)attributes {
    ContentNode* limbNode = [AnnotationModelUtil createLimbNodeWithName:[attributes objectForKey:@"name"]];
    [parserContext setCurrentLimb:limbNode];
}

-(void) handleElementEnd {
    //no op
}

@end
