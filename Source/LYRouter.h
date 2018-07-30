//
//  LYRouter.h
//  LYRouter
//
//  使用：
//  1. 先初始化默认协议
//  [LYRouter setDefaultScheme:@"liya"];
//  2. 添加额外其他合法协议--可跳转的
//  [[LYRouter shareManager] addSchemes:@[@"edward"]];
//  3. 注册协议操作 -- 多种方法，具体查看 LYRouter_.h
//  [[LYRouter shareManager] addToPath:@"keaiduo/multiplication" withRegisterActionBlock:^(LYURIRequest *action) {
//      NSInteger multiplier = [action.uri.query[@"multiplier"] integerValue]; //获取调用的参数等
//      NSInteger multiplicand = [action.uri.query[@"multiplicand"] integerValue];
//      NSInteger product = multiplier * multiplicand;
//      [action callbackWithObject:@(product)]; //将结果回调--数据回调
//  }];
//  4. 执行 -- 多种方法，具体查看 LYRouter_.h
//  LYURIRequest *uriRequest = [LYURIRequest requestWithURI:[LYURI URIWithPath:@"keaiduo/multiplication"
//      query:@{@"multiplier":@5, @"multiplicand":@6}]
//      dataCallback:^id(id result, NSError *error) {
//          NSLog(@"LYTestObject test product = %@", result); //result即上面数据回传内容
//          return nil;
//      }];
//  [[LYRouter shareManager] runingActionWithURIRequest:uriRequest];
//
//  Created by Liya on 2016/2/26.
//  Copyright © 2016年 Liya. All rights reserved.
//

#ifndef LYRouter_h
#define LYRouter_h

#import "LYURIRequest.h"
#import "LYURI.h"
#import "LYRouter_.h"

#endif /* LYRouter_h */
