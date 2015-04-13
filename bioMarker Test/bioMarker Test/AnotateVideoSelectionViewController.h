//
//  AnotateVideoSelectionViewController.h
//  bioMarker Test
//
//  Created by Dylan on 3/23/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoSelectionListElementWrapper.h"

@interface AnotateVideoSelectionViewController : UIViewController {
    NSMutableArray* annotatedAssetList;
    NSMutableArray* otherAssetList;
    VideoSelectionListElementWrapper* selectedElement;
    bool loaded;
}

- (IBAction)removeAnnotationData:(id)sender;
- (IBAction) annotateVideo:(id)sender;

@end
