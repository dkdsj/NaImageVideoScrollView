//
//  ProxyWeak.h
//  CycleLabel
//
//  Created by ZZ on 2019/8/21.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProxyWeak : NSObject

@property (nonatomic, weak, readonly) id weakTarget;

/**
     _timer = [NSTimer timerWithTimeInterval:3
                                     target:[ProxyWeak
                                     proxyWithTarget:self]
                                     selector:@selector(showMsg)
                                     userInfo:nil
                                     repeats:YES];
     [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
 */
+ (instancetype)proxyWithTarget:(id)target;
- (instancetype)initWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
