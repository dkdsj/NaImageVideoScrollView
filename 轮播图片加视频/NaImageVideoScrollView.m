//
//  NaImageVideoScrollView.m
//  轮播图片加视频
//
//  Created by ZZ on 2019/9/10.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import "NaImageVideoScrollView.h"
#import "ProxyWeak.h"
#import "NSTimer+UnretainCycle.h"

@interface NaImageVideoScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, assign) CGFloat imageWidth;
@property (nonatomic, assign) CGFloat imageHeight;

// 定时器
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation NaImageVideoScrollView

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
    NSLog(@"cycle label view dealloc!");
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initData];
        [self initView];
        [self addScrollSubview];
    }
    return self;
}

- (void)initData {
    _imageWidth = self.frame.size.width;
    _imageHeight = self.frame.size.height;
    
    _sources = @[@"IU-1.png",@"IU-2.png",@"IU-3.png",@"IU-4.png"];
    
#if 0
    //定时器
    __weak __typeof(self)weakSelf = self;
    _timer = [NSTimer ucSchedulTimerWithTimeInterval:4 repeats:YES block:^(NSTimer * _Nonnull timer) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf timerMethod];
    }];
    
    //or
    //_timer = [NSTimer timerWithTimeInterval:4 target:[ProxyWeak proxyWithTarget:self] selector:@selector(showMsg) userInfo:nil repeats:YES];

    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
#endif
    
}

- (void)initView {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _imageWidth, _imageHeight)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _scrollView.frame.origin.y + _scrollView.frame.size.height - 20, _imageWidth, 20)];
    _pageControl.enabled = YES;
    [self addSubview:_pageControl];
}

- (void)addScrollSubview {
    _pageControl.numberOfPages = _sources.count;
    _pageControl.currentPage = 0;
    
    _scrollView.contentSize = CGSizeMake(_imageWidth*([_sources count]+2), _imageHeight);
    
    for (UIView *vv in _scrollView.subviews) {
        [vv removeFromSuperview];
    }
    
    
    //视图的循环现实一般采用的是412341的方法
    UIImageView *firstImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _imageWidth, _imageHeight)];
    firstImage.image = [UIImage imageNamed:[_sources lastObject]];
    firstImage.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:firstImage];
    
    for (int i = 1; i <= [_sources count]; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*_imageWidth, 0, _imageWidth, _imageHeight)];
        imageView.image = [UIImage imageNamed:[_sources objectAtIndex:i - 1]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_scrollView addSubview:imageView];
    }
    
    UIImageView *lastImage = [[UIImageView alloc] initWithFrame:CGRectMake(([_sources count]+1)*_imageWidth, 0, _imageWidth, _imageHeight)];
    lastImage.image = [UIImage imageNamed:[_sources objectAtIndex:0]];
    lastImage.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:lastImage];
    [_scrollView scrollRectToVisible:CGRectMake(_imageWidth, 0, _imageWidth, _imageHeight) animated:NO];
 
}

- (void)setSources:(NSArray *)sources {
    if (_sources != sources) {
        _sources = sources;
        
        [self addScrollSubview];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //暂停定时器
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //开始定时器
    [_timer setFireDate:[NSDate distantPast]];

    [self scrollMethod];
}

//定时器执行
- (void)timerMethod {
    NSLog(@"%s", __func__);
    
    CGPoint p = _scrollView.contentOffset;
    p.x += _imageWidth;
    _scrollView.contentOffset = p;
    
    [self scrollMethod];
}

- (void)scrollMethod {
    int currentPage = _scrollView.contentOffset.x/_imageWidth;
    
    if (currentPage == [_sources count]+1) {
        [_scrollView scrollRectToVisible:CGRectMake(_imageWidth, 0, _imageWidth, _imageHeight) animated:NO];
        _pageControl.currentPage = 0;
    } else if (currentPage == 0) {
        [_scrollView scrollRectToVisible:CGRectMake(_imageWidth*([_sources count]), 0, _imageWidth, _imageHeight) animated:NO];
        _pageControl.currentPage = _sources.count - 1;
    } else {
        _pageControl.currentPage = currentPage - 1;
    }
}

@end
