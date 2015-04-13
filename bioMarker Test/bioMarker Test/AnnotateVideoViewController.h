//
//  AnnotateVideoViewController.h
//  bioMarker Test
//
//  Created by Pete Willemsen on 9/25/12.
//  Copyright (c) 2012 Pete Willemsen. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>  // defines constants such as kUTTypeMovie
#import <MediaPlayer/MediaPlayer.h>  // provides function to play video
#import <AssetsLibrary/AssetsLibrary.h>

#import "annotateView.h"
#import "AnnotatedVideoModel.h"
#import "AnnotatedFrameData.h"
#import "AnnotationModelValidationService.h"
#import "NameLengthValidator.h"

@interface AnnotateVideoViewController : UIViewController <UINavigationControllerDelegate>
{
    UIPopoverController *imagePickerPopoverController;
    //annotateView *internalRenderedView;
    float frametime;
    AnnotationModelValidationService* validationService;
}


- (IBAction)annotateVideo:(id)sender;
- (IBAction)generatePreviousFrame:(id)sender;
- (IBAction)generateNextFrame:(id)sender;
- (IBAction)newLimb:(id)sender;
- (IBAction)testAnnotateVideo:(id)sender;
- (IBAction)deleteData:(id)sender;

// For opening the UIImagePickerController - allows video to be selected from the media library
- (BOOL)startMediaBrowserFromViewController:(UIViewController*)controller usingDelegate:(id)delegate usingSender:(id)sender;

@property (weak, nonatomic) IBOutlet annotateView *internalRenderedView;
@property(nonatomic,retain) UIPopoverController *imagePickerPopoverController;
//@property(nonatomic,retain) annotateView *internalRenderedView;
@property(nonatomic,retain) NSURL *imageURL;
@property(nonatomic, retain) AnnotatedVideoModel *annotatedVideoModel;

@end
