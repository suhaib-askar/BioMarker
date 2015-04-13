//
//  ViewController.m
//  bioMarker Test
//
//  Created by Pete Willemsen on 9/25/12.
//  Copyright (c) 2012 Pete Willemsen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    messageTitle = @"Information";
    helpMessages = [NSArray arrayWithObjects:
                    @"Play a previously recorded video",
                    @"Record a new video",
                    @"Annotate a video",
                    @"Analyze a video",
                    @"How to use BioMark",
                    nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * The buttons that offer help must be labeled a tag in the GUI builder.
 * Strings can be added to the helpMessages in viewDidLoad.
 * 0-4 already exist.
 */
- (IBAction)informationAlert:(UIButton *)sender {
    
    [[[UIAlertView alloc] initWithTitle:messageTitle
                            message: (NSString*)[helpMessages objectAtIndex:[sender tag]]
                            delegate:nil
                            cancelButtonTitle:@"Okay"
                            otherButtonTitles:nil, nil]show];
}
@end
