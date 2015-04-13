//
//  FramesToVideo.m
//  bioMarker Test
//
//  Created by Bradley Cutshall on 3/16/15.
//  Copyright (c) 2015 Pete Willemsen. All rights reserved.
//
// See FramesToVideo.h for object comments.

#import "FramesToVideo.h"

@implementation FramesToVideo

@synthesize framesArray;

-(id)init {
    recordingStatus = false;
    frameCounter = 0;
    fps = 30;
    frameName = [NSString stringWithFormat:@"FTV"];
    instanceDirectory = [NSString stringWithFormat:@"FTVdir/"];
    movieName = [[NSMutableString alloc] init];
    self.framesArray = [[NSMutableArray alloc] init];
    
    // Create nested directory inside of NSTemporaryDirectory
    appTempDirectory = NSTemporaryDirectory();
    bool created = false;
    created = [self createDirForImage:appTempDirectory :instanceDirectory];
    if (created) {NSLog(@"#FTV Folder Created.");}
        else {NSLog(@"#FTV Folder Not Created!");}

    
    // Preemptive Cleanup possible old frames reamaining in temp folder from a crash or anything.
    [self clearTmpDirectory];
    
    return self;
}


-(void)setVideoName: (NSString*) name {
    movieName = [NSMutableString stringWithString: name];
}

-(void)startRecording {
    // Just to be sure no rouge frames
    [self clearTmpDirectory];
    
    recordingStatus = true;
}

-(void)stopRecording {
    
    
    
    recordingStatus = false;
}

-(bool)isRecording {
    return recordingStatus;
}

-(bool)saveVideoToUserVideos{
    
    [self convertFramesToVideo];
    

    return false;
}

/*
 * Saves incoming frames into temporary storage. Set recording must be set to true before this will kickoff
 * https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIKitFunctionReference/index.html
 */
-(void)saveFrameToStorage : (UIImage*) image {
    
    if(recordingStatus) {

        NSString *fileName = [NSString stringWithFormat:@"%@%@%d",instanceDirectory,frameName,frameCounter];
        NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent: [NSString stringWithString:fileName] ];
        
        //NSLog(@"Writing: %@",filePath);
        
        NSData * data = [NSData dataWithData:UIImageJPEGRepresentation(image, 0.4f)];
        [data writeToFile:filePath atomically:YES];
        frameCounter++;
        
        // Must save frame data alongside the frame that is being stored
        // Here is some stuff from the manual frame data
        /*
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
        
        // Save points to storage as well
        /*
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
         */
        
    }
}

/*
 * Returns false if unsuccessful
 */
-(bool)convertFramesToVideo {
    
    // Temporary location to save video
    // ** Might want to name the video with a date and time **
    
    NSString* tmpMovName = [NSString stringWithFormat:@"%@%@.mov",frameName, [NSDate date]];
    NSString* path = [NSTemporaryDirectory() stringByAppendingPathComponent:instanceDirectory];
    NSURL* filePath = [NSURL fileURLWithPath:[path stringByAppendingPathComponent:tmpMovName]];
    

    NSLog(@"filePath: %@", filePath);
     NSError *error = nil;
     AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:
            filePath fileType:AVFileTypeQuickTimeMovie
            error:&error];
     
     NSParameterAssert(videoWriter);
     NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
            AVVideoCodecH264, AVVideoCodecKey,
            [NSNumber numberWithInt:480], AVVideoWidthKey,
            [NSNumber numberWithInt:640], AVVideoHeightKey,
            nil];
     AVAssetWriterInput* writerInput = [AVAssetWriterInput
            assetWriterInputWithMediaType:AVMediaTypeVideo
            outputSettings:videoSettings]; //retain should be removed if ARC
    
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor
                                                     assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput
                                                     sourcePixelBufferAttributes:nil];
    
     NSParameterAssert(writerInput);
     NSParameterAssert([videoWriter canAddInput:writerInput]);
     [videoWriter addInput:writerInput];
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    // Load frame from temporary storage
    NSMutableArray* tmpDirectory = [NSMutableArray arrayWithArray:([[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL])];
    
    // Remove movie from tmpDirectory
    // Messy linear search, however video tends to sit at end of array.
    int tmpCount = ([tmpDirectory count]) -1;
    for (int i=(tmpCount); i > -1; i--) {
        NSString *element = [tmpDirectory objectAtIndex:i];
        if ([[element pathExtension] isEqualToString:@"mov"]) {
            // Remove and exit
            [tmpDirectory removeObjectAtIndex:i];
            i = -1;
        }
    }
    
    // Need to sort array, contentsOfDirectoryAtPath does not return sorted.
    tmpDirectory = [self bubbleSort:tmpDirectory];
    
    // THERE STILL EXISTS A  SMALL MEMORY LEAK (~~ 0.01mb every loop)!!
    int counter = 0;
    while ([tmpDirectory count] > 0) {
        if(writerInput.readyForMoreMediaData) {
            
            // Get first element in array and pop.
            NSString* file = [tmpDirectory firstObject];
            [tmpDirectory removeObjectAtIndex:0];
            
            // Just incase video was not removed from array
            if(file != tmpMovName) {
                // Load frame from memory
                UIImage* img = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:file]];
                
                // Get CGImage data
                CGImageRef imageRef = CGImageCreateCopy(img.CGImage);
                
                // Make pixel buffer for adaptor
                CVPixelBufferRef  pixelBuffer = [self pixelBufferFromCGImage:imageRef];
                
                counter++;
                CMTime frameTime = CMTimeMake(1, fps);
                CMTime lastTime = CMTimeMake(counter, fps);
                CMTime presentTime = CMTimeAdd(lastTime, frameTime);
                //NSLog(@"Count: %d Frame: %@", counter,[path stringByAppendingPathComponent:file]);
                
                if (pixelBuffer != NULL) {
                    [adaptor appendPixelBuffer:pixelBuffer withPresentationTime:presentTime];
                }
                //[writerInput appendSampleBuffer:(CMSampleBufferRef)buffer];
                
                
                
                CGImageRelease(imageRef);
                CVPixelBufferRelease(pixelBuffer);
                
                
                
            }
        }
    }
    
    
    while(!writerInput.readyForMoreMediaData) {
        // Wait for any dragging sample buffer writes
    }
    
    
    [writerInput markAsFinished];

    [videoWriter finishWritingWithCompletionHandler:^{
        NSLog(@"#FTV Completed Writing Video");
    }];
    
    while(videoWriter.status != AVAssetWriterStatusCompleted) {
        // Waiting for the write to complete
    }
    
    // REMOVE THIS AND MOVE TO FUNCTION saveToUserVideos
    // Move from temp folder and save video to user videos
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([filePath path])) {
        // NOT SAVING TO PATH CORRECTLY!
        UISaveVideoAtPathToSavedPhotosAlbum([filePath path], nil, nil, nil);
    } else {
        NSLog(@"UIVideo Is Not Compatable!");
    }
    
    // Once done, clear temp folder
    [self clearTmpDirectory];
    
    return true;
}

/*
 * Bubble Sort
 * Assuming clean array that have elements with the format FTV###
 */
-(NSMutableArray *)bubbleSort:(NSMutableArray *)unsortedDataArray
{
    long count = unsortedDataArray.count;
    int i;
    bool swapped = TRUE;
    while (swapped){
        swapped = FALSE;
        for (i=1; i<count;i++)
        {
            int elementMinusOne = [[[unsortedDataArray objectAtIndex:(i-1)] substringFromIndex:[frameName length]] intValue];
            int element = [[[unsortedDataArray objectAtIndex:i] substringFromIndex:[frameName length]] intValue];
            
            //if ([unsortedDataArray objectAtIndex:(i-1)] > [unsortedDataArray objectAtIndex:i])
            if (elementMinusOne > element)
            {
                [unsortedDataArray exchangeObjectAtIndex:(i-1) withObjectAtIndex:i];
                swapped = TRUE;
            }
            //bubbleSortCount ++; //Increment the count everytime a switch is done, this line is not required in the production implementation.
        }
    }
    return unsortedDataArray;
}

/*
 * Credit: zoul stackexchange.com
 */
-(CVPixelBufferRef) pixelBufferFromCGImage: (CGImageRef) image {
    
    CGSize frameSize = CGSizeMake(CGImageGetWidth(image), CGImageGetHeight(image));
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:NO], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:NO], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, frameSize.width,
                                          frameSize.height,  kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options,
                                          &pxbuffer);
    

    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, frameSize.width,
                                                 frameSize.height, 8, 4*frameSize.width, rgbColorSpace,
                                                 kCGImageAlphaPremultipliedFirst);
    
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image),
                                           CGImageGetHeight(image)), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    

    
    return pxbuffer;
}



/*
 * Cleanup the frames written into the temp folder and restart frame counter.
 */

-(void)clearTmpDirectory
{
    
    int deletedFrames = 0;
    int debugFrameCounter = frameCounter;
    frameCounter = 0;
    
    // Build directory of NSTemporaryDirectory
    NSString* path = [NSTemporaryDirectory() stringByAppendingPathComponent:instanceDirectory];
    NSArray* tmpDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    //NSArray* tmpDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSTemporaryDirectory() error:NULL];
    
    
    NSLog(@"#FTV FramesFound: %d CreatedFrames: %d",[tmpDirectory count],debugFrameCounter);
    
    
    // Iterate through all files in tempDirectory
    for (NSString *file in tmpDirectory) {

        // Check to ensure only deleting files with leading 'frameName' variable tailed by a #
        if ([file length] > [frameName length]) {
            if ([[file substringToIndex:[frameName length]] isEqualToString: frameName]) {
                NSString* filePath = [path stringByAppendingPathComponent: file];
                //NSLog(@"Deleting: %@", filePath);
                // Delete appropriate file
                [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
                deletedFrames++;
            }
        }
    }
    
    NSLog(@"#FTV Deleted Frames: %d", deletedFrames);
}


/**
 *  Returns 0 for not created, 1 for created and 2 for exists
 */
-(bool)createDirForImage : (NSString*)directory :(NSString *)dirName
{
    bool status = false;
    //
    BOOL isDirectory;
    
    if ( ([directory length] > 0) && ([dirName length] > 0) ) {
        NSString *framesDir = [directory stringByAppendingPathComponent:[dirName substringToIndex:([dirName length]-1)]];
    
        if (![[NSFileManager defaultManager] fileExistsAtPath:framesDir isDirectory:&isDirectory] || !isDirectory)
        {
            NSError *error = nil;
            NSDictionary *attr = [NSDictionary dictionaryWithObject:NSFileProtectionComplete
                                                             forKey:NSFileProtectionKey];
            [[NSFileManager defaultManager] createDirectoryAtPath:framesDir
                                                         withIntermediateDirectories:YES
                                                         attributes:attr
                                                         error:&error];
            if (error) {
                NSLog(@"Error creating directory path: %@", [error localizedDescription]);
            } else {
                status = true;
                NSLog(@"Created Temp Folder: %@", framesDir);
            }
        }
    }
    return status;
}

@end
