//
//  XMLStorageFactory.m
//  bioMarker Test
//
//  Created by Bradley Cutshall on 2/7/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//


#import "XMLStorageWriter.h"
#import "ContentNode.h"


@implementation XMLStorageWriter


+(void)createChildElements:(ContentNode*)lNode :(XMLWriter*)writer {
    
    for (ContentNode*node in lNode.getChildren) {
        [writer writeStartElement:@"point"];
        [writer writeAttribute:@"name" value:(NSString*)[node getAttribute:@"name"]];
        CGPoint point = [(NSValue*)[node getAttribute:@"point"] CGPointValue];
        [writer writeAttribute:@"x" value:[NSString stringWithFormat:@"%f", point.x]];
        [writer writeAttribute:@"y" value:[NSString stringWithFormat:@"%f", point.y]];
        [writer writeEndElement];
    }
}

/**
 *
 **/
+(void)createFrameElements:(NSArray*)annotatedFrames :(XMLWriter*)writer {
    [writer writeStartElement:@"video"];
    for (AnnotatedFrameData * frame in annotatedFrames) {
        // Start frame element
        [writer writeStartElement:@"frame"];
        [writer writeAttribute:@"timestamp" value:[[NSNumber numberWithFloat:frame.frameTimeStamp] stringValue]];
        for(ContentNode*limbNode in [AnnotationModelUtil getLimbNodes:frame] ) {
            
            [writer writeStartElement:@"limb"];
            [writer writeAttribute:@"name" value:(NSString*)[limbNode getAttribute:@"name"]];
            [self createChildElements:limbNode :writer];
            [writer writeEndElement];
        }
        // End frame element
        [writer writeEndElement];
    }
    [writer writeEndElement];
}

@end
