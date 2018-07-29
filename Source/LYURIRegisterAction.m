//
//  LYURIRegisterAction.m
//  LYRouter
//
//  Created by Liya on 2016/2/24.
//  Copyright © 2016年 Liya. All rights reserved.
//

#import "LYURIRegisterAction.h"

@interface LYURIRegisterAction()
@property (nonatomic, assign) NSInteger priority;
@property (nonatomic, copy) void (^actionBlock)(LYURIRequest *);
@end

@implementation LYURIRegisterAction
+ (instancetype)URIRegisterActionWith:(NSInteger)proirit actionBlock:(void(^)(LYURIRequest *))actionBlock {
    LYURIRegisterAction *action = [[LYURIRegisterAction alloc] init];
    action.priority = proirit;
    action.actionBlock = actionBlock;
    return action;
}
@end

@interface LYURIRegisterActionStore()
@property (nonatomic, copy) NSString *path;
@property (nonatomic, strong) NSArray <LYURIRegisterAction *>* actions;
@end

@implementation LYURIRegisterActionStore
+ (instancetype)URIRegisterActionStoreWith:(NSString *)path {
    if (path == nil) {
        return nil;
    }
    LYURIRegisterActionStore *store = [[LYURIRegisterActionStore alloc] init];
    store.path = path;
    return store;
}

- (void)addRegisterAction:(LYURIRegisterAction *)registerAction {
    if (registerAction == nil) {
        return;
    }
    NSMutableArray <LYURIRegisterAction *>*actions = [NSMutableArray arrayWithArray:self.actions];
    NSInteger index = [actions indexOfObjectPassingTest:^BOOL(LYURIRegisterAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.priority < registerAction.priority) {
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    if (index != NSNotFound) {
        [actions insertObject:registerAction atIndex:index];
    } else {
        [actions addObject:registerAction];
    }
    self.actions = actions.copy;
}
@end
