//
//  NSString+Base64_LYURI.h
//  LYRouter
//
//  Created by Liya on 2016/2/24.
//  Copyright © 2016年 Liya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Base64_LYURI)
//base64编码
- (NSString *)ly_base64EncodeString;
- (NSString *)ly_base64DecodeString;

//URL编码
- (NSString *)ly_URLEncodeString;
- (NSString *)ly_URLDecodeString;

//base64在url中做参数时的安全处理
- (NSString *)ly_base64EncodedSafeURLString;
- (NSString *)ly_base64DecodedSafeURLString;

- (NSDictionary *)ly_jsonToDictionary;
@end
