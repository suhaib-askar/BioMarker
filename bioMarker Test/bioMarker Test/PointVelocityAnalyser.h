//
//  PointVelocityAnalyser.h
//  bioMarker Test
//
//  Created by Dylan T Mcguire on 2/25/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FrameAnnotationAnalyser.h"
#import "AnnotatedVideoModel.h"

@interface PointVelocityAnalyser : NSObject<FrameAnnotationAnalyser> {
    AnnotatedVideoModel* videoModel;
}

-(id)initWithAnnotatedVideoModel:(AnnotatedVideoModel*) annotationModel;

@end
