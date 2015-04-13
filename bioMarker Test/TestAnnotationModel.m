//
//  TestAnnotationModel.m
//  bioMarker Test
//
//  Created by Dylan T Mcguire on 3/4/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AnnotationModelUtil.h"

@interface TestAnnotationModel : XCTestCase

@end

@implementation TestAnnotationModel

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
    AnnotatedFrameData* frameData = [[AnnotatedFrameData alloc] init];
    ContentNode* limbNode = [[ContentNode alloc] initWithType:LIMB_NODE_TYPE];
    [AnnotationModelUtil addLimbToRootNode:frameData : limbNode];
    
    XCTAssertTrue([[[frameData getRootNode] getChildren] count] == 1, @"limb node could not be added to root");
}

@end
