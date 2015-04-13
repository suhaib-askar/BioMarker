//
//  SpecialCharactersValidator.h
//  bioMarker Test
//
//  Created by Dylan on 3/22/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnnotationModelValidator.h"

@interface SpecialCharactersValidator : NSObject<AnnotationModelValidator> {
    NSArray* specialCharacters;
}

@end
