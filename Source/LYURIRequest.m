//
//  LYURIRequest.m
//  LYRouter
//
//  Created by Liya on 2016/2/23.
//  Copyright © 2016年 Liya. All rights reserved.
//

#import "LYURIRequest.h"

@interface LYURIRequest()

/**
 block 回调，由调用方负责实现
 */
@property (nonatomic, copy) id(^dataCallback)(id result, NSError *error);
@property (nonatomic, strong) LYURI *uri;
@end

@implementation LYURIRequest

+ (instancetype)requestWithURI:(LYURI *)uri dataCallback:(id (^)(id, NSError *))callback {
    LYURIRequest *action = [[LYURIRequest alloc] init];
    action.uri = uri;
    action.dataCallback = callback;
    return action;
}

+ (instancetype)requestWithURI:(LYURI *)uri {
    return [self requestWithURI:uri dataCallback:nil];
}

- (id)callbackWithObject:(id)result {
    return [self callbackWithObject:result error:nil];
}

- (id)callbackWithObject:(id)result error:(NSError *)error {
    if (self.dataCallback) {
       return self.dataCallback(result, error);
    }
    return nil;
}

@end
