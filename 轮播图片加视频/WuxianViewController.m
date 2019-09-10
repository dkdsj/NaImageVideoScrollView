//
//  WuxianViewController.m
//  轮播图片加视频
//
//  Created by ZZ on 2019/9/10.
//  Copyright © 2019 ZZ. All rights reserved.
//  https://blog.csdn.net/always_on_the_way/article/details/24385699

#import "WuxianViewController.h"
#import "NaImageVideoScrollView.h"

#define imageWidth     300
#define imageHeight    250
@interface WuxianViewController ()<UIScrollViewDelegate>
{
    NSArray * _sourceArray;
    UIScrollView * _scrollView;
    UIPageControl * _pageControl;
    NaImageVideoScrollView *vWuxian;
}
@end

@implementation WuxianViewController

-(void)loadView{
    [super loadView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _sourceArray = [NSArray arrayWithObjects:@"IU-1.png",@"IU-2.png",@"IU-3.png",@"IU-4.png",nil];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 20, imageWidth, imageHeight)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor lightGrayColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(imageWidth*([_sourceArray count]+2), imageHeight);
    [self.view addSubview:_scrollView];
    
    //视图的循环现实一般采用的是412341的方法
    UIImageView *firstImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageWidth, imageHeight)];
    firstImage.image = [UIImage imageNamed:[_sourceArray lastObject]];
    firstImage.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:firstImage];
    
    for (int i = 1; i <= [_sourceArray count]; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*imageWidth, 0, imageWidth, imageHeight)];
        imageView.image = [UIImage imageNamed:[_sourceArray objectAtIndex:i - 1]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_scrollView addSubview:imageView];
    }
    
    UIImageView *lastImage = [[UIImageView alloc] initWithFrame:CGRectMake(([_sourceArray count]+1)*imageWidth, 0, imageWidth, imageHeight)];
    lastImage.contentMode = UIViewContentModeScaleAspectFit;
    lastImage.image = [UIImage imageNamed:[_sourceArray objectAtIndex:0]];
    [_scrollView addSubview:lastImage];
    [_scrollView scrollRectToVisible:CGRectMake(imageWidth, 0, imageWidth, imageHeight) animated:NO];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _scrollView.frame.origin.y + _scrollView.frame.size.height - 20, imageWidth, 20)];
    _pageControl.numberOfPages = _sourceArray.count;
    _pageControl.currentPage = 0;
    _pageControl.enabled = YES;
    [self.view addSubview:_pageControl];
    
    
    vWuxian = [[NaImageVideoScrollView alloc] initWithFrame:CGRectMake(0, 300, kScreenWidth, 200)];
//    vWuxian.;
    [self.view addSubview:vWuxian];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    vWuxian.sources = @[@"IU-9.png",@"IU-8.png",@"IU-7.png",@"IU-6.png", @"IU-1.png",@"IU-2.png",@"IU-3.png",@"IU-4.png"];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"%s", __func__);

    int currentPage = scrollView.contentOffset.x/imageWidth;
    
    if (currentPage == [_sourceArray count]+1) {
        [_scrollView scrollRectToVisible:CGRectMake(imageWidth, 0, imageWidth, imageHeight) animated:NO];
        _pageControl.currentPage = 0;
    } else if (currentPage == 0) {
        [_scrollView scrollRectToVisible:CGRectMake(imageWidth*([_sourceArray count]), 0, imageWidth, imageHeight) animated:NO];
        _pageControl.currentPage = _sourceArray.count - 1;
    } else {
        _pageControl.currentPage = currentPage - 1;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"%s", __func__);
}

// 1/3
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"%s %d", __func__, decelerate);
}
// 2/3
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    NSLog(@"%s", __func__);
}
//// 3/3
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    NSLog(@"%s", __func__);
//}

@end


