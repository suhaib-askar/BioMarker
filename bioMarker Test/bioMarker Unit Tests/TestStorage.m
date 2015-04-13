//
//  TestStorage.m
//  bioMarker Test
//
//  Created by Dylan T Mcguire on 3/7/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AnnotatedVideoModel.h"
#import "AnnotationModelUtil.h"

@interface TestStorage : XCTestCase

@end

@implementation TestStorage

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    AnnotatedVideoModel* originalVideoModel = [[AnnotatedVideoModel alloc] initWithVideoName:[[NSMutableString alloc] initWithString:@"testVid"]];
    
    //generate some frames for testing
    AnnotatedFrameData* frameData1 = [[AnnotatedFrameData alloc] init];
    AnnotatedFrameData* frameData2 = [[AnnotatedFrameData alloc] init];
    AnnotatedFrameData* frameData3 = [[AnnotatedFrameData alloc] init];
    frameData1.frameTimeStamp = 0;
    frameData2.frameTimeStamp = .1;
    frameData3.frameTimeStamp = .2;
    
    //add some limbs
    ContentNode*limbNodeArm1 = [[ContentNode alloc] initWithType:LIMB_NODE_TYPE];
    [limbNodeArm1 setAttribute:NAME_ATTRIBUTE :@"Arm1" ];
    ContentNode*limbNodeArm2 = [[ContentNode alloc] initWithType:LIMB_NODE_TYPE];
    [limbNodeArm2 setAttribute:NAME_ATTRIBUTE :@"Arm2" ];
    
    ContentNode* pointNodeA = [[ContentNode alloc] initWithType:POINT_NODE_TYPE];
    ContentNode* pointNodeB = [[ContentNode alloc] initWithType:POINT_NODE_TYPE];
    ContentNode* pointNodeC = [[ContentNode alloc] initWithType:POINT_NODE_TYPE];
    ContentNode* pointNodeD = [[ContentNode alloc] initWithType:POINT_NODE_TYPE];
    ContentNode* pointNodeE = [[ContentNode alloc] initWithType:POINT_NODE_TYPE];
    ContentNode* pointNodeF = [[ContentNode alloc] initWithType:POINT_NODE_TYPE];
    
    [pointNodeA setAttribute:NAME_ATTRIBUTE :@"A"];
    [pointNodeB setAttribute:NAME_ATTRIBUTE :@"B"];
    [pointNodeC setAttribute:NAME_ATTRIBUTE :@"C"];
    [pointNodeD setAttribute:NAME_ATTRIBUTE :@"D"];
    [pointNodeE setAttribute:NAME_ATTRIBUTE :@"E"];
    [pointNodeF setAttribute:NAME_ATTRIBUTE :@"F"];
    
    NSValue* pointA = [NSValue valueWithCGPoint:CGPointMake(100, 100)];
    NSValue* pointB = [NSValue valueWithCGPoint:CGPointMake(23, 16)];
    NSValue* pointC = [NSValue valueWithCGPoint:CGPointMake(143, 286)];
    NSValue* pointD = [NSValue valueWithCGPoint:CGPointMake(154, 350)];
    NSValue* pointE = [NSValue valueWithCGPoint:CGPointMake(450, 100)];
    NSValue* pointF = [NSValue valueWithCGPoint:CGPointMake(215, 160)];
    
    [pointNodeA setAttribute:POINT_ATTRIBUTE :pointA];
    [pointNodeB setAttribute:POINT_ATTRIBUTE :pointB];
    [pointNodeC setAttribute:POINT_ATTRIBUTE :pointC];
    [pointNodeD setAttribute:POINT_ATTRIBUTE :pointD];
    [pointNodeE setAttribute:POINT_ATTRIBUTE :pointE];
    [pointNodeF setAttribute:POINT_ATTRIBUTE :pointF];
    
    [limbNodeArm1 addChild:pointNodeA];
    [limbNodeArm1 addChild:pointNodeB];
    [limbNodeArm1 addChild:pointNodeC];
    [limbNodeArm2 addChild:pointNodeD];
    [limbNodeArm2 addChild:pointNodeE];
    [limbNodeArm2 addChild:pointNodeF];

    [[frameData1 getRootNode] addChild:limbNodeArm1];
    [[frameData1 getRootNode] addChild:limbNodeArm2];
    
    [[frameData2 getRootNode] addChild:limbNodeArm1];
    [[frameData2 getRootNode] addChild:limbNodeArm2];
    
    [[frameData3 getRootNode] addChild:limbNodeArm1];
    [[frameData3 getRootNode] addChild:limbNodeArm2];
    
    [originalVideoModel addFrame:frameData1];
    [originalVideoModel addFrame:frameData2];
    [originalVideoModel addFrame:frameData3];
    
    [originalVideoModel saveFrames];

    AnnotatedVideoModel* loadedVideoModel = [[AnnotatedVideoModel alloc] initWithVideoName:[[NSMutableString alloc] initWithString:@"testVid"]];
    [loadedVideoModel loadFrames];
    
    XCTAssertTrue([self compareVideoModels: originalVideoModel: loadedVideoModel], @"Model changed during save and load!!");
    
    
}

-(bool) compareVideoModels:(AnnotatedVideoModel*)a : (AnnotatedVideoModel* )b {
    if ([[a getFrames] count] != [[b getFrames] count]) {
        return false;
    }
    
    
    for (NSString* frameKey in [a getAllFrames]) {
        AnnotatedFrameData* frameDataA = [[a getAllFrames] objectForKey:frameKey];
        AnnotatedFrameData* frameDataB = [[b getAllFrames] objectForKey:frameKey];
        
        if (frameDataA.frameTimeStamp != frameDataB.frameTimeStamp) {
            return false;
        }
        if (![self compareNodes:[frameDataA getRootNode] :[frameDataB getRootNode]]) {
            return false;
        }
    }
    return true;
}

-(bool) compareNodes:(ContentNode*) a:(ContentNode*) b{
    for (NSString* attributeKey in [a getAttributes]) {
        if ([b getAttribute:attributeKey] == nil) {
            return false;
        }
        
        if (![self compareAttribute:[a getAttribute:attributeKey] :[b getAttribute:attributeKey]]) {
            return false;
        }
        
    }
    
    if ([[a getChildren] count] != [[b getChildren] count]) {
        return false;
    }
    
    bool retVal = true;
    for (int i = 0; i < [[a getChildren] count]; i++) {
        ContentNode* childA = [a getChildren][i];
        ContentNode* childB = [b getChildren][i];
        
        retVal = [self compareNodes: childA : childB];
    }
    
    return retVal;
}

-(bool) compareAttribute:(NSObject*)a: (NSObject*) b{
    if (![a isKindOfClass:[b class]]) {
        return false;
    }
    
    if ([a isKindOfClass:[NSString class]]) {
        NSString* stringA = (NSString*) a;
        NSString* stringB = (NSString*) b;
        
        if (![stringA isEqualToString:stringB]) {
            return false;
        }
    }
    
    else if ([a isKindOfClass:[NSValue class]]) {
        CGPoint pointA = [(NSValue*) a CGPointValue];
        CGPoint pointB = [(NSValue*) b CGPointValue];
        
        if (pointA.x != pointB.x || pointA.y != pointB.y) {
            return false;
        }
    }
    
    return true;
}

@end
