//
//  PointVelocityAnalyser.m
//  bioMarker Test
//
//  Created by Dylan T Mcguire on 2/25/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import "PointVelocityAnalyser.h"
#import "AnnotationModelUtil.h"
#import "AnalysisUtil.h"

@implementation PointVelocityAnalyser

-(id)initWithAnnotatedVideoModel:(AnnotatedVideoModel *)annotationModel {
    videoModel = annotationModel;
    return self;
}

-(NSString*) getLabel {
    return @"Point Velocity";
}


-(NSArray*) listIdentifiers {
    NSMutableArray* identifiers = [[NSMutableArray alloc] init];
    AnnotatedFrameData* initialFrameData = [videoModel getFrameByTime:0];
    NSArray* pointNodes = [AnnotationModelUtil getAllPointNodes:initialFrameData];
    
    for (ContentNode* pointNode in pointNodes) {
        NSMutableString* ident = [[NSMutableString alloc] init];
        ContentNode* parentNode = [AnnotationModelUtil getLimbForPointNode: pointNode];
        NSString* limbName = (NSString*)[parentNode getAttribute:NAME_ATTRIBUTE];
        NSString* pointName = (NSString*)[pointNode getAttribute:NAME_ATTRIBUTE];
        [ident appendString:limbName];
        [ident appendString:LIMB_POINT_SEPARATOR];
        [ident appendString:pointName];
        [identifiers addObject:ident];
    }
    
    return identifiers;
}

-(NSNumber*) getXPlotValue:(NSString *)identifierLabel: (float) videoTime {
    NSDecimalNumber *x = [[NSDecimalNumber alloc] initWithFloat:videoTime];
    return x;
}

-(NSNumber*) getYPlotValue:(NSString *)identifierLabel: (float) videoTime {
    if (videoTime == 0) {
        return [[NSDecimalNumber alloc] initWithFloat:0];
    }
    AnnotatedFrameData *frameData = [videoModel getFrameByTime:videoTime];
    AnnotatedFrameData *prevFrameData = [videoModel getFrameByTime:(videoTime - .1)];
    
    NSArray* identifierInfo = [identifierLabel componentsSeparatedByString:LIMB_POINT_SEPARATOR];
    NSString* limbName = identifierInfo[0];
    NSString* pointName = identifierInfo[1];
    
    ContentNode* curPointNode = [AnnotationModelUtil getPointWithNameFromLimbWithName: pointName: limbName: frameData];
    ContentNode* prevPointNode = [AnnotationModelUtil getPointWithNameFromLimbWithName: pointName: limbName: prevFrameData];
    CGPoint curPoint = [(NSValue*)[curPointNode getAttribute:POINT_ATTRIBUTE] CGPointValue];
    CGPoint prevPoint = [(NSValue*)[prevPointNode getAttribute:POINT_ATTRIBUTE] CGPointValue];
    
    float xDiff = fabsf(curPoint.x - prevPoint.x);
    float yDiff = fabsf(curPoint.y - prevPoint.y);
    float totalDiff = xDiff = yDiff;
    float velocity = totalDiff = totalDiff/(.1);
    
    return [[NSDecimalNumber alloc] initWithFloat:velocity];
}

@end
