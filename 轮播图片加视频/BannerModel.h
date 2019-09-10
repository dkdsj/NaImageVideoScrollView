//
//  BannerModel.h
//  轮播图片加视频
//
//  Created by ZZ on 2019/9/6.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BannerModel : NSObject

/**
 *  1图片 0视频
 */
@property (nonatomic , copy) NSString *type;
/**
 *  视频地址
 */
@property (nonatomic , copy) NSString *url;

+ (instancetype)modeWithType:(NSString *)type url:(NSString *)url;


@end

NS_ASSUME_NONNULL_END
