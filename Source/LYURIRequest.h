//
//  LYURIRequest.h
//  LYRouter
//  uri执行请求及数据回调
//  Created by Liya on 2016/2/23.
//  Copyright © 2016年 Liya. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LYURI;
@interface LYURIRequest : NSObject

/**
 path执行操作

 @param uri 资源标识
 @param callback 数据处理回调
 @return LYURIRequest
 */
+ (instancetype)requestWithURI:(LYURI *)uri dataCallback:(id(^)(id result, NSError *error))callback;
+ (instancetype)requestWithURI:(LYURI *)uri;


/**
 资源标识
 */
@property (nonatomic, strong, readonly) LYURI *uri;

/**
是否被劫持处理了，就是处理过后不在继续别的同path的处理
 */
@property (nonatomic, assign) BOOL hijacking;

/**
 是否已经执行过操作，只要一次即可
 */
@property (nonatomic, assign) BOOL hasRuned;


/**
 回调数据给 WebView\ReactNative 等调用方
 @param result 要回调的json体
 @param error 错误信息
 @return 数据回调结果
 */
- (id)callbackWithObject:(id)result error:(NSError *)error;
- (id)callbackWithObject:(id)result;

@end
