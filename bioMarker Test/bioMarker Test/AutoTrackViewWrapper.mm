//
//  AutoTrackViewWrapper.m
//  bioMarker Test
//
//  Created by Bradley Cutshall on 2/5/15.
//  Copyright (c) 2015 Pete Willemsen. All rights reserved.
//

#import "AutoTrackViewWrapper.h"

@implementation AutoTrackViewWrapper

@synthesize videoView;
@synthesize pointsView;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) awakeFromNib {
    // Start video and give user ability to place
    // points when the UIView loads.
    [videoView startStopVideo];
    [videoView setPointsView:pointsView];
}

- (IBAction)startStopRecording:(id)sender {

    //bool started = [videoView startStopRecording];
    if(![videoView isRecording]) {
        // Start recording
        [(UIButton*)sender setTitle:@"Stop Recording" forState:UIControlStateNormal];
        [videoView startStopRecording];
        // [videoView saveVideo]
    } else {
        // Stop recording
        [(UIButton*)sender setTitle:@"Start Recording" forState:UIControlStateNormal];
        
        // Stop saving frames
        [videoView startStopRecording];
        // Ask to save
        alert = [[UIAlertView alloc] initWithTitle:@"Save Video?" message:nil delegate:self cancelButtonTitle:@"Delete" otherButtonTitles:@"Save", nil];
        [alert show];
        
        
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) { // Set buttonIndex == 0 to handel "Ok"/"Yes" button response
        //[alert dismissWithClickedButtonIndex:-1 animated:NO];
        
        
        [self.videoView.framesToVideo saveVideoToUserVideos];
        //
    }
    if (buttonIndex == 0) {
        [self.videoView.framesToVideo clearTmpDirectory];
    }
}


- (IBAction)restartCamera:(id)sender {
    
    bool restarted = [videoView restartTracking];
}

/*
 * Subclasses of this view do not like to cleanup themselves.
 * Cleanup any objects here
 */
- (void)dealloc
{
    if (![videoView cleanupView]) {NSLog(@"Warning: AutoTrack views did not gracefully exit!");}
    videoView = nil;
    pointsView = nil;
}

@end
