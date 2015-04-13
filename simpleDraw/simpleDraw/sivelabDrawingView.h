//
//  sivelabDrawingView.h
//  simpleDraw
//
//  Created by Pete Willemsen on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MATCGlossyButton;

@interface sivelabDrawingView : UIView
{
    UILabel *touchStatus;
    UILabel *methodStatus;
    UILabel *tapStatus;
    UILabel *currentPointStatus;

    UIImage *imageTest;
    
    IBOutlet MATCGlossyButton *glossyBlueButton;
    
    CGPoint previousPoint, currentPoint;
    NSMutableArray *drawnPoints;
}

@property (nonatomic, strong) IBOutlet UILabel *touchStatus;
@property (nonatomic, strong) IBOutlet UILabel *methodStatus;
@property (nonatomic, strong) IBOutlet UILabel *tapStatus;
@property (nonatomic, strong) IBOutlet UILabel *currentPointStatus;

@end
