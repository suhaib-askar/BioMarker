//
//  AnnotationStorage.h
//  bioMarker Test
//
//  Created by Dylan T Mcguire on 9/5/13.
//  Copyright (c) 2013 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnnotatedFrameData.h"

@protocol AnnotationStorage <NSObject>

-(bool)inStorage;
-(NSArray*)loadAnnotatedFrames;
-(void)saveAnnotedFrames:(NSArray*) annotatedFrames;
-(void) deleteFile;
-(id)initWithVideoName:(NSMutableString*) videoname;

@end
