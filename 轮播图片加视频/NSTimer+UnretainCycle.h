//
//  NSTimer+UnretainCycle.h
//  CycleLabel
//
//  Created by ZZ on 2019/8/21.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (UnretainCycle)

/**
 __weak __typeof(self)weakSelf = self;
 _timer = [NSTimer ucSchedulTimerWithTimeInterval:3 repeats:YES block:^(NSTimer * _Nonnull timer) {
     __strong __typeof(weakSelf)strongSelf = weakSelf;
    [strongSelf showMsg];
 }];
 
 [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
 
 */
+ (NSTimer *)ucSchedulTimerWithTimeInterval:(NSTimeInterval)ti
                                    repeats:(BOOL)yesOrNo
                                      block:(void (^)(NSTimer *timer))block;
@end

NS_ASSUME_NONNULL_END
