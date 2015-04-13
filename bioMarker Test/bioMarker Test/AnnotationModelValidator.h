//
//  AnnotationModelValidator.h
//  bioMarker Test
//
//  Created by Dylan on 1/19/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AnnotationModelValidator <NSObject>

-(NSArray*) validate:(NSDictionary *) args;

@end
