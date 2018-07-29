//
//  LYRouter.m
//  LYRouter
//
//  Created by Liya on 2016/2/23.
//  Copyright © 2016年 Liya. All rights reserved.
//

#import "LYRouter_.h"
#import "LYURIRegisterAction.h"
#import "LYURIRequest.h"
#import "LYURI.h"
#import <UIKit/UIApplication.h>

@interface LYRouter()
@property (nonatomic, strong) NSArray<NSString *> *schemes; //符合的协议
@property (nonatomic, strong) NSMutableDictionary <NSString*, LYURIRegisterActionStore*> *actionStoreCache;//缓存
@property (nonatomic, strong) NSMutableArray <LYURIRegisterActionStore *>*actionStores;
@property (nonatomic, strong) NSRecursiveLock *recursiveLock;//递归🔒，谨防被死锁
@end

@implementation LYRouter

+ (instancetype)shareManager {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _recursiveLock = [[NSRecursiveLock alloc] init];
        _actionStores = [NSMutableArray array];
        _actionStoreCache = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - match
- (void)addSchemes:(NSArray <NSString *>*)objects {
    if (!objects.count) {
        return;
    }
    [self.recursiveLock lock];
    NSMutableArray *schemes = [NSMutableArray arrayWithArray:self.schemes];
    [schemes addObjectsFromArray:objects];
    self.schemes = schemes.copy;
    [self.recursiveLock unlock];
}

- (BOOL)containScheme:(NSString *)scheme {
    if ([self.schemes containsObject:scheme]) {
        return YES;
    }
    return NO;
}

- (BOOL)containActionBlockForPath:(NSString *)path_ {
    return ([self markURIRegisterActionStoreForPath:path_] != nil);
}

- (LYURIRegisterActionStore *)markURIRegisterActionStoreForPath:(NSString *)path_ {
    NSString *path = path_.lowercaseString;
    [self.recursiveLock lock];
    ///先搜索缓存
    __block LYURIRegisterActionStore *actionStore = self.actionStoreCache[path];
    if (!actionStore) {
        __weak typeof(self) wSelf = self;
        [self.actionStores enumerateObjectsUsingBlock:^(LYURIRegisterActionStore * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __weak typeof(wSelf) sSelf = wSelf;
            if ([path isEqualToString:obj.path]) {
                sSelf.actionStoreCache[path] = obj;
                actionStore = obj;
                *stop = YES;
            }
        }];
    }
    [self.recursiveLock unlock];
    return actionStore;
}

#pragma mark - uri's register
- (void)addToPath:(NSString *)path proirit:(NSInteger)proirit withRegisterActionBlock:(void (^)(LYURIRequest *action))actionBlock {
    if (!actionBlock || !path) {
        NSAssert(NO, @"URI block or path params is nil!");
        return;
    }
    
    [self.recursiveLock lock];
    
    LYURIRegisterAction *registerAction = [LYURIRegisterAction URIRegisterActionWith:proirit actionBlock:actionBlock];
    const NSUInteger index = [self.actionStores indexOfObjectPassingTest:^BOOL(LYURIRegisterActionStore * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.path isEqualToString:path]) {
            [obj addRegisterAction:registerAction];
            return YES;
        }
        return NO;
    }];
    
    if (index == NSNotFound) {
        LYURIRegisterActionStore *actrionStore = [LYURIRegisterActionStore URIRegisterActionStoreWith:path];
        [actrionStore addRegisterAction:registerAction];
        [self.actionStores addObject:actrionStore];
    }
    
    [self.recursiveLock unlock];
}

- (void)addToPath:(NSString *)path withRegisterActionBlock:(void (^)(LYURIRequest *action))actionBlock {
    [self addToPath:path proirit:50 withRegisterActionBlock:actionBlock];
}

#pragma mark - uri's run
- (BOOL)runingActionWithURIRequest:(LYURIRequest *)action completed:(void(^)(LYURIRequest *))completed {
    LYURI *uri = action.uri;
    if (!uri.path.length) {
        if (completed) {
            completed(action);
        }
        return NO;
    }
    if (![self containScheme:uri.scheme]) {
        //非内部协议，打开外部，并将打开结果通知
        BOOL opened = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:uri.uriString]];
        [action callbackWithObject:@(opened)];
        if (completed) {
            completed(action);
        }
        return NO;
    }
    LYURIRegisterActionStore *actionStore = [self markURIRegisterActionStoreForPath:uri.path];
    [actionStore.actions enumerateObjectsUsingBlock:^(LYURIRegisterAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        action.hijacking = YES;
        if (obj.actionBlock) {
            obj.actionBlock(action);
        }
        if (action.hijacking) {
            action.hasRuned = YES;
        }
        *stop = action.hijacking;
    }];
    if (completed) {
        completed(action);
    }
    return action.hasRuned;
}

- (BOOL)runingActionWithURIRequest:(LYURIRequest *)action {
    return [self runingActionWithURIRequest:action completed:nil];
}

- (BOOL)runActionWithURI:(LYURI *)uri completed:(void(^)(LYURIRequest *))completed {
    return [self runingActionWithURIRequest:[LYURIRequest requestWithURI:uri] completed:completed];
}

- (BOOL)runActionWithURI:(LYURI *)uri {
    return [self runActionWithURI:uri completed:nil];
}

- (BOOL)runActionWithURIString:(NSString *)uri completed:(void(^)(LYURIRequest *))completed {
    return [self runActionWithURI:[LYURI URIWithUriString:uri] completed:completed];
}

- (BOOL)runActionWithURIString:(NSString *)uri {
    return [self runActionWithURI:[LYURI URIWithUriString:uri]];
}

- (BOOL)runActionWithPath:(NSString *)path query:(NSDictionary *)query completed:(void(^)(LYURIRequest *))completed {
    return [self runActionWithURI:[LYURI URIWithPath:path query:query] completed:completed];
}

- (BOOL)runActionWithPath:(NSString *)path completed:(void(^)(LYURIRequest *))completed {
    return [self runActionWithURI:[LYURI URIWithPath:path query:nil] completed:completed];
}

- (BOOL)runActionWithPath:(NSString *)path {
    return [self runActionWithURI:[LYURI URIWithPath:path query:nil] completed:nil];
}

@end
