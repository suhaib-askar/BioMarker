//
//  FrameElementHandler.m
//  bioMarker Test
//
//  Created by Dylan T Mcguire on 3/19/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import "FrameElementHandler.h"

@implementation FrameElementHandler


-(id)initWithParserContext:(ParserContext *)context {
    parserContext = context; 
    return self;
}

-(void) handleElementStart:(NSDictionary *)attributes {
    AnnotatedFrameData* frameData = [[AnnotatedFrameData alloc] init] ;
    float timeStamp = [[attributes objectForKey:@"timestamp"] floatValue];
    frameData.frameTimeStamp = timeStamp;
    [parserContext setCurrentFrame:frameData];
}

-(void) handleElementEnd {
    [parserContext finishFrame];
}

@end
