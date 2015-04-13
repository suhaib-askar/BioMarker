//
//  AnotateVideoSelectionViewController.m
//  bioMarker Test
//
//  Created by Dylan on 3/23/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import "AnotateVideoSelectionViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AnnotatedVideoModel.h"
#import "ListTapGestureRecognizer.h"
#import "VideoSelectionListElementWrapper.h"
#import "AnnotateVideoViewController.h"

@interface AnotateVideoSelectionViewController ()

@end

@implementation AnotateVideoSelectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    annotatedAssetList = [[NSMutableArray alloc] init];
    otherAssetList = [[NSMutableArray alloc] init];
    [(UIButton*)[self.view viewWithTag:3] setEnabled:false];
    [(UIButton*)[self.view viewWithTag:4] setEnabled:false];
    
    
    UIScrollView *annotatedScrollView = (UIScrollView*)[self.view viewWithTag:1];
    UIScrollView *otherScrollView = (UIScrollView*)[self.view viewWithTag:2];
    
	//unload content
    [[annotatedScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [[otherScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
    
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allVideos]];
            [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop){
                if (asset){
                    //Not sure why we built up the file name like this in the first place but here it is...
                    NSURL *imageUrl = [[asset defaultRepresentation] url];
                    NSMutableString *filename = [[NSMutableString alloc] init];
                    for(int i = 0; i < [[imageUrl absoluteString] length]; i++) {
                        char c = [[imageUrl absoluteString] characterAtIndex:i];
                        if(c != '/') {
                            [filename appendString:[NSString stringWithFormat:@"%c", c]];
                        }
                    }
                    
                    UIImage* thumb = [[UIImage alloc] initWithCGImage:[asset thumbnail]];
                    UIImageView* imageView = [[UIImageView alloc] initWithImage:thumb];
                    [imageView setUserInteractionEnabled:YES];
                    
                    AnnotatedVideoModel* videoModel = [[AnnotatedVideoModel alloc] initWithVideoName:filename];
                    if ([videoModel inStorage]) {
                        imageView.frame = CGRectOffset(imageView.frame, (imageView.frame.size.width + 5) * [annotatedAssetList count], 0);
                        [annotatedScrollView addSubview:imageView];
                        [annotatedScrollView setContentSize:CGSizeMake((imageView.frame.size.width + 5) * [annotatedAssetList count], 0)];
                        VideoSelectionListElementWrapper* wrapper = [[VideoSelectionListElementWrapper alloc] initWithBool:true];
                        wrapper.imageView = imageView;
                        wrapper.asset = asset;
                        wrapper.filename = filename;
                        wrapper.assetURL = imageUrl;
                        [annotatedAssetList addObject:wrapper];
                        UITapGestureRecognizer *singleTap = [[ListTapGestureRecognizer alloc] initWithTarget: self action:@selector (annotatedVideoSelected:) andIndex:[annotatedAssetList count]-1];
                        [imageView addGestureRecognizer: singleTap];
                    }
                    else {
                        imageView.frame = CGRectOffset(imageView.frame, (imageView.frame.size.width + 5) * [otherAssetList count], 0);
                        [otherScrollView addSubview:imageView];
                        [otherScrollView setContentSize:CGSizeMake((imageView.frame.size.width + 5) * ([otherAssetList count]+1), 0)];
                        VideoSelectionListElementWrapper* wrapper = [[VideoSelectionListElementWrapper alloc] initWithBool:true];
                        wrapper.imageView = imageView;
                        wrapper.asset = asset;
                        wrapper.filename = filename;
                        wrapper.assetURL = imageUrl;
                        [otherAssetList addObject:wrapper];
                        UITapGestureRecognizer *singleTap = [[ListTapGestureRecognizer alloc] initWithTarget: self action:@selector (otherVideoSelected:) andIndex:[otherAssetList count]-1];
                        [imageView addGestureRecognizer: singleTap];
                    }
                }
            }];
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"error enumerating AssetLibrary groups %@\n", error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)removeAnnotationData:(id)sender {
    AnnotatedVideoModel* videoModel = [[AnnotatedVideoModel alloc] initWithVideoName:selectedElement.filename];
    [videoModel deleteFrameData];
    //reload the view
    [self viewWillAppear: true];
}

-(void)annotatedVideoSelected:(id)sender {
    [self deselectCurrentElement];
    ListTapGestureRecognizer *recognizer = (ListTapGestureRecognizer*)sender;
    selectedElement = annotatedAssetList[[recognizer getElementIndex]];
    UIImageView* imageView = (UIImageView*)recognizer.view;
    [imageView.layer setBorderColor:[[UIColor cyanColor]CGColor]];
    [imageView. layer setBorderWidth:2.0];
    [(UIButton*)[self.view viewWithTag:3] setEnabled:true];
    [(UIButton*)[self.view viewWithTag:4] setEnabled:true];
}


-(void)otherVideoSelected:(id)sender {
    [self deselectCurrentElement];
    ListTapGestureRecognizer *recognizer = (ListTapGestureRecognizer*)sender;
    selectedElement = otherAssetList[[recognizer getElementIndex]];
    UIImageView* imageView = (UIImageView*)recognizer.view;
    [imageView.layer setBorderColor:[[UIColor cyanColor]CGColor]];
    [imageView. layer setBorderWidth:2.0];
    [(UIButton*)[self.view viewWithTag:3] setEnabled:false];
    [(UIButton*)[self.view viewWithTag:4] setEnabled:true];
}

-(IBAction) annotateVideo:(id)sender {
    AnnotateVideoViewController *annotateVideoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AnnotateVideoViewController"];
    annotateVideoViewController.annotatedVideoModel = [[AnnotatedVideoModel alloc] initWithVideoName:selectedElement.filename];
    annotateVideoViewController.imageURL = selectedElement.assetURL;
    [self.navigationController pushViewController:annotateVideoViewController animated:YES];
}

-(void) deselectCurrentElement{
    if (selectedElement != nil) {
        UIImageView* imageView = selectedElement.imageView;
        [imageView. layer setBorderWidth:0];
    }
}





@end
