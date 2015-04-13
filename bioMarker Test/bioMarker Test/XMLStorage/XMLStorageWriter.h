//
//  XMLStorageFactory.h
//  bioMarker Test
//
//  Created by Bradley Cutshall on 2/7/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLWriter.h"
#import "AnnotatedFrameData.h"
#import "AnnotationModelUtil.h"
#import "NodeType.h"

@interface XMLStorageWriter : NSObject{
}

+(void)createFrameElements:(NSArray*)annotatedFrames :(XMLWriter*)writer;


@end
