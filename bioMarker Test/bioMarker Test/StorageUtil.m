//
//  StorageUtil.m
//  bioMarker Test
//
//  Created by Dylan T Mcguire on 3/19/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import "StorageUtil.h"

@implementation StorageUtil

+(void) deleteFile:(NSString*) filename{
    NSMutableString *docPath = [[NSMutableString alloc] initWithString:@"Documents/"];
    [docPath appendString:filename];
    NSFileManager *manager = [[NSFileManager alloc] init];
    NSError *error = nil;
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:docPath];
    [manager removeItemAtPath:path error:&error];
}

@end
