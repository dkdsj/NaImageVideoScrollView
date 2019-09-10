//
//  DemoViewController.m
//  轮播图片加视频
//
//  Created by ZZ on 2019/9/6.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import "DemoViewController.h"
#import "BannerModel.h"

@interface DemoViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *svVideo;
@property (nonatomic, strong) NSMutableArray *brands;

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initData];
    [self initView];
}

- (void)initData {
    _brands = [NSMutableArray array];
    for (int i = 1; i < 3; i++) {
        BannerModel *model = [BannerModel modeWithType:@"1" url:[NSString stringWithFormat:@"IU-%d.png", i]];
        [_brands addObject:model];
    }
    for (int i = 1; i < 4; i++) {
        BannerModel *model = [BannerModel modeWithType:@"0" url:[[NSBundle mainBundle] pathForResource:@"movie" ofType:@"mp4"]];
        [_brands addObject:model];
    }
    for (int i = 1; i < 5; i++) {
        BannerModel *model = [BannerModel modeWithType:@"1" url:[NSString stringWithFormat:@"IU-%d.png", i*2]];
        [_brands addObject:model];
    }
}
- (void)initView {
    
    _svVideo = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, 200)];
    _svVideo.pagingEnabled = YES;
    _svVideo.delegate = self;
    _svVideo.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:.3];
    _svVideo.contentSize = CGSizeMake(kScreenWidth*(_brands.count), 200);
    [self.view addSubview:_svVideo];
    
    for (int i = 0; i < _brands.count; i++) {
        BannerModel *model = _brands[i];
        CGRect frame = CGRectMake(i*kScreenWidth, 0, kScreenWidth, 200);
        
        //image
        if (model.type.integerValue == 1) {
            UIImageView *iv = [[UIImageView alloc] initWithFrame:frame];
            iv.image = [UIImage imageNamed:model.url];
            [_svVideo addSubview:iv];
        }
        //video
        else {
            NKAVPlayerView *playerView = [[NKAVPlayerView alloc] init];
            playerView.frame = frame;
            [_svVideo addSubview:playerView];
            
            [playerView settingPlayerItemWithUrl:[NSURL fileURLWithPath:model.url]];
        }
    }
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat offsetX = scrollView.contentOffset.x;
//
//    NSInteger page = offsetX/kScreenWidth;
//    NSLog(@"offsetx:%f page:%zd", offsetX, page);
//
//    BannerModel *model = _brands[page];
//
//    //video
//    if (model.type.intValue != 1) {
//
//    }
//}


// 1/3
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"%s %d", __func__, decelerate);
}
// 2/3
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    NSLog(@"%s", __func__);
}
// 3/3
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"%s", __func__);

    
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger page = offsetX/kScreenWidth;
//    NSLog(@"offsetx:%f page:%zd", offsetX, page);
    

    //遍历model 将videozan暂停
    for (int i = 0; i < _svVideo.subviews.count; i++) {
        BannerModel *model = _brands[i%_brands.count];
        UIView *v = _svVideo.subviews[i];
        NSLog(@"v[%d]:%@ page:%zd model.type:%@", i, [v class], page, model.type);
        
        if ([v isKindOfClass:[NKAVPlayerView class]] && (model.type.intValue!=1)) {
            NKAVPlayerView *av = (NKAVPlayerView *)v;
            NSLog(@"i:%d page:%zd pause", i, page);
            
            if (i != page) {
                [av.controlView.pauseButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
}


@end
