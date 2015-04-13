//
//  FailedValidation.h
//  bioMarker Test
//
//  Created by Dylan on 1/19/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FailedValidation : NSObject {
    
    //enum Severity* severity;
    NSString* failureMessage;
    
}


-(id) initWithFailMessage:(NSString*) failMessage;
-(NSString*) getFailureMessage;

/*
enum Severity {
    ERROR,
    WARNING,
};
*/

@end
