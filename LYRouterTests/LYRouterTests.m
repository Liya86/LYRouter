//
//  LYRouterTests.m
//  LYRouterTests
//
//  Created by Liya on 2018/7/29.
//  Copyright © 2018年 Liya. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LYRouter.h"
@interface LYRouterTests : XCTestCase

@end

@implementation LYRouterTests

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
    [[LYRouter shareManager] runWithPath:@"keaiduo/set"];
    
    [[LYRouter shareManager] runWithPath:@"keaiduo/nslog"
                                         query:@{@"warning":@"可爱多 🐶"}
                                     completed:^(LYURIRequest *request) {
                                         NSLog(@"LYTestObject test warning");
                                     }];
    
    LYURIRequest *uriRequest = [LYURIRequest requestWithURI:[LYURI URIWithPath:@"keaiduo/multiplication"
                                                                         query:@{@"multiplier":@5, @"multiplicand":@6}]
                                               dataCallback:^id(id result, NSError *error) {
                                                   NSLog(@"LYTestObject test product = %@", result);
                                                   NSAssert([result integerValue] == 30, @"结果出错");
                                                   return nil;
                                               }];
    [[LYRouter shareManager] runWithURIRequest:uriRequest];
    
    [[LYRouter shareManager] runWithURIString:@"edward:///keaiduo/nslog?warning=可爱多 🐶的吗"];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
