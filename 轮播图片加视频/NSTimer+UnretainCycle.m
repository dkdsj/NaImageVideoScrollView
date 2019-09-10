//
//  NSTimer+UnretainCycle.m
//  CycleLabel
//
//  Created by ZZ on 2019/8/21.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import "NSTimer+UnretainCycle.h"

@implementation NSTimer (UnretainCycle)

+ (NSTimer *)ucSchedulTimerWithTimeInterval:(NSTimeInterval)ti
                                    repeats:(BOOL)yesOrNo
                                      block:(void (^)(NSTimer *timer))block {
    return [NSTimer scheduledTimerWithTimeInterval:ti
                                            target:self
                                          selector:@selector(blockInvoke:)
                                          userInfo:[block copy]
                                           repeats:yesOrNo];
}

+ (void)blockInvoke:(NSTimer *)timer {
    void (^block)(NSTimer *timer) = timer.userInfo;
    
    if (block) {
        block(timer);
    }
}

@end
