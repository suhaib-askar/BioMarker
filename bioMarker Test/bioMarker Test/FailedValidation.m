//
//  FailedValidation.m
//  bioMarker Test
//
//  Created by Dylan on 1/19/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import "FailedValidation.h"

@implementation FailedValidation


-(id) initWithFailMessage:(NSString *)failMessage {
    failureMessage = failMessage;
    return self;
}

-(NSString*) getFailureMessage {
    return failureMessage;
}


@end
