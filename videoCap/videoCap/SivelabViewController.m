//
//  SivelabViewController.m
//  videoCap
//
//  Created by Pete Willemsen on 3/23/12.
//  Copyright (c) 2012 University of Minnesota Duluth. All rights reserved.
//

#import "SivelabViewController.h"

@interface SivelabViewController ()

@end

@implementation SivelabViewController

@synthesize PreviewLayer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//********** VIEW DID LOAD **********
- (void)viewDidLoad
{
    [super viewDidLoad];
    
	//---------------------------------
	//----- SETUP CAPTURE SESSION -----
	//---------------------------------
	NSLog(@"Setting up capture session");
	CaptureSession = [[AVCaptureSession alloc] init];
    
	//----- ADD INPUTS -----
	NSLog(@"Adding video input");
    
	//ADD VIDEO INPUT
	AVCaptureDevice *VideoDevice = nil;
    NSArray *devices = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
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
//    PreviewLayer.orientation = AVCaptureVideoOrientationPortrait;
    
    if ([PreviewLayer isOrientationSupported])
    {
        [PreviewLayer setOrientation:AVCaptureVideoOrientationPortrait];
    }
    
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIDeviceOrientationLandscapeLeft);
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
		} */
        
        // [library release];		
        
	}
}

//********** VIEW DID UNLOAD **********
- (void)viewDidUnload
{
	[super viewDidUnload];
    
//	[CaptureSession release];
	CaptureSession = nil;
//	[MovieFileOutput release];
	MovieFileOutput = nil;
//	[VideoInputDevice release];
	VideoInputDevice = nil;
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