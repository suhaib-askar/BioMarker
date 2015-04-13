//
//  AnnotateVideoViewController.m
//  bioMarker Test
//
//  Created by Pete Willemsen on 9/25/12.
//  Copyright (c) 2012 Pete Willemsen. All rights reserved.
//

#import "AnnotateVideoViewController.h"
#import "frameData.h"
#import "AnnotationModelUtil.h"
#import "GestureController.h"
#import "RemovePointAnnotationGestureAction.h"
#import "GestureAction.h"
#import "AddPointAnnotationGestureAction.h"
#import "MovePointAnnotationGestureAction.h"
#import "SelectCurrentLimbGestureController.h"
#import "DistinctChildNameValidator.h"
#import "SpecialCharactersValidator.h"

@interface AnnotateVideoViewController ()

@end

@implementation AnnotateVideoViewController

@synthesize imagePickerPopoverController;
@synthesize internalRenderedView;
@synthesize imageURL;
@synthesize annotatedVideoModel;
//@synthesize internalRenderedView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    //internalRenderedView = (annotateView *)self.view;
    //internalRenderedView = internalRenderedView;
    frametime = 0;
    
    if([annotatedVideoModel inStorage]) {
        [annotatedVideoModel loadFrames];
    }
    
    
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:imageURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = 0.0;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
    internalRenderedView.currentFrameImage = [UIImage imageWithCGImage:thumbnailImageRef];
    internalRenderedView.currentFrameImage = [internalRenderedView resizeImage:internalRenderedView.currentFrameImage newSize:CGSizeMake(internalRenderedView.currentFrameImage.size.width, internalRenderedView.currentFrameImage.size.height)];
    
    if (annotatedVideoModel != nil && [annotatedVideoModel isLoaded]) {
        AnnotatedFrameData *frameData = [annotatedVideoModel getFrameByTime:frametime];
        if(frameData != nil) {
            //renderedView.drawnPoints = frameData.selectedPoints;
            //renderedView.connectionSets = frameData.connectionSets;
            internalRenderedView.currentFrameData = frameData;
            internalRenderedView.currentLimb = [[NSMutableString alloc] initWithString: (NSString*) [[[frameData getRootNode] getChildren][0] getAttribute:NAME_ATTRIBUTE]];
        }
    }
    
    else {
        AnnotatedFrameData *frameData = [[AnnotatedFrameData alloc] init];
        internalRenderedView.currentFrameData = frameData;
    }
    
    ChangeNotifier* changeNotifier = [[ChangeNotifier alloc] init];
    //initialize gesture support
    GestureController* gestureController = [[GestureController alloc] init];
    id<GestureAction> removeGesture = [[RemovePointAnnotationGestureAction alloc] initWithAnnotationView:internalRenderedView];
    [gestureController addGestureAction: removeGesture];
    [gestureController addGestureAction: [[AddPointAnnotationGestureAction alloc] initWithAnnotationView:internalRenderedView]];
    id<GestureAction> moveGestureController = [[MovePointAnnotationGestureAction alloc]initWithAnnotationView:internalRenderedView];
    //this gesture action uses a cache so we need to register it with the change notifier
    [changeNotifier registerListener:moveGestureController];
    [gestureController addGestureAction:moveGestureController];
    [gestureController addGestureAction: [[SelectCurrentLimbGestureController alloc] initWithAnnotationView:internalRenderedView]];
    
    //initialize validation service
    
    validationService = [[AnnotationModelValidationService alloc] init];
    [validationService addValidator:[[DistinctChildNameValidator alloc] init]];
    [validationService addValidator:[[NameLengthValidator alloc] init]];
    [validationService addValidator:[[SpecialCharactersValidator alloc] init]];
    
    internalRenderedView.changeNotifier = changeNotifier;
    internalRenderedView.gestureController = gestureController;
    internalRenderedView.validationService = validationService;
    
    if ([[[internalRenderedView.currentFrameData getRootNode] getChildren] count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Limb Title"
                                                        message:@"Please enter the title of the limb:"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Done", nil];
        
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *textField = [alert textFieldAtIndex:0];
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.placeholder = @"Enter some text";
        
        [alert show];
    }
    
    
    
    [internalRenderedView setNeedsDisplay];
     
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)testAnnotateVideo:(id)sender {
    
    // Since this is a delegate of the UIImagePickerController, we specify self below for the arguments.
    // This allows tapping the annotate button (this action) to open the UIImagePickerController resulting in the
    // user being able to select a video frmo the media library.
    [self startMediaBrowserFromViewController:self usingDelegate:self usingSender:sender];
}

- (IBAction)generatePreviousFrame:(id)sender {
    
   // NSMutableArray * drawnPoints = [[NSMutableArray alloc] initWithArray:renderedView.drawnPoints];//SAVE ORIGINAL DRAWN POINTS AND RENDER POINTS IF THERE IS ANY
    //NSMutableDictionary * drawnPoints = [[NSMutableDictionary alloc] initWithDictionary:renderedView.drawnPoints];
    //NSMutableDictionary * connectionSets = renderedView.connectionSets;

    if (frametime == 0) {
        return;
    }
    
    //save data
    if(annotatedVideoModel != NULL) {
        AnnotatedFrameData *frameData = [AnnotatedFrameData alloc];
        frameData = internalRenderedView.currentFrameData;
        //frameData.selectedPoints = [drawnPoints copy];
        //frameData.connectionSets = [connectionSets copy];
        frameData.frameTimeStamp = frametime;
        [annotatedVideoModel addFrame:frameData];
        [annotatedVideoModel saveFrames];
    }
    
    frametime-=.1;
    //load data from previous frame
    if(annotatedVideoModel != NULL) {
        AnnotatedFrameData *frameData = [annotatedVideoModel getFrameByTime:frametime];
        if(frameData != nil) {
            internalRenderedView.currentFrameData = frameData;
        }

        else {
            internalRenderedView.currentFrameData = [[AnnotatedFrameData alloc] init];
        }
    }
    
    if (frametime < 0) frametime = 0;
    
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:imageURL];
    player.shouldAutoplay = NO;
    UIImage *image = [player thumbnailImageAtTime:frametime timeOption:MPMovieTimeOptionExact];
    internalRenderedView.currentFrameImage = image;
    internalRenderedView.currentFrameImage = [internalRenderedView resizeImage:internalRenderedView.currentFrameImage newSize:CGSizeMake(internalRenderedView.currentFrameImage.size.width, internalRenderedView.currentFrameImage.size.height)];
    /*
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:imageURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    
    CFTimeInterval thumbnailImageTime = frametime;
    
    CMTime time = CMTimeMake(thumbnailImageTime, 10);
   // CMTime *cmTime = [[[CMTime alloc ] init ]assetImageGenerator CMTimeMake thumbnailImageTime, 60];
    
    //printf(time);
    
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime: time actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
   // renderedView.currentFrameImage = [UIImage imageWithCGImage:thumbnailImageRef];
     */
    [internalRenderedView setNeedsDisplay];
}

- (IBAction)generateNextFrame:(id)sender {

    if(annotatedVideoModel != NULL) {
        AnnotatedFrameData *frameData = [AnnotatedFrameData alloc];
        frameData = internalRenderedView.currentFrameData;
        frameData.frameTimeStamp = frametime;
        [annotatedVideoModel addFrame:frameData];
        [annotatedVideoModel saveFrames];
    }

    ContentNode * tempNode = [[ContentNode alloc] init];
    [AnnotationModelUtil copyNode:[internalRenderedView.currentFrameData getRootNode]:tempNode];

    frametime+=.10000;

    if(annotatedVideoModel != NULL) {
        AnnotatedFrameData *frameData = [annotatedVideoModel getFrameByTime:frametime];
        if(frameData != nil) {
            internalRenderedView.currentFrameData = frameData;
        }

        else {
            internalRenderedView.currentFrameData = [[AnnotatedFrameData alloc] initWithRootNode:tempNode];
        }
    }

    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:imageURL];
    player.shouldAutoplay = NO; 
    UIImage *image = [player thumbnailImageAtTime:frametime timeOption:MPMovieTimeOptionExact];
    internalRenderedView.currentFrameImage = image;
    internalRenderedView.currentFrameImage = [internalRenderedView resizeImage:internalRenderedView.currentFrameImage newSize:CGSizeMake(internalRenderedView.currentFrameImage.size.width, internalRenderedView.currentFrameImage.size.height)];

    [internalRenderedView setNeedsDisplay];
}




// when the movie is complete, this will be called and we can release the controller
-(void) myMovieFinishedCallback:(NSNotification*)aNotification {
    
    [self dismissMoviePlayerViewControllerAnimated];
    MPMoviePlayerController* theMovie = [aNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:theMovie];
    
}

-(IBAction)newLimb:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Limb Title"
                                                    message:@"Please enter the title of the limb:"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Done", nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.placeholder = @"Enter some text";
    
    [alert show];
}

//call back function for the alert view
- (void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex > 0) {
        UITextField *textField = [alert textFieldAtIndex:0];
        NSString *text = textField.text;
        if(text == nil || [text length] == 0) {
            return;
        }
        internalRenderedView.currentLimb = [[NSMutableString alloc ] initWithString: text];
        
        ContentNode * limbNode = [AnnotationModelUtil createLimbNodeWithName:text];
        [AnnotationModelUtil addLimbToRootNode:internalRenderedView.currentFrameData :limbNode];
        
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if(validationService != nil) {
        NSString *inputText = [[alertView textFieldAtIndex:0] text];
        NSMutableDictionary* args = [[NSMutableDictionary alloc] init];
        [args setObject:inputText forKey:@"entered_text"];
        [args setObject:[internalRenderedView.currentFrameData getRootNode] forKey:@"parent_node"];
        NSArray* validationFalures = [validationService runValidations:args];
        if( [validationFalures count] == 0)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return YES;
}

- (IBAction)deleteData:(id)sender{
    [annotatedVideoModel deleteFrameData];
}

- (void)viewWillLayoutSubviews {
    [internalRenderedView viewChangedOrientation:UIInterfaceOrientationIsPortrait(self.interfaceOrientation)];
    
    
//    if (UIInterfaceOrientationIsLandscape(true)) {
//        NSLog(@"Left or Right");
//    }
//    else {
//        NSLog(@"Up Or Down");
//    }
    
}

@end
