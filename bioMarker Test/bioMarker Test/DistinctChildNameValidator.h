//
// Created by Dylan on 1/19/14.
// Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnnotationModelValidator.h"
#import "AnnotatedVideoModel.h"


/*
 * A validator that ensures that the newly added node will not
 * share the same name as one of it's siblings.
 */
@interface DistinctChildNameValidator : NSObject<AnnotationModelValidator> {
    AnnotatedVideoModel * annotatedVideoModel;
}

-(id) initWithAnnotationModel:(AnnotatedVideoModel *) annotationModel;

@end