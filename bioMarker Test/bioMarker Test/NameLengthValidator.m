//
//  NameLengthValidator.m
//  bioMarker Test
//
//  Created by Dylan T Mcguire on 3/4/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import "NameLengthValidator.h"
#import "FailedValidation.h"

@implementation NameLengthValidator

-(id)init {
    minLength = 1;
    maxLength = 15;
    
    return self;
}

-(NSArray*)validate:(NSDictionary *)args {
    NSMutableArray* faults = [[NSMutableArray alloc] init];
    NSString* enteredText = [args objectForKey:@"entered_text"];
    if (enteredText != nil) {
        if([enteredText length] > maxLength || [enteredText length] < minLength) {
            [faults addObject:[[FailedValidation alloc] initWithFailMessage:@"Text length out of range"]];
        }
    }
    
    return faults;
}

@end
