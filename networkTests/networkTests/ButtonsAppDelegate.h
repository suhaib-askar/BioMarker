//
//  ButtonsAppDelegate.h
//  networkTests
//
//  Created by Renee Willemsen on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ButtonsAppDelegate : NSObject
{
    NSTextField *statusLabel;
}

@property IBOutlet NSTextField *statusLabel;

- (IBAction)buttonPressed:(id)sender;

@end
