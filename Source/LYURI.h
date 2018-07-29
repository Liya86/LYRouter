//
//  LYURI.h
//  LYRouter
//  URL基本情况：scheme://user:password@host:port/path/query#fragment
//  iOS APP 通过 URL Scheme 跳转，scheme://host/path/query
//  通常情况下一个 APP host为空，通过path即可模块跳转，所以scheme:///path?query=base64Str
//  解析得到base64Str为jsonString，{A:xx, B:[xx1, xx2]}
//  Created by Liya on 2016/2/23.
//  Copyright © 2016年 Liya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYURI : NSObject
@property (nonatomic, readonly) NSString *uriString;
@property (nonatomic, readonly) NSString *scheme;
@property (nonatomic, readonly) NSString *path;
@property (nonatomic, readonly) NSDictionary *query;

/**
 URI初始化，资源标识符

 @param uriString uri字符串，需要解析
 @return LYURI
 */
+ (instancetype)URIWithUriString:(NSString *)uriString;

/**
 URI初始化，资源标识符

 @param scheme 协议名称
 @param path 路径
 @param query 参数
 @return LYURI
 */
+ (instancetype)URIWithScheme:(NSString *)scheme path:(NSString *)path query:(NSDictionary *)query;
+ (instancetype)URIWithPath:(NSString *)path query:(NSDictionary *)query;
+ (instancetype)URIWithPath:(NSString *)path;

/**
 默认协议设置/获取

 @return 默认的协议 @""，可更改
 */
+ (NSString *)LYDefaultScheme;
+ (void)setLYDefaultScheme:(NSString *)scheme;

- (void)appendQuery:(NSDictionary *)query;
- (void)removeQuery:(NSArray *)keys;
@end

