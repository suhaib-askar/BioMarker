//
//  ViewController.h
//  bioMarker Test
//
//  Created by Pete Willemsen on 9/25/12.
//  Copyright (c) 2012 Pete Willemsen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    NSString *messageTitle;
    NSArray *helpMessages;
}


- (IBAction)informationAlert:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *LayoutOutlet;

@end
