//
//  AnnotatedVideoModel.h
//  bioMarker Test
//
//  Created by Ryan Grewatz on 8/3/13.
//  Copyright (c) 2013 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnnotationStorage.h"
#import "SandBoxStorageImpl.h"
#import "AnnotatedFrameData.h"

@interface AnnotatedVideoModel : NSObject {
    NSDictionary *annotatatedFramesMap;
    bool framesLoaded;
    id<AnnotationStorage> storageDelegate;
    
}

-(NSArray*) getFrames;
-(void) addFrame:(AnnotatedFrameData*) annotatedFrame;
-(AnnotatedVideoModel*) initWithVideoName:(NSMutableString*) videoName;
-(void) loadFrames;
-(void) saveFrames;
-(bool) inStorage;
-(bool) isLoaded;
-(AnnotatedFrameData*)getFrameByTime:(float) frameTime;
-(NSDictionary *)getAllFrames;
-(void) deleteFrameData;
@property (nonatomic) NSString *videoname;
@end
