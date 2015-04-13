//
//  SandBoxStorageImpl.h
//  bioMarker Test
//
//  Created by Dylan T Mcguire on 9/5/13.
//  Copyright (c) 2013 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnnotationStorage.h"

@interface SandBoxStorageImpl : NSObject<AnnotationStorage>
{
  //  NSString* filename;
    NSString* revisionNumber;
}

-(NSString *)GetDocumentDirectory;
-(NSArray *)getFileTextArray;
-(NSString *)buildRevisionString;
-(void) deleteFile;
@property(nonatomic,retain) NSString* filename;

@end
