//
//  SpecialCharactersValidator.m
//  bioMarker Test
//
//  Created by Dylan on 3/22/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import "SpecialCharactersValidator.h"
#import "FailedValidation.h"

@implementation SpecialCharactersValidator

-(id)init {
    specialCharacters = [[NSArray alloc] initWithObjects:@":", nil];
    return self;
}

-(NSArray*)validate:(NSDictionary *)args {
    NSMutableArray* faults = [[NSMutableArray alloc] init];
    NSString* enteredText = [args objectForKey:@"entered_text"];
    for (NSString* specialCharacter in specialCharacters) {
        if ([enteredText rangeOfString:specialCharacter].location != NSNotFound) {
            [faults addObject:[[FailedValidation alloc] initWithFailMessage:@"Text contains special character"]];
        }
    }
    return faults;
}
@end
