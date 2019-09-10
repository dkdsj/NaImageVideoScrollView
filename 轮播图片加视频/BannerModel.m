//
//  BannerModel.m
//  轮播图片加视频
//
//  Created by ZZ on 2019/9/6.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import "BannerModel.h"

@implementation BannerModel

+ (instancetype)modeWithType:(NSString *)type url:(NSString *)url {
    BannerModel *model = [BannerModel new];
    model.type = type;
    model.url = url;
    
    return model;
}

@end
