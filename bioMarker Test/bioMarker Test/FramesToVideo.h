//
//  FramesToVideo.h
//  bioMarker Test
//
//  Created by Bradley Cutshall on 3/16/15.
//  Copyright (c) 2015 Pete Willemsen. All rights reserved.
//
// This class should receive images, write the frames to a temporary
// location, and create videos from these frames on demand.
// This class should be an instance for a singular specific set
// of images.



//--- Deletes the frames in a temporary location
//--- On unload delete frames in temporary location


#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface FramesToVideo : NSObject {
// Variables
    bool recordingStatus;
    int frameCounter;
    int fps;
    NSString* frameName;
    NSString* instanceDirectory;
    NSString* appTempDirectory;
    NSMutableString* movieName;
}

// Functions
-(void)saveFrameToStorage : (UIImage*) image;
-(bool)convertFramesToVideo;
-(bool)saveVideoToUserVideos;
-(void)clearTmpDirectory;
-(bool)createDirForImage :(NSString*)directory :(NSString *) dirName;
-(void)setVideoName :(NSString*) name;
-(bool)isRecording;
-(void)startRecording;
-(void)stopRecording;

@property(nonatomic, strong) NSMutableArray * framesArray;

@end
