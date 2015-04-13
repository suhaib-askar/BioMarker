//
//  sivelabFirstViewController.h
//  bioMechCap
//
//  Created by Renee Willemsen on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "sivelabPreviewView.h"
#import "sivelabVideoProcessor.h"

@interface sivelabFirstViewController : UIViewController <sivelabVideoProcessorDelegate>
{
    sivelabVideoProcessor *videoProcessor;
    
	UIView *previewView;
    sivelabPreviewView *oglView;
    UIBarButtonItem *recordButton;
	UILabel *frameRateLabel;
	UILabel *dimensionsLabel;
	UILabel *typeLabel;
    
    NSTimer *timer;
    
	BOOL shouldShowStats;
	
	UIBackgroundTaskIdentifier backgroundRecordingID;
}

@property (nonatomic, retain) IBOutlet UIView *previewView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *recordButton;

- (IBAction)toggleRecording:(id)sender;

@end
