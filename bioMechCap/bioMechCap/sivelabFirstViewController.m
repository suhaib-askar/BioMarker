//
//  sivelabFirstViewController.m
//  bioMechCap
//
//  Created by Renee Willemsen on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "sivelabFirstViewController.h"

static inline double radians (double degrees) { return degrees * (M_PI / 180); }

@implementation sivelabFirstViewController

@synthesize previewView;
@synthesize recordButton;

- (void)updateLabels
{
	if (shouldShowStats) {
		NSString *frameRateString = [NSString stringWithFormat:@"%.2f FPS ", [videoProcessor videoFrameRate]];
 		frameRateLabel.text = frameRateString;
 		[frameRateLabel setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.25]];
 		
 		NSString *dimensionsString = [NSString stringWithFormat:@"%d x %d ", [videoProcessor videoDimensions].width, [videoProcessor videoDimensions].height];
 		dimensionsLabel.text = dimensionsString;
 		[dimensionsLabel setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.25]];
 		
 		CMVideoCodecType type = [videoProcessor videoType];
 		type = OSSwapHostToBigInt32( type );
 		NSString *typeString = [NSString stringWithFormat:@"%.4s ", (char*)&type];
 		typeLabel.text = typeString;
 		[typeLabel setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.25]];
 	}
 	else {
 		frameRateLabel.text = @"";
 		[frameRateLabel setBackgroundColor:[UIColor clearColor]];
 		
 		dimensionsLabel.text = @"";
 		[dimensionsLabel setBackgroundColor:[UIColor clearColor]];
 		
 		typeLabel.text = @"";
 		[typeLabel setBackgroundColor:[UIColor clearColor]];
 	}
}


- (UILabel *)labelWithText:(NSString *)text yPosition:(CGFloat)yPosition
{
	CGFloat labelWidth = 200.0;
	CGFloat labelHeight = 40.0;
	CGFloat xPosition = previewView.bounds.size.width - labelWidth - 10;
	CGRect labelFrame = CGRectMake(xPosition, yPosition, labelWidth, labelHeight);
	UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
	[label setFont:[UIFont systemFontOfSize:36]];
	[label setLineBreakMode:UILineBreakModeWordWrap];
	[label setTextAlignment:UITextAlignmentRight];
	[label setTextColor:[UIColor whiteColor]];
	[label setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.25]];
	[[label layer] setCornerRadius: 4];
	[label setText:text];
	
	return [label self];
}

- (void)applicationDidBecomeActive:(NSNotification*)notifcation
{
	// For performance reasons, we manually pause/resume the session when saving a recording.
	// If we try to resume the session in the background it will fail. Resume the session here as well to ensure we will succeed.
	[videoProcessor resumeCaptureSession];
}

// UIDeviceOrientationDidChangeNotification selector
- (void)deviceOrientationDidChange
{
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	// Don't update the reference orientation when the device orientation is face up/down or unknown.
	if ( UIDeviceOrientationIsPortrait(orientation) || UIDeviceOrientationIsLandscape(orientation) )
		[videoProcessor setReferenceOrientation:orientation];
}

- (void)viewDidLoad 
{
	[super viewDidLoad];
    
    // Initialize the class responsible for managing AV capture session and asset writer
    videoProcessor = [[sivelabVideoProcessor alloc] init];
	videoProcessor.delegate = self;
    
	// Keep track of changes to the device orientation so we can update the video processor
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    // Setup and start the capture session
    [videoProcessor setupAndStartCaptureSession];
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:[UIApplication sharedApplication]];
    
	oglView = [[sivelabPreviewView alloc] initWithFrame:CGRectZero];
	// Our interface is always in portrait.
	oglView.transform = [videoProcessor transformFromCurrentVideoOrientationToOrientation:UIInterfaceOrientationPortrait];
    [previewView addSubview:oglView];
 	CGRect bounds = CGRectZero;
 	bounds.size = [self.previewView convertRect:self.previewView.bounds toView:oglView].size;
 	oglView.bounds = bounds;
    oglView.center = CGPointMake(previewView.bounds.size.width/2.0, previewView.bounds.size.height/2.0);
 	
 	// Set up labels
 	shouldShowStats = YES;
	
	frameRateLabel = [self labelWithText:@"" yPosition: (CGFloat) 10.0];
	[previewView addSubview:frameRateLabel];
	
	dimensionsLabel = [self labelWithText:@"" yPosition: (CGFloat) 54.0];
	[previewView addSubview:dimensionsLabel];
	
	typeLabel = [self labelWithText:@"" yPosition: (CGFloat) 98.0];
	[previewView addSubview:typeLabel];
}

- (void)cleanup
{
	// [oglView release];
	oglView = nil;
    
    frameRateLabel = nil;
    dimensionsLabel = nil;
    typeLabel = nil;
	
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
	[[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    
	[notificationCenter removeObserver:self name:UIApplicationDidBecomeActiveNotification object:[UIApplication sharedApplication]];
    
    // Stop and tear down the capture session
	[videoProcessor stopAndTearDownCaptureSession];
	videoProcessor.delegate = nil;
    // [videoProcessor release];
}

- (void)viewDidUnload 
{
	[super viewDidUnload];
    
	[self cleanup];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
	timer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(updateLabels) userInfo:nil repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{	
	[super viewDidDisappear:animated];
    
	[timer invalidate];
	timer = nil;
}

- (void)dealloc 
{
	[self cleanup];
    
	// [super dealloc];
}

- (IBAction)toggleRecording:(id)sender 
{
	// Wait for the recording to start/stop before re-enabling the record button.
	[[self recordButton] setEnabled:NO];
	
	if ( [videoProcessor isRecording] ) {
		// The recordingWill/DidStop delegate methods will fire asynchronously in response to this call
		[videoProcessor stopRecording];
	}
	else {
		// The recordingWill/DidStart delegate methods will fire asynchronously in response to this call
        [videoProcessor startRecording];
	}
}

#pragma mark RosyWriterVideoProcessorDelegate

- (void)recordingWillStart
{
	dispatch_async(dispatch_get_main_queue(), ^{
		[[self recordButton] setEnabled:NO];	
		[[self recordButton] setTitle:@"Stop"];
        
		// Disable the idle timer while we are recording
		[UIApplication sharedApplication].idleTimerDisabled = YES;
        
		// Make sure we have time to finish saving the movie if the app is backgrounded during recording
		if ([[UIDevice currentDevice] isMultitaskingSupported])
			backgroundRecordingID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{}];
	});
}

- (void)recordingDidStart
{
	dispatch_async(dispatch_get_main_queue(), ^{
		[[self recordButton] setEnabled:YES];
	});
}

- (void)recordingWillStop
{
	dispatch_async(dispatch_get_main_queue(), ^{
		// Disable until saving to the camera roll is complete
		[[self recordButton] setTitle:@"Record"];
		[[self recordButton] setEnabled:NO];
		
		// Pause the capture session so that saving will be as fast as possible.
		// We resume the sesssion in recordingDidStop:
		[videoProcessor pauseCaptureSession];
	});
}

- (void)recordingDidStop
{
	dispatch_async(dispatch_get_main_queue(), ^{
		[[self recordButton] setEnabled:YES];
		
		[UIApplication sharedApplication].idleTimerDisabled = NO;
        
		[videoProcessor resumeCaptureSession];
        
		if ([[UIDevice currentDevice] isMultitaskingSupported]) {
			[[UIApplication sharedApplication] endBackgroundTask:backgroundRecordingID];
			backgroundRecordingID = UIBackgroundTaskInvalid;
		}
	});
}

- (void)pixelBufferReadyForDisplay:(CVPixelBufferRef)pixelBuffer
{
	// Don't make OpenGLES calls while in the background.
	if ( [UIApplication sharedApplication].applicationState != UIApplicationStateBackground )
		[oglView displayPixelBuffer:pixelBuffer];
}

@end







#if 0

- (UILabel *)labelWithText:(NSString *)text yPosition:(CGFloat)yPosition
{
	CGFloat labelWidth = 200.0;
	CGFloat labelHeight = 40.0;
	CGFloat xPosition = previewView.bounds.size.width - labelWidth - 10;
	CGRect labelFrame = CGRectMake(xPosition, yPosition, labelWidth, labelHeight);
	UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
	[label setFont:[UIFont systemFontOfSize:36]];
	[label setLineBreakMode:UILineBreakModeWordWrap];
	[label setTextAlignment:UITextAlignmentRight];
	[label setTextColor:[UIColor whiteColor]];
	[label setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.25]];
	[[label layer] setCornerRadius: 4];
	[label setText:text];
	
	return [label autorelease];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //---------------------------------
	//----- SETUP CAPTURE SESSION -----
	//---------------------------------
	NSLog(@"Setting up capture session");
	CaptureSession = [[AVCaptureSession alloc] init];
    
	//----- ADD INPUTS -----
	NSLog(@"Adding video input");
    
	//ADD VIDEO INPUT
	AVCaptureDevice *VideoDevice = nil;
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    // loop through and find the back facing camera
    for (AVCaptureDevice *dev in devices)
    {
        if ([dev position] == AVCaptureDevicePositionBack)
        {
            VideoDevice = dev;
        }
    }
    
    // Should have back facing camera at this point
    
	if (VideoDevice)
	{
		NSError *error;
		VideoInputDevice = [AVCaptureDeviceInput deviceInputWithDevice:VideoDevice error:&error];
		if (!error)
		{
			if ([CaptureSession canAddInput:VideoInputDevice])
				[CaptureSession addInput:VideoInputDevice];
			else
				NSLog(@"Couldn't add video input");
		}
		else
		{
			NSLog(@"Couldn't create video input");
		}
	}
	else
	{
		NSLog(@"Couldn't create video capture device");
	}
    
    //
    // ADD AUDIO INPUT
    // 
	NSLog(@"Adding audio input");
	AVCaptureDevice *audioCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
	NSError *error = nil;
	AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioCaptureDevice error:&error];
	if (audioInput)
	{
		[CaptureSession addInput:audioInput];
	}
    
	//----- ADD OUTPUTS -----
    
    //
	// ADD VIDEO PREVIEW LAYER of the data
    //
	NSLog(@"Adding video preview layer");
	[self setPreviewLayer:[[AVCaptureVideoPreviewLayer alloc] initWithSession:CaptureSession]];
    
    //	PreviewLayer.orientation = AVCaptureVideoOrientationLandscapeRight;		//<<SET ORIENTATION.  You can deliberatly set this wrong to flip the image and may actually need to set it wrong to get the right image
    PreviewLayer.orientation = AVCaptureVideoOrientationPortrait;
    
    //    if ([PreviewLayer isOrientationSupported])
    //    {
    //        [PreviewLayer setOrientation:AVCaptureVideoOrientationPortrait];
    //    }
    
	[[self PreviewLayer] setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    
    
	// ADD MOVIE FILE OUTPUT
	NSLog(@"Adding movie file output");
	MovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    
	Float64 TotalSeconds = 60;			//Total seconds
	int32_t preferredTimeScale = 30;	//Frames per second
	CMTime maxDuration = CMTimeMakeWithSeconds(TotalSeconds, preferredTimeScale);	//<<SET MAX DURATION
	MovieFileOutput.maxRecordedDuration = maxDuration;
    
	MovieFileOutput.minFreeDiskSpaceLimit = 1024 * 1024;						//<<SET MIN FREE SPACE IN BYTES FOR RECORDING TO CONTINUE ON A VOLUME
    
	if ([CaptureSession canAddOutput:MovieFileOutput])
		[CaptureSession addOutput:MovieFileOutput];
    
	//SET THE CONNECTION PROPERTIES (output properties)
	[self CameraSetOutputProperties];			//(We call a method as it also has to be done after changing camera)
    
	//----- SET THE IMAGE QUALITY / RESOLUTION -----
	//Options:
	//	AVCaptureSessionPresetHigh - Highest recording quality (varies per device)
	//	AVCaptureSessionPresetMedium - Suitable for WiFi sharing (actual values may change)
	//	AVCaptureSessionPresetLow - Suitable for 3G sharing (actual values may change)
	//	AVCaptureSessionPreset640x480 - 640x480 VGA (check its supported before setting it)
	//	AVCaptureSessionPreset1280x720 - 1280x720 720p HD (check its supported before setting it)
	//	AVCaptureSessionPresetPhoto - Full photo resolution (not supported for video output)
	NSLog(@"Setting image quality");
	[CaptureSession setSessionPreset:AVCaptureSessionPresetMedium];
    [CaptureSession setSessionPreset:AVCaptureSessionPresetHigh];
	if ([CaptureSession canSetSessionPreset:AVCaptureSessionPreset640x480])		//Check size based configs are supported before setting them
		[CaptureSession setSessionPreset:AVCaptureSessionPreset640x480];
    
	//----- DISPLAY THE PREVIEW LAYER -----
	//Display it full screen under out view controller existing controls
	NSLog(@"Display the preview layer");
	CGRect layerRect = [[[self view] layer] bounds];
	[PreviewLayer setBounds:layerRect];
	[PreviewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect),
                                          CGRectGetMidY(layerRect))];
    //    [[[self view] layer] addSublayer:[[self CaptureManager] previewLayer]];
	//We use this instead so it goes on a layer behind our UI controls (avoids us having to manually bring each control to the front):
	UIView *CameraView = [[UIView alloc] init];
	[[self view] addSubview:CameraView];
	[self.view sendSubviewToBack:CameraView];
    
	[[CameraView layer] addSublayer:PreviewLayer];
    
	//----- START THE CAPTURE SESSION RUNNING -----
	[CaptureSession startRunning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    
    //	[CaptureSession release];
	CaptureSession = nil;
    //	[MovieFileOutput release];
	MovieFileOutput = nil;
    //	[VideoInputDevice release];
	VideoInputDevice = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // return (interfaceOrientation == UIDeviceOrientationLandscapeLeft);

    return YES;
}

@synthesize PreviewLayer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}




//********** VIEW WILL APPEAR **********
//View about to be added to the window (called each time it appears)
//Occurs after other view's viewWillDisappear
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
	WeAreRecording = NO;
}

//********** CAMERA SET OUTPUT PROPERTIES **********
- (void) CameraSetOutputProperties
{
	//SET THE CONNECTION PROPERTIES (output properties)
	AVCaptureConnection *CaptureConnection = [MovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    
	//Set landscape (if required)
	if ([CaptureConnection isVideoOrientationSupported])
	{
		AVCaptureVideoOrientation orientation = AVCaptureVideoOrientationLandscapeRight;		//<<<<<SET VIDEO ORIENTATION IF LANDSCAPE
		[CaptureConnection setVideoOrientation:orientation];
	}
    
	//Set frame rate (if requried)
	CMTimeShow(CaptureConnection.videoMinFrameDuration);
	CMTimeShow(CaptureConnection.videoMaxFrameDuration);
    
	if (CaptureConnection.supportsVideoMinFrameDuration)
		CaptureConnection.videoMinFrameDuration = CMTimeMake(1, CAPTURE_FRAMES_PER_SECOND);
	if (CaptureConnection.supportsVideoMaxFrameDuration)
		CaptureConnection.videoMaxFrameDuration = CMTimeMake(1, CAPTURE_FRAMES_PER_SECOND);
    
	CMTimeShow(CaptureConnection.videoMinFrameDuration);
	CMTimeShow(CaptureConnection.videoMaxFrameDuration);
}

//********** GET CAMERA IN SPECIFIED POSITION IF IT EXISTS **********
- (AVCaptureDevice *) CameraWithPosition:(AVCaptureDevicePosition) Position
{
	NSArray *Devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
	for (AVCaptureDevice *Device in Devices)
	{
		if ([Device position] == Position)
		{
			return Device;
		}
	}
	return nil;
}

//********** CAMERA TOGGLE **********
- (IBAction)CameraToggleButtonPressed:(id)sender
{
	if ([[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count] > 1)		//Only do if device has multiple cameras
	{
		NSLog(@"Toggle camera");
		NSError *error;
		//AVCaptureDeviceInput *videoInput = [self videoInput];
		AVCaptureDeviceInput *NewVideoInput;
		AVCaptureDevicePosition position = [[VideoInputDevice device] position];
		if (position == AVCaptureDevicePositionBack)
		{
			NewVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self CameraWithPosition:AVCaptureDevicePositionFront] error:&error];
		}
		else if (position == AVCaptureDevicePositionFront)
		{
			NewVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self CameraWithPosition:AVCaptureDevicePositionBack] error:&error];
		}
        
		if (NewVideoInput != nil)
		{
			[CaptureSession beginConfiguration];		//We can now change the inputs and output configuration.  Use commitConfiguration to end
			[CaptureSession removeInput:VideoInputDevice];
			if ([CaptureSession canAddInput:NewVideoInput])
			{
				[CaptureSession addInput:NewVideoInput];
				VideoInputDevice = NewVideoInput;
			}
			else
			{
				[CaptureSession addInput:VideoInputDevice];
			}
            
			//Set the connection properties again
			[self CameraSetOutputProperties];
            
			[CaptureSession commitConfiguration];
            // [NewVideoInput release];
		}
	}
}

//********** START STOP RECORDING BUTTON **********
- (IBAction)StartStopButtonPressed:(id)sender
{
    
	if (!WeAreRecording)
	{
		//----- START RECORDING -----
		NSLog(@"START RECORDING");
		WeAreRecording = YES;
        
		//Create temporary URL to record to
		NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.mov"];
		NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		if ([fileManager fileExistsAtPath:outputPath])
		{
			NSError *error;
			if ([fileManager removeItemAtPath:outputPath error:&error] == NO)
			{
				//Error - handle if requried
			}
		}
		
        // [outputPath release];
        
		//Start recording
		[MovieFileOutput startRecordingToOutputFileURL:outputURL recordingDelegate:self];
        
		// [outputURL release];
	}
	else
	{
		//----- STOP RECORDING -----
		NSLog(@"STOP RECORDING");
		WeAreRecording = NO;
        
		[MovieFileOutput stopRecording];
	}
}

//********** DID FINISH RECORDING TO OUTPUT FILE AT URL **********
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput
didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
	  fromConnections:(NSArray *)connections
				error:(NSError *)error
{
    
	NSLog(@"didFinishRecordingToOutputFileAtURL - enter");
    
    BOOL RecordedSuccessfully = YES;
    if ([error code] != noErr)
	{
        // A problem occurred: Find out if the recording was successful.
        id value = [[error userInfo] objectForKey:AVErrorRecordingSuccessfullyFinishedKey];
        if (value)
		{
            RecordedSuccessfully = [value boolValue];
        }
    }
	if (RecordedSuccessfully)
	{
		//----- RECORDED SUCESSFULLY -----
        NSLog(@"didFinishRecordingToOutputFileAtURL - success");
        
        NSString *DestFilename = @ "output.mov";
        
        //Set the file save to URL
        NSLog(@"Starting recording to file: %@", DestFilename);
        NSString *DestPath;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //        DestPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:recor  stringByAppendingPathComponent:RECORD_TO_ADD_DIRECTORY];
        DestPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@""];
        DestPath = [DestPath stringByAppendingPathComponent:DestFilename];
        
        NSLog(@"Dest Path: %@", DestPath);
        
        NSURL* saveLocationURL = [[NSURL alloc] initFileURLWithPath:DestPath];
        [MovieFileOutput startRecordingToOutputFileURL:saveLocationURL recordingDelegate:self];
        //        [saveLocationURL release];
        
        
        /*
         ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
         if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputFileURL])
         {
         [library writeVideoAtPathToSavedPhotosAlbum:outputFileURL
         completionBlock:^(NSURL *assetURL, NSError *error)
         {
         if (error)
         {
         
         }
         }];
         }
         */
        
        // [library release];		
        
	}
}

//********** DEALLOC **********
- (void)dealloc
{
    //	[CaptureSession release];
    //	[MovieFileOutput release];
    //	[VideoInputDevice release];
    
    //	[super dealloc];
}

@end
#endif
