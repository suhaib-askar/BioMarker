//
//  AnalysisUtil.h
//  bioMarker Test
//
//  Created by Dylan T Mcguire on 2/24/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnnotatedFrameData.h"
#import "AnnotatedVideoModel.h"

extern NSString* const LIMB_POINT_SEPARATOR;

@interface AnalysisUtil : NSObject

+(NSArray*) listJoints:(ContentNode*) limbNode;

+(NSDictionary*) getOrderPairsForJoint:(NSString*) jointLabel: (NSString*) limb: (AnnotatedVideoModel*) videoModel;

+(NSNumber*) getJointAngleForJointInFrame:(NSString*) jointlabel: (NSString*) limb: (AnnotatedFrameData*) frame;

@end
