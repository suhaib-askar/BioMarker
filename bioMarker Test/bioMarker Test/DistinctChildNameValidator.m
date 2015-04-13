//
// Created by Dylan on 1/19/14.
// Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import "DistinctChildNameValidator.h"
#import "FailedValidation.h"


@implementation DistinctChildNameValidator




-(id)initWithAnnotationModel:(AnnotatedVideoModel *)annotationModel {
    annotatedVideoModel = annotationModel;
    return self;
}

 -(NSArray *) validate:(NSDictionary *) args {
     NSMutableArray * validationFaults = [[NSMutableArray alloc] init];
     NSString * enteredText = [args objectForKey:@"entered_text"];
     ContentNode *parentNode = [args objectForKey:@"parent_node"];
     if (enteredText != nil && parentNode != nil){
         NSArray* children = [parentNode getChildren];
         for (ContentNode* child in children) {
             if ([enteredText isEqualToString:(NSString*)[child getAttribute:NAME_ATTRIBUTE]]) {
                 NSMutableString* message = [[NSMutableString alloc] initWithString:@"Can not use name: "];
                 [message appendString:enteredText];
                 FailedValidation* failure = [[FailedValidation alloc] initWithFailMessage:message];
                 [validationFaults addObject:failure];
             }
         }
     }
     return validationFaults;
 }
@end