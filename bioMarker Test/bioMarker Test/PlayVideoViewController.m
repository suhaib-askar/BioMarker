//
//  PlayVideoViewController.m
//  bioMarker Test
//
//  Created by Pete Willemsen on 9/25/12.
//  Copyright (c) 2012 Pete Willemsen. All rights reserved.
//

#import "PlayVideoViewController.h"

@interface PlayVideoViewController ()

@end

@implementation PlayVideoViewController


@synthesize imagePickerPopoverController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Again, this was automatically added via the instructions specified in the .h file.
- (IBAction)playVideo:(id)sender {
    
    // Since this is a delegate of the UIImagePickerController, we specify self below for the arguments.
    // This allows tapping the play button (this action) to open the UIImagePickerController resulting in the
    // user being able to select a video frmo the media library.
    [self startMediaBrowserFromViewController:self usingDelegate:self usingSender:sender];
    
}

-(BOOL)startMediaBrowserFromViewController:(UIViewController *)controller usingDelegate:(id)delegate usingSender:(id)sender {

    // BIG NOTE!  The UIImagePickerController is not available on the iPad the way I'm presenting it below.  Instead, we
    // need to use a UIPopoverController to do the pop-up picker.
        
    // 1 - Validate the argument data
    //
    // Make sure the UIImagePickerControllerSourceTypeSavedPhotosAlbum is actually on the device.  This is the source of
    // the media we're seeking.  If not there, then picker may attempt to select video from sources that don't exist,
    // resulting in a crash of the app.
    //
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (delegate == nil)
        || (controller == nil)) {
        return NO;
    }
    
    // 2 - Get image picker
    //
    // If source is available, create a UIImagePickerController (called mediaUI here).  Only interested in video for
    // this pass, so kUTTypeMovie is the only type set in the NSArray below.
    //
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    mediaUI.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *) kUTTypeMovie, nil];
    
    // Hides the controls for moving and scaling pictures, or for
    // trimming movies.  TO instead show the controls, use YES
    mediaUI.allowsEditing = YES;
    mediaUI.delegate = delegate;
    
    // 3 - Display image picker - doesn't work in iPad
    //     [controller presentModalViewController:mediaUI animated:YES];
    
    // Instead, need to create a popovercontroller to manage the presentation
    if (![imagePickerPopoverController isPopoverVisible]) {

        // Popover is not visible so get one ready
        imagePickerPopoverController = [[UIPopoverController alloc] initWithContentViewController:mediaUI];
        imagePickerPopoverController.delegate = delegate;
        [imagePickerPopoverController presentPopoverFromRect:CGRectMake(10.0f, 10.0f, 10.0f, 10.0f) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    }
    
    return YES;
}


// The following code:
// 1. gets the media type from the selection to confirm that its a video (what we care about in this example).
// 2. dismisses the popover so that it's not on the screen
// 3. Creates an instance of the MPMoviePlayerViewControll to play the video
// 4. Adds a callback once the movie finishes playing.
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // 1 - Get the media type
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    // 2 - Dismiss the image picker
    [imagePickerPopoverController dismissPopoverAnimated:NO];
    
    // Handle a movie capture
    if (CFStringCompare((__bridge_retained CFStringRef)mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        
        // 3 - Play the video
        MPMoviePlayerViewController *theMovie = [[MPMoviePlayerViewController alloc] initWithContentURL:[info objectForKey:UIImagePickerControllerMediaURL]];
        [self presentMoviePlayerViewControllerAnimated:theMovie];
        
        // 4 - register for the playback finished notifcation
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:theMovie];
    }
}

// responds to the user tapping the cancel button
-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [imagePickerPopoverController dismissPopoverAnimated:YES];
}

// when the movie is complete, this will be called and we can release the controller
-(void) myMovieFinishedCallback:(NSNotification*)aNotification {
    
    [self dismissMoviePlayerViewControllerAnimated];
    MPMoviePlayerController* theMovie = [aNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:theMovie];
    
}

@end
