//
//  JointAngleOverTime2DAnalyser.m
//  bioMarker Test
//
//  Created by Dylan on 1/12/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import "JointAngleOverTime2DAnalyser.h"
#import "frameData.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "AnnotationModelUtil.h"
#import "AnalysisUtil.h"

@implementation JointAngleOverTime2DAnalyser

-(id)initWithAnnotatedVideoModel:(AnnotatedVideoModel *)annotationModel {
    annotatedVideoModel = annotationModel;
    return self;
}

-(NSString*) getLabel {
    return @"Joint Angle";
}

-(NSArray*) listIdentifiers {
    NSMutableArray* identifiers = [[NSMutableArray alloc] init];
    AnnotatedFrameData* frame1 = [annotatedVideoModel getFrameByTime:0];
    NSArray* limbNodes = [AnnotationModelUtil getLimbNodes:frame1];
    
    for (ContentNode* limbNode in limbNodes) {
        NSArray* jointNodes = [AnalysisUtil listJoints:limbNode];
        for (ContentNode* jointNode in jointNodes) {
            NSMutableString* ident = [[NSMutableString alloc] init];
            NSString* limbName = (NSString*)[limbNode getAttribute:NAME_ATTRIBUTE];
            NSString* pointName = (NSString*)[jointNode getAttribute:NAME_ATTRIBUTE];
            [ident appendString:limbName];
            [ident appendString:LIMB_POINT_SEPARATOR];
            [ident appendString:pointName];
            
            [identifiers addObject:ident];
        }
    }
    
    return identifiers;
}

-(NSNumber*) getXPlotValue:(NSString *)identifierLabel: (float) videoTime {
    NSDecimalNumber *x = [[NSDecimalNumber alloc] initWithFloat:videoTime];
    return x;
}

-(NSNumber*) getYPlotValue:(NSString *)identifierLabel: (float) videoTime {

    AnnotatedFrameData *frameData = [annotatedVideoModel getFrameByTime:videoTime];
    NSArray* identifierInfo = [identifierLabel componentsSeparatedByString:@":"];
    
    NSString* limbKey = identifierInfo[0];
    NSString* jointKey = identifierInfo[1];
    
    CGPoint a;
    CGPoint b;
    CGPoint jointPoint;
    NSArray * pointNodes = [AnnotationModelUtil getPointNodesForLimb:frameData :limbKey];
    for (int i = 0; i < [pointNodes count]; i++) {
        ContentNode * pointNode = pointNodes[i];
        if ([jointKey isEqualToString:[pointNode getAttribute:NAME_ATTRIBUTE]]) {
            ContentNode * prevPoint = pointNodes[i-1];
            ContentNode * nextPoint = pointNodes[i+1];
            jointPoint = [(NSValue *) [pointNode getAttribute:POINT_ATTRIBUTE] CGPointValue];
            a = [(NSValue *) [prevPoint getAttribute:POINT_ATTRIBUTE] CGPointValue];
            b = [(NSValue *) [nextPoint getAttribute:POINT_ATTRIBUTE] CGPointValue];
        }
    }
    
    a.x  = a.x - jointPoint.x;
    a.y  = a.y - jointPoint.y;
    b.x  = b.x - jointPoint.x;
    b.y  = b.y - jointPoint.y;
    
    float lengthA,lengthB;
    lengthA = sqrtf((a.x*a.x)+(a.y*a.y));
    lengthB = sqrtf((b.x*b.x)+(b.y*b.y));
    float dotAB = a.x*b.x + a.y*b.y;
    float theta = acos(dotAB/(lengthA*lengthB));
    float deg = theta*180/3.1415926;
    NSDecimalNumber *myDeg = [[NSDecimalNumber alloc] initWithFloat:deg];
    return myDeg;

}


@end
