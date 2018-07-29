//
//  NSObject+Json_LYURI.m
//  LYRouter
//
//  Created by Liya on 2016/2/24.
//  Copyright © 2016年 Liya. All rights reserved.
//

#import "NSObject+Json_LYURI.h"

@implementation NSObject (Json_LYURI)
- (NSString*)ly_jsonString {
    if ([self isKindOfClass:[NSString class]]) {
        return (NSString *)self.copy;
    }
    NSError* error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil) {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    return nil;
}

- (NSData*)ly_jsonData {
    NSError* error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if ([jsonData length] > 0 && error == nil) {
        return jsonData;
    }
    return nil;
}
@end
