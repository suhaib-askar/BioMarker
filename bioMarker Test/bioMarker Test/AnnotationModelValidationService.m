//
//  AnnotationModelValidationService.m
//  bioMarker Test
//
//  Created by Dylan on 1/19/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import "AnnotationModelValidationService.h"
#import "FailedValidation.h"

@implementation AnnotationModelValidationService


- (id)init
{
    self = [super init];
    if (self) {
        validators = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) addValidator:(id<AnnotationModelValidator>)validator {
    [validators addObject:validator];
}

-(NSArray*) runValidations:(NSDictionary *)args {
    NSMutableArray* failedValidations = [[NSMutableArray alloc] init];
    for (id<AnnotationModelValidator> validator in validators) {
        NSArray* failures = [validator validate:args];
        if ([failures count] > 0) {
            [failedValidations addObjectsFromArray:failures];
        }
    }
    return failedValidations;
}
@end;
