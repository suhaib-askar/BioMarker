//
//  RecordVideoViewController.h
//  bioMarker Test
//
//  Created by Pete Willemsen on 9/25/12.
//  Copyright (c) 2012 Pete Willemsen. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface RecordVideoViewController : UIViewController

- (IBAction)recordAndPlay:(id)sender;
- (BOOL)startCameraControllerFromViewController:(UIViewController*)controller usingDelegate:(id)delegate;
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void*)contextInfo;

@end
