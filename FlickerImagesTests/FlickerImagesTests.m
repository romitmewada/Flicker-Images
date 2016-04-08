//
//  FlickerImagesTests.m
//  FlickerImagesTests
//
//  Created by Romit M on 06/04/16.
//  Copyright © 2016 Romit M. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"
#import "WebService.h"

@interface FlickerImagesTests : XCTestCase

@end

@implementation FlickerImagesTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testWebservice
{
∂    //Expectation
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing Async Method Works Correctly!"];
    
    [WebService requestFlickerPhoto:^(NSArray *response) {
        
        [expectation fulfill];

    } Error:^(NSError *error) {
        
        NSLog(@"error is: %@", error);
    }];
    
    //Wait 1 second for fulfill method called, otherwise fail:
    [self waitForExpectationsWithTimeout:1 handler:^(NSError *error) {
        
        if(error)
        {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
∂    }];
}

@end
