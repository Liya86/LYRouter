//
//  LYTestObject.m
//  LYRouter
//
//  Created by Liya on 2018/7/29.
//  Copyright © 2018年 Liya. All rights reserved.
//

#import "LYTestObject.h"
#import "LYRouter.h"
@implementation LYTestObject

+ (void)load {
    [LYURI setLYDefaultScheme:@"liya"];
    [[LYRouter shareManager] addSchemes:@[@"liya"]];
    
    [[LYRouter shareManager] addToPath:@"keaiduo/set" withRegisterActionBlock:^(LYURIRequest *action) {
        int a = 2;
        [action callbackWithObject:@(a)];
        NSLog(@"LYTestObject a = %d", a);
    }];
    [[LYRouter shareManager] addToPath:@"keaiduo/nslog" withRegisterActionBlock:^(LYURIRequest *action) {
        NSString *warning = action.uri.query[@"warning"];
        NSLog(@"LYTestObject warning = %@", warning);
    }];
    [[LYRouter shareManager] addToPath:@"keaiduo/multiplication" withRegisterActionBlock:^(LYURIRequest *action) {
        NSInteger multiplier = [action.uri.query[@"multiplier"] integerValue];
        NSInteger multiplicand = [action.uri.query[@"multiplicand"] integerValue];
        NSInteger product = multiplier * multiplicand;
        NSLog(@"LYTestObject product = %ld", product);
        [action callbackWithObject:@(product)];
    }];
}

@end
