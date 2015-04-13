//
//  ButtonsAppDelegate.m
//  networkTests
//
//  Created by Renee Willemsen on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ButtonsAppDelegate.h"

@implementation ButtonsAppDelegate

// Synthesize the accessors and mutators for statusLabel
@synthesize statusLabel;

- (IBAction)buttonPressed: (id)sender
{
    NSString *title = [sender title];
    NSString *labelText = [NSString stringWithFormat:@"%@ button pressed.", title];
    [statusLabel setStringValue:labelText];
}

@end
