# LYRouter
模块化开发通信中间层封装

* 引入：
pod 'LYRouter'

* 使用
设置默认协议、合法域名

```
  [LYRouter setDefaultScheme:@"liya"];
  [[LYRouter shareManager] addSchemes:@[@"edward"]];
```

注册协议

```
[[LYRouter shareManager] addToPath:@"keaiduo/nslog" withRegisterActionBlock:^(LYURIRequest *action) {
        NSString *warning = action.uri.query[@"warning"];
        NSLog(@"LYTestObject warning = %@", warning);
    }];
[[LYRouter shareManager] addToPath:@"keaiduo/multiplication" withRegisterActionBlock:^(LYURIRequest *action) {
        NSInteger multiplier = [action.uri.query[@"multiplier"] integerValue];
        NSInteger multiplicand = [action.uri.query[@"multiplicand"] integerValue];
        NSInteger product = multiplier * multiplicand;
        //数据回传
        [action callbackWithObject:@(product)];
    }];
```

协议调用

```
[[LYRouter shareManager] runActionWithPath:@"keaiduo/nslog"
                                         query:@{@"warning":@"可爱多 🐶"}
                                     completed:nil];

LYURIRequest *uriRequest = [LYURIRequest requestWithURI:[LYURI URIWithPath:@"keaiduo/multiplication"
                                                                         query:@{@"multiplier":@5, @"multiplicand":@6}]
                                               dataCallback:^id(id result, NSError *error) {
                                                   NSLog(@"LYTestObject test product = %@", result);
                                                   return nil;
                                                                                                 }];
[[LYRouter shareManager] runingActionWithURIRequest:uriRequest];
```



