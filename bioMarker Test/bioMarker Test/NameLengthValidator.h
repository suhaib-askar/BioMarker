//
//  NameLengthValidator.h
//  bioMarker Test
//
//  Created by Dylan T Mcguire on 3/4/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnnotationModelValidator.h"

@interface NameLengthValidator : NSObject<AnnotationModelValidator> {
    int minLength;
    int maxLength;
}

@end
