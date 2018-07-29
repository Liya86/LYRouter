//
//  LYURISpirit.m
//  LYRouter
//
//  Created by Liya on 2016/2/23.
//  Copyright © 2016年 Liya. All rights reserved.
//

#import "LYURI.h"
#import "NSString+Base64_LYURI.h"
#import "NSObject+Json_LYURI.h"

static NSString *LYDefaultScheme = @"";

@interface LYURI()
@property (nonatomic, copy) NSString *uriString;
@property (nonatomic, copy) NSString *scheme;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, strong) NSDictionary *query;
@property (nonatomic, strong) NSDictionary *queryParam;
@end

@implementation LYURI

#pragma mark - 默认协议名称
+ (NSString *)LYDefaultScheme {
    return LYDefaultScheme;
}

+ (void)setLYDefaultScheme:(NSString *)scheme {
    LYDefaultScheme = scheme ?: @"";
}

#pragma mark - initialize
+ (instancetype)URIWithUriString:(NSString *)uriString {
    LYURI *uri = [[LYURI alloc] init];
    uri.uriString = uriString;
    [uri parseUriString];
    return uri;
}

+ (instancetype)URIWithPath:(NSString *)path {
    return [self URIWithPath:path query:nil];
}

+ (instancetype)URIWithPath:(NSString *)path query:(NSDictionary *)query {
    return [self URIWithScheme:LYDefaultScheme path:path query:query];
}

+ (instancetype)URIWithScheme:(NSString *)scheme path:(NSString *)path query:(NSDictionary *)query {
    LYURI *uri = [[LYURI alloc] init];
    uri.scheme = scheme ?: @"";
    uri.path = path ?: @"";
    uri.queryParam = query;
    uri.query = query;
    [uri jointUriString];
    return uri;
}

#pragma mark - parse
- (void)parseUriString {
    if ([self.uriString isKindOfClass:[NSString class]] && self.uriString.length) {
        NSURL *url = [NSURL URLWithString:self.uriString];
        if (url == nil) {
            url = [NSURL URLWithString:[self.uriString ly_URLEncodeString]];
        }
        self.scheme = url.scheme;
        self.path = url.path;
        if ([self.path hasPrefix:@"/"]) {
            self.path = [self.path substringFromIndex:1];
        }
        [self parseQuery:url.query];
    }
}

- (void)parseQuery:(NSString *)query {
    NSMutableDictionary *queryDic = [NSMutableDictionary dictionary];
    if (query) {
        NSArray *queries = [query componentsSeparatedByString:@"&"];
        for (NSString *queryEleStr in queries) {
            NSArray *queryEles = [queryEleStr componentsSeparatedByString:@"="];
            NSString *key = queryEles.firstObject;
            NSString *value = queryEles.count > 1 ? queryEles[1] : nil;
            if (key && value) {
                if ([@"query" isEqualToString:key]) {
                    NSString *jsonStr = [[value ly_base64DecodedSafeURLString] ly_base64DecodeString];
                    self.queryParam = [jsonStr ly_jsonToDictionary];
                } else {
                    queryDic[key] = [value ly_URLDecodeString];
                }
            }
        }
    }
    self.query = queryDic.copy;
}

- (void)jointUriString {
    NSMutableDictionary *otherQuery = [NSMutableDictionary dictionaryWithDictionary:self.query];
    [otherQuery removeObjectsForKeys:self.queryParam.allKeys];
    
    NSString *scheme = self.scheme ?: LYDefaultScheme;
    NSString *path = self.path ?: @"";
    
    __block NSString *uriString = [NSString stringWithFormat:@"%@:///%@", scheme, path];
    if (self.queryParam.count > 0) {
        uriString = [uriString stringByAppendingString:[NSString stringWithFormat:@"?query=%@&", [[self.queryParam ly_jsonString] ly_base64EncodedSafeURLString]]];
    } else if (otherQuery.count > 0) {
        uriString = [uriString stringByAppendingString:@"?"];
    }
    [otherQuery enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        uriString = [uriString stringByAppendingString:[NSString stringWithFormat:@"%@=%@&", key, [[obj ly_jsonString] ly_URLEncodeString]]];
    }];
    
    self.uriString = uriString;
}

- (void)appendQuery:(NSDictionary *)query {
    if (!query.count) {
        return;
    }
    if (self.queryParam) {
        NSMutableDictionary *newQueryParam = [NSMutableDictionary dictionaryWithDictionary:self.queryParam];
        [newQueryParam addEntriesFromDictionary:query];
        self.queryParam = newQueryParam.copy;
    }
    NSMutableDictionary *newQuery = [NSMutableDictionary dictionaryWithDictionary:self.query];
    [newQuery addEntriesFromDictionary:query];
    self.query = newQuery.copy;
    
    [self jointUriString];
}

- (void)removeQuery:(NSArray *)keys {
    if (!keys.count) {
        return;
    }
    if (self.queryParam) {
        NSMutableDictionary *newQueryParam = [NSMutableDictionary dictionaryWithDictionary:self.queryParam];
        [newQueryParam removeObjectsForKeys:keys];
        self.queryParam = newQueryParam.copy;
    }
    NSMutableDictionary *newQuery = [NSMutableDictionary dictionaryWithDictionary:self.query];
    [newQuery removeObjectsForKeys:keys];
    self.query = newQuery.copy;
    [self jointUriString];
}

@end
