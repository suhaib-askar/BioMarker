//
//  AnnotationModelValidationService.h
//  bioMarker Test
//
//  Created by Dylan on 1/19/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnnotationModelValidator.h"

@interface AnnotationModelValidationService : NSObject {

    NSMutableArray* validators;
}


-(void) addValidator:(id<AnnotationModelValidator>)validator;

-(NSArray *) runValidations:(NSDictionary*) args;


@end
