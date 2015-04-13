//
//  JointAngleOverTimeWithSpline2DAnalyser.h
//  bioMarker Test
//
//  Created by Dylan on 1/14/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FrameAnnotationAnalyser.h"
#import "AnnotatedVideoModel.h"

@interface JointAngleOverTimeWithSpline2DAnalyser : NSObject<FrameAnnotationAnalyser> {
    
    AnnotatedVideoModel* annotatedVideoModel;
    
}


-(id)initWithAnnotatedVideoModel:(AnnotatedVideoModel*) annotationModel;

@end
