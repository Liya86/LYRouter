//
//  LYURIRegisterAction.h
//  LYRouter
//  用户注册的uri对应行为
//  Created by Liya on 2016/2/24.
//  Copyright © 2016年 Liya. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LYURIRequest;

@interface LYURIRegisterAction : NSObject
@property (nonatomic, assign, readonly) NSInteger priority;
@property (nonatomic, copy, readonly) void (^actionBlock)(LYURIRequest *);

+ (instancetype)URIRegisterActionWith:(NSInteger)proirit actionBlock:(void(^)(LYURIRequest *))actionBlock;
@end

@interface LYURIRegisterActionStore : NSObject
@property (nonatomic, copy, readonly) NSString *path;
@property (nonatomic, strong, readonly) NSArray <LYURIRegisterAction *>* actions;

+ (instancetype)URIRegisterActionStoreWith:(NSString *)path;

- (void)addRegisterAction:(LYURIRegisterAction *)registerAction;
@end
