//
//  AutoTrackViewWrapper.h
//  bioMarker Test
//
//  Created by Bradley Cutshall on 2/5/15.
//  Copyright (c) 2015 Pete Willemsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoTrackView.h"
#import "AutoTrackPointsView.h"

@interface AutoTrackViewWrapper : UIView {
    NSArray* startStopButtonText[2];
    UIAlertView* alert;

}

@property (strong, nonatomic) IBOutlet AutoTrackView *videoView;
@property (strong, nonatomic) IBOutlet AutoTrackPointsView *pointsView;
- (IBAction)startStopCamera:(id)sender;
- (IBAction)restartCamera:(id)sender;

@end
