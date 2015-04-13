//
//  AnalysisUtil.m
//  bioMarker Test
//
//  Created by Dylan T Mcguire on 2/24/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import "AnalysisUtil.h"
#import "ContentNode.h"
#import "AnnotationModelUtil.h"
@implementation AnalysisUtil

NSString* const LIMB_POINT_SEPARATOR = @":";

+(NSArray *)listJoints:(ContentNode *) limbNode {
    NSMutableArray* joints = [[NSMutableArray alloc] init];
    
    NSArray * pointNodes = [AnnotationModelUtil getPointNodesForLimbNode:limbNode];
    
    
    if([pointNodes count] > 2) {
        joints = [pointNodes subarrayWithRange:NSMakeRange(1, [pointNodes count] - 2)];
    }
    
    return joints;
}


+(NSDictionary *)getOrderPairsForJoint:(NSString *)jointLabel:(NSString*) limb: (AnnotatedVideoModel*) videoModel {
    NSMutableDictionary* dictionary;
    for (AnnotatedFrameData* frame in [videoModel getFrames]) {
        NSNumber *angle = [AnalysisUtil getJointAngleForJointInFrame:jointLabel :limb :frame];
        [dictionary setObject:angle forKey:[NSString stringWithFormat: @"%f", frame.frameTimeStamp]];
    }
    return dictionary;
}

+(NSNumber*)getJointAngleForJointInFrame:(NSString *)jointlabel:(NSString*) limb :(AnnotatedFrameData*)frameData {
    CGPoint a;
    CGPoint b;
    CGPoint jointPoint;
    NSArray * pointNodes = [AnnotationModelUtil getPointNodesForLimb:frameData :limb];
    for (int i = 0; i < [pointNodes count]; i++) {
        ContentNode * pointNode = pointNodes[i];
        if ([jointlabel isEqualToString:[pointNode getAttribute:NAME_ATTRIBUTE]]) {
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
