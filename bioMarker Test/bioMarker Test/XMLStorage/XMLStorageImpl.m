//
//  XMLStorageImpl.m
//  bioMarker Test
//
//  Created by Dylan T Mcguire on 1/24/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import "XMLStorageImpl.h"
#import "StorageUtil.h"

@implementation XMLStorageImpl
@synthesize filename;

/**
 * XMLStorageImpl Constructor
 * This implements AnnotationStorage.h
 **/
-(id)initWithVideoName:(NSMutableString*) videoname {
    filename = [videoname stringByAppendingString:@".xml"];
    documents = @"Documents";
    return self;
}

/**
 * Gets apps working directory
 **/
-(NSString *)getDocumentDirectory {
    NSString * directory = [NSHomeDirectory() stringByAppendingPathComponent:documents];
    return directory;
}

/**
 * Checks if storage items already exist
 **/
-(bool)inStorage {
    BOOL exists = FALSE;
    NSString * directory = [self.getDocumentDirectory stringByAppendingPathComponent:filename];
    NSFileManager * fileMgr = [NSFileManager defaultManager];
    if ([fileMgr fileExistsAtPath:directory]) {
        exists = TRUE;
    }
    return exists;
}

/**
 * Loads the frames from an xml doc into memory
 **/
-(NSArray*)loadAnnotatedFrames {
    ParserContext * parserContext = [[ParserContext alloc]init];
    if ([self inStorage]) {
        // Find File Path
        NSString * filePath = [self.getDocumentDirectory stringByAppendingPathComponent:filename];
        // Build Parser Delegate
        id<NSXMLParserDelegate> parserDelegate = [[XMLParserDelegate alloc] initWithParserContext:parserContext];
        // Build NSXML Parser with File Path
        NSXMLParser * xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
        // Set the parser delegate for NSXMLParser
        [xmlParser setDelegate:parserDelegate];
        //    NSArray * tempArray = [[NSMutableArray alloc] init];
        [xmlParser parse];
        /*
        bool successful = [xmlParser parse];
        if (![xmlParser parse]) {
            NSLog(@"XMLStorageParser Parsing Error: Parse not successful");
        }
         */
    }
    return [parserContext getFramesList];
}

/**
 *
 **/
-(void)saveAnnotedFrames:(NSArray*) annotatedFrames {
    NSError * err;
    NSString * filePath = [[self getDocumentDirectory] stringByAppendingPathComponent:filename];
    NSMutableString * xmlFileToWrite = [[NSMutableString alloc] init];
    XMLWriter * xmlWriter = [[XMLWriter alloc] init];
    
    [xmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [XMLStorageWriter createFrameElements:annotatedFrames:xmlWriter];
    [xmlWriter writeEndDocument];
    
    xmlFileToWrite = [xmlWriter toString];
    
    NSLog(xmlFileToWrite);
    
    BOOL ok = [xmlFileToWrite writeToFile:filePath atomically:YES encoding:NSUnicodeStringEncoding error:&err];
    if (!ok) {
        NSLog(@"Error writing file at %@\n%@", filePath, [err localizedFailureReason]);
    }
}

-(void) deleteFile {
    [StorageUtil deleteFile:filename];
}
@end
