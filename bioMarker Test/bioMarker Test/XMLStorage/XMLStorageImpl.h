//
//  XMLStorageImpl.h
//  bioMarker Test
//
//  Created by Dylan T Mcguire on 1/24/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLWriter.h"
#import "AnnotationStorage.h"
#import "XMLStorageWriter.h"
#import "AnnotationModelUtil.h"
#import "ParserContext.h"
#import "XMLParserDelegate.h"


@interface XMLStorageImpl : NSObject<AnnotationStorage>{
    NSString * videoName;
    NSString * revisionNumber;
    NSString * documents;
}

-(NSString *)getDocumentDirectory;

@property(nonatomic, retain) NSString * filename;
@end

