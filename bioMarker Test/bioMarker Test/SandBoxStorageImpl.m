//
//  SandBoxStorageImpl.m
//  bioMarker Test
//
//  Created by Dylan T Mcguire on 9/5/13.
//  Copyright (c) 2013 Pete Willemsen. All rights reserved.
//

#import "SandBoxStorageImpl.h"
#import "AnnotatedFrameData.h"
#import "AnnotationModelUtil.h"

@implementation SandBoxStorageImpl
@synthesize filename;

-(id)initWithVideoName:(NSMutableString *)videoname{
    [videoname appendString:@".dat"];
    self.filename = videoname;
    revisionNumber = @"2.2";
    return self;
}

-(NSString*)buildRevisionString {
    NSMutableString* revisionString = [[NSMutableString alloc] initWithString:@"revision:"];
    [revisionString appendString:revisionNumber];
    return revisionString;
}

-(NSString *)GetDocumentDirectory{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    return homeDir;
}

-(NSArray*)getFileTextArray {
    NSMutableString *filepath = [[NSMutableString alloc] init];
    NSError *error;
    NSString *title;
    filepath = [self.GetDocumentDirectory stringByAppendingPathComponent:filename];
    NSString *txtInFile = [[NSString alloc] initWithContentsOfFile:filepath encoding:NSUnicodeStringEncoding error:&error];
    
    if(!txtInFile)
    {
        UIAlertView *tellErr = [[UIAlertView alloc] initWithTitle:title message:@"Unable to get text from file." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [tellErr show];
    }
    NSArray * stringArray = [txtInFile componentsSeparatedByString:@"\n"];
    
    return stringArray;
    
}


-(bool)inStorage{
    NSString* path = [self.GetDocumentDirectory stringByAppendingPathComponent:filename];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]) {
        NSArray* fileTextArray = [self getFileTextArray];
        NSString* revisionString = [self buildRevisionString];
        if ([revisionString isEqualToString:fileTextArray[0]]) {
            return true;
        }
    }
    return false;
}

    
-(void)saveAnnotedFrames:(NSArray *)annotatedFrames{
    NSMutableString *filePath = [[NSMutableString alloc] init];
    NSError *err;
    
    filePath = [self.GetDocumentDirectory stringByAppendingPathComponent:filename];
    
    NSMutableString *textToWrite = [[NSMutableString alloc] init];
    [textToWrite appendString:@"revision:"];
    [textToWrite appendString:revisionNumber];
    [textToWrite appendString:@"\n"];
    for(AnnotatedFrameData* frame in annotatedFrames) {
        NSString *timeStamp = [NSString stringWithFormat: @"time:%f\n", frame.frameTimeStamp];
        [textToWrite appendString: timeStamp];
        NSDictionary* points = [AnnotationModelUtil getSelectedPointsMap:frame];
        for(NSString* label in points) {
            
            CGPoint p = [[points objectForKey:label] CGPointValue];
            
            NSString *pointString = [NSString stringWithFormat: @"point:%@#%f,%f\n", label,p.x, p.y];
            [textToWrite appendString: pointString];
        }
        
        NSMutableString *connectionsString = [[NSMutableString alloc] init];
        [connectionsString appendString: @"connections:"];
        for(NSString* key in [AnnotationModelUtil getConnectionSets:frame]){
            [connectionsString appendString:key];
            [connectionsString appendString:@"["];
            for (NSArray *pair in [[AnnotationModelUtil getConnectionSets:frame] valueForKey:key]) {
                NSString* pairString = [NSString stringWithFormat: @"%@,%@ ",pair[0], pair[1]];
                [connectionsString appendString:pairString];
            }
            NSMutableString* trimmedConnectionsString = [[NSMutableString alloc] initWithString:[
                            connectionsString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            [trimmedConnectionsString appendString:@"]"];
            connectionsString = trimmedConnectionsString;
        }
        NSMutableString *finalConnectionsString = [[NSMutableString alloc] init];
        
        [finalConnectionsString appendString:[connectionsString stringByTrimmingCharactersInSet:
                                              [NSCharacterSet whitespaceCharacterSet]]];
        
        [finalConnectionsString appendString:@"\n"];
        [textToWrite appendString: finalConnectionsString];
    }
    
    BOOL ok = [textToWrite writeToFile:filePath atomically:YES encoding:NSUnicodeStringEncoding error:&err];
    
    if (!ok) {
        NSLog(@"Error writing file at %@\n%@",
              filePath, [err localizedFailureReason]);
    }
}



-(NSArray *)loadAnnotatedFrames{
    NSMutableArray *annotatedFrames = [[NSMutableArray alloc] init];
    
    NSMutableString *filepath = [[NSMutableString alloc] init];
    NSError *error;
    NSString *title;
    filepath = [self.GetDocumentDirectory stringByAppendingPathComponent:filename];
    NSString *txtInFile = [[NSString alloc] initWithContentsOfFile:filepath encoding:NSUnicodeStringEncoding error:&error];
    
    if(!txtInFile)
    {
        UIAlertView *tellErr = [[UIAlertView alloc] initWithTitle:title message:@"Unable to get text from file." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [tellErr show];
    }
    NSArray * stringArray = [txtInFile componentsSeparatedByString:@"\n"];
    NSString* revisionVal = stringArray[0];
    NSMutableString* revisionString = [[NSMutableString alloc] initWithString:@"revision:"];
    [revisionString appendString:revisionNumber];
    if ([revisionVal isEqualToString:revisionString]) {
        AnnotatedFrameData* currentFrame;
        for(NSString *line in stringArray) {
            if([line rangeOfString:@":"].location != NSNotFound) {
                NSArray *parts = [line componentsSeparatedByString:@":"];
                NSString *type = parts[0];
                NSString *value = parts[1];
                if([type isEqualToString:@"time"]) {
                    currentFrame = [[AnnotatedFrameData alloc] init];
                    currentFrame.frameTimeStamp = [value floatValue];
                    [annotatedFrames addObject: currentFrame];
                }
                if([type isEqualToString:@"point"]) {
                    NSArray* label_point = [value componentsSeparatedByString:@"#"];
                    NSString* label = label_point[0];
                    NSString* pointText = label_point[1];
                    NSArray *axes = [pointText componentsSeparatedByString:@","];
                    CGFloat x = [axes[0] floatValue];
                    CGFloat y = [axes[1] floatValue];
                    CGPoint point = CGPointMake(x, y);
                    [AnnotationModelUtil addSelectedPointToRootNode:currentFrame :label :[NSValue valueWithCGPoint:point]];
                }
                if([type isEqualToString:@"connections"]) {
                    NSArray* connectionSetsString = [value componentsSeparatedByString:@"]"];
                    for(NSString* connectionSetString in connectionSetsString){
                        if (![connectionSetString isEqualToString:@""]) {
                            NSArray* limbConnections = [connectionSetString componentsSeparatedByString:@"["];
                            NSString* limbKey = limbConnections[0];
                            NSString* limbConnectionsString = limbConnections[1];
                            NSArray* pairs = [limbConnectionsString componentsSeparatedByString:@" "];
                            NSMutableArray* frameDataPairs = [[NSMutableArray alloc] init];
                            for(NSString* pair in pairs) {
                                NSArray *pairParts = [pair componentsSeparatedByString:@","];
                                NSMutableArray *frameDataPair = [[NSMutableArray alloc] init];
                                [frameDataPair addObject:pairParts[0]];
                                [frameDataPair addObject:pairParts[1]];
                                [frameDataPairs addObject:frameDataPair];
                            }
                            ContentNode *limbNode = [AnnotationModelUtil createLimbNodeWithName:limbKey];
                            [AnnotationModelUtil addLimbToRootNode:currentFrame :limbNode];
                            for (NSArray * pair in frameDataPairs) {
                                [AnnotationModelUtil movePointsUnderLimbNode:currentFrame :limbKey :pair];
                            }
                        }
                    }
                }
            }
        }
    }
    return annotatedFrames;
}
-(void) deleteFile{
    NSMutableString *docPath = [[NSMutableString alloc] initWithString:@"Documents/"];
    [docPath appendString:filename];
    NSFileManager *manager = [[NSFileManager alloc] init];
    NSError *error = nil;
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:docPath];
    [manager removeItemAtPath:path error:&error];
}
@end
