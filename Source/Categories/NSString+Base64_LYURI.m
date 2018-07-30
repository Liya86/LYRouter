//
//  NSString+Base64_LYURI.m
//  LYRouter
//
//  Created by Liya on 2016/2/24.
//  Copyright © 2016年 Liya. All rights reserved.
//

#import "NSString+Base64_LYURI.h"

@implementation NSString (Base64_LYURI)
- (NSString *)ly_base64EncodeString {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)ly_base64DecodeString {
    /*
     为什么这一步，主要是根据原理，base64的内容组成是：
     10个数字，26个大写字母，26个小写字母，1个+，1个/
     然后又是通过3个8位字节转为4个6位字节即 3 * 8 = 4 * 6
     如果刚好 n % 3 == 0那就刚好了，如果 n % 3 == 1 或者 2 ：
     n % 3 == 1, 则 xxxxxxxx -> xxxxxx xx0000 ~~~~~~ ~~~~~~, 对应字符应该是 b b = =
     n % 3 == 2, 则 xxxxxxxx xxxxxxxx -> xxxxxx xxxxxx xxxx00 ~~~~~~ , 对应字符应该是 b b b =
     反过来，如果base64的字符长度 % 4，表示这个base64不标准，可以用'='补充上去
     */
    NSInteger dValue = self.length%4;
    NSString *base64Str = self;
    if (dValue) {
        base64Str = [base64Str stringByAppendingString:[@"====" substringFromIndex:dValue]];
    }
    
    NSData *data = [[NSData alloc]initWithBase64EncodedString:base64Str options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

//URL编码
- (NSString *)ly_URLEncodeString {
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSString *)ly_URLDecodeString {
    return [self stringByRemovingPercentEncoding];
}

/*
 Url中只允许包含英文字母（a-zA-Z）、数字（0-9）、-_.~4个特殊字符以及所有保留字符:! * ' ( ) ; : @ & = + $ , / ? # [ ]
 保留字符中（:/?#[]@）用来分隔不同组件的，而（!$&'()*+,;=）用于在组件中起分隔作用，当组件中的普通数据包含这些特殊字符时，需要对其进行编码。
 而Base64是26个字母，10个数字，还有+,/,=这三个在url中均为保留字符，需替换掉，可以用-,_,.,~替换，然后因为=可以后续补充，所以+,/用-,_替换
 */
- (NSString *)ly_base64EncodedSafeURLString {
    NSString *encodeStr = [self ly_base64EncodeString];
    encodeStr = [encodeStr stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    encodeStr = [encodeStr stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    encodeStr = [encodeStr stringByReplacingOccurrencesOfString:@"=" withString:@""];
    return encodeStr;
}

- (NSString *)ly_base64DecodedSafeURLString {
    NSString *decodeStr = self;
    decodeStr = [decodeStr stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
    decodeStr = [decodeStr stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
    return [decodeStr ly_base64DecodeString];
}


- (NSDictionary *)ly_jsonToDictionary {
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
    if(error) {
#ifdef DEBUG
        NSAssert(NO, @"jsonString To Dictionary have error!");
#endif
        return nil;
    }
    
    return dic;
    
}
@end
