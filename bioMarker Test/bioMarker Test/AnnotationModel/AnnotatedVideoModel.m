//
//  AnnotatedVideoModel.m
//  bioMarker Test
//
//  Created by Ryan Grewatz on 8/3/13.
//  Copyright (c) 2013 Pete Willemsen. All rights reserved.
//

#import "AnnotatedVideoModel.h"
#import "AnnotatedFrameData.h"
#import "XMLStorageImpl.h"


@implementation AnnotatedVideoModel
@synthesize videoname;
-(AnnotatedVideoModel *)initWithVideoName:(NSMutableString *)videoName{
    videoname = videoName;
    storageDelegate = [[XMLStorageImpl alloc] initWithVideoName:videoName];
    framesLoaded = false;
    annotatatedFramesMap = [[NSMutableDictionary alloc] init];
    return self;
}


-(void)saveFrames{
    NSMutableArray* frames = [[NSMutableArray alloc] init];
    for(id key in annotatatedFramesMap) {
        id value = [annotatatedFramesMap objectForKey:key];
        [frames addObject:value];
    }
    [storageDelegate saveAnnotedFrames:frames];
}

-(void)loadFrames{
    //maybe change anotation storage so that it loads frames into a map initially
    //quick and dirty

    NSArray* frameList = [storageDelegate loadAnnotatedFrames];
    
    for (AnnotatedFrameData *frameData in frameList) {
        float frameTime = frameData.frameTimeStamp;
        NSString* key = [NSString stringWithFormat: @"%f", frameTime];
        [annotatatedFramesMap setValue:frameData forKey:key];
    }
    
    framesLoaded = true;
    
   // annotatedFrames = [storageDelegate loadAnnotatedFrames];
}

-(void)addFrame:(AnnotatedFrameData *)annotatedFrame{
    float frameTime = annotatedFrame.frameTimeStamp;
    NSString* key = [NSString stringWithFormat: @"%f", frameTime];
    [annotatatedFramesMap setValue:annotatedFrame forKey: key];
}

-(bool)inStorage {
    return [storageDelegate inStorage];
}

-(bool)isLoaded {
    return framesLoaded;
}

-(NSArray *)getFrames{
    NSMutableArray* frames = [[NSMutableArray alloc] init];
    for(id key in annotatatedFramesMap) {
        id value = [annotatatedFramesMap objectForKey:key];
        [frames addObject:value];
    }
    return frames;
}

-(AnnotatedFrameData *)getFrameByTime:(float)frameTime {
    //abstract float to key conversion
    NSString* key = [NSString stringWithFormat: @"%f", frameTime];
    
    return [annotatatedFramesMap objectForKey: key];
}

-(NSDictionary *)getAllFrames{
    return annotatatedFramesMap;
}
-(void) deleteFrameData{
    if([storageDelegate inStorage]){
    [storageDelegate deleteFile];
    }
}
@end
