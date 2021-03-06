//
//  LYRouter.h
//  LYRouter
//
//  Created by Liya on 2016/2/23.
//  Copyright © 2016年 Liya. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LYURIRequest, LYURI;

@interface LYRouter : NSObject


+ (instancetype)shareManager;

/**
 设置默认协议-LYURI中的设置方法，并将协议添加进合法协议组

 @param scheme 默认协议
 */
+ (void)setDefaultScheme:(NSString *)scheme;
/**
 添加合法的协议

 @param objects 协议数组
 */
- (void)addSchemes:(NSArray <NSString *>*)objects;
- (BOOL)containScheme:(NSString *)scheme;
- (BOOL)containActionBlockForPath:(NSString *)path_;


/**
向路由中心注册跳转等事件

 @param path 路径
 @param proirit 优先级，默认50，越高越早执行，拦截低优先级
 @param actionBlock 跳转等事件执行代码（在这里通过设置action的hijacking属性为NO为不拦截更低优先级的执行）
 */
- (void)addToPath:(NSString *)path proirit:(NSInteger)proirit withRegisterActionBlock:(void (^)(LYURIRequest *action))actionBlock;
- (void)addToPath:(NSString *)path withRegisterActionBlock:(void (^)(LYURIRequest *action))actionBlock;


/**
 请求URI

 @param action 执行后的Action操作，携带dataCallback作为内容回调
 @param completed uri执行成功后的操作
 @return 是否已执行
 */
- (BOOL)runWithURIRequest:(LYURIRequest *)action completed:(void(^)(LYURIRequest *))completed;
- (BOOL)runWithURIRequest:(LYURIRequest *)action;

- (BOOL)runWithURI:(LYURI *)uri completed:(void(^)(LYURIRequest *))completed;
- (BOOL)runWithURI:(LYURI *)uri;

- (BOOL)runWithURIString:(NSString *)uri completed:(void(^)(LYURIRequest *))completed;
- (BOOL)runWithURIString:(NSString *)uri;

- (BOOL)runWithPath:(NSString *)path query:(NSDictionary *)query completed:(void(^)(LYURIRequest *))completed;
- (BOOL)runWithPath:(NSString *)path completed:(void(^)(LYURIRequest *))completed;
- (BOOL)runWithPath:(NSString *)path;

@end
