//
//  bioMarker_Unit_Tests.m
//  bioMarker Unit Tests
//
//  Created by Dylan T Mcguire on 3/4/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GestureController.h"

@interface TestGesture : XCTestCase

@end

@implementation TestGesture

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
    GestureController* gestureController = [[GestureController alloc] init];
    XCTAssertTrue(gestureController != nil, @"Gesture controller could not be initialized");
}

@end
