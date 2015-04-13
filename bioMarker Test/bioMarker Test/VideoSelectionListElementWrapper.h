//
//  VideoSelectionListElementWrapper.h
//  bioMarker Test
//
//  Created by Dylan on 3/23/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface VideoSelectionListElementWrapper : NSObject {
    bool annotated;
}

-(id)initWithBool:(bool) a;

-(bool) isAnnotated;

@property (nonatomic,retain) ALAsset* asset;
@property (nonatomic,retain) UIImageView* imageView;
@property (nonatomic,retain) NSString* filename;
@property (nonatomic, retain) NSURL* assetURL;

@end
