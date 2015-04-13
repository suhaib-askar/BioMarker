//
//  PlayVideoViewController.h
//  bioMarker Test
//
//  Created by Pete Willemsen on 9/25/12.
//  Copyright (c) 2012 Pete Willemsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>  // defines constants such as kUTTypeMovie
#import <MediaPlayer/MediaPlayer.h>  // provides function to play video

//
// The <UIImagePickerControllerDelegate, UINavigationControllerDelegate> section
// makes PlayVideoController a delegate for these two controllers.
//
@interface PlayVideoViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIPopoverController *imagePickerPopoverController;
}

//
// This action was created by first creating the button in the PlayViewController on the
// MainStoryBoard.  Once the button was created, I went into Assistant Editor mode (Middle button
// in the upper right of Xcode) to split the screen showing both the storyboard and the editor.
// With the PlayVideoViewController.h file (this file) open, using the connections inspector, I
// dragged the Touch Up Inside action and dragged it to just below the @interface line above, which
// created the IBAction below automatically.
//
- (IBAction)playVideo:(id)sender;

// For opening the UIImagePickerController - allows video to be selected from the media library
- (BOOL)startMediaBrowserFromViewController:(UIViewController*)controller usingDelegate:(id)delegate usingSender:(id)sender;

@property(nonatomic,retain) UIPopoverController *imagePickerPopoverController;

@end
