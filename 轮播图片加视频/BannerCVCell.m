//
//  BannerCVCell.m
//  轮播图片加视频
//
//  Created by ZZ on 2019/9/6.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import "BannerCVCell.h"

@interface BannerCVCell ()
@property (nonatomic, strong) UIImageView *ivIcon;
@property (nonatomic, strong) NKAVPlayerView *playerView;
/** 视频播放器*/


@end

@implementation BannerCVCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = kColorRandom;
        [self initView];
    }
    return self;
}

- (void)initView {
    _ivIcon = [[UIImageView alloc] init];
    _ivIcon.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_ivIcon];
    
    _playerView = [[NKAVPlayerView alloc] init];
    [self.contentView addSubview:_playerView];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _ivIcon.frame = self.contentView.frame;
    _playerView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth / 7 * 4);
}

- (void)bannerCVCellWithType:(NSString *)type imageURL:(NSString *)imageURL videoURL:(NSString *)videoURL {
    
    //video
    if (type.intValue==1) {
        NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"movie" ofType:@"mp4"];
        [_playerView settingPlayerItemWithUrl:[NSURL fileURLWithPath:moviePath]];
    } else {
        _ivIcon.image = [UIImage imageNamed:imageURL];
    }
 
    _ivIcon.hidden = (type.integerValue==1);
    _playerView.hidden = (type.integerValue==0);
}


@end
