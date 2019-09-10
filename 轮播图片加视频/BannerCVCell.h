//
//  BannerCVCell.h
//  轮播图片加视频
//
//  Created by ZZ on 2019/9/6.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN

@interface BannerCVCell : UICollectionViewCell
- (void)bannerCVCellWithType:(NSString *)type imageURL:(NSString *)imageURL videoURL:(NSString *)videoURL;

@end

NS_ASSUME_NONNULL_END
