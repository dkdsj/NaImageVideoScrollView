//
//  ViewController.m
//  轮播图片加视频
//
//  Created by ZZ on 2019/9/6.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import "ViewController.h"
#import "BannerCVCell.h"
#import "DemoViewController.h"
#import "AVKitDemoViewController.h"
#import "WuxianViewController.h"

@interface ViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property(nonatomic, strong) UICollectionView *cvBrands;
@property (nonatomic, strong) NSArray *brands;
@property (nonatomic, strong) NSArray *types;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"jo";
    
    [self initData];
    [self initView];
    
    [self loadData];
    
}


- (void)initData {
}

- (void)initView {
    NKAVPlayerView *playerView = [[NKAVPlayerView alloc] init];
    playerView.frame = CGRectMake(0, 450, kScreenWidth, 200);
    [self.view addSubview:playerView];
    playerView.backgroundColor = [UIColor lightGrayColor];
    
    NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"movie" ofType:@"mp4"];
    [playerView settingPlayerItemWithUrl:[NSURL fileURLWithPath:moviePath]];
    
    
    [self.cvBrands mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(200);
    }];
}

- (void)loadData {
    NSMutableArray *imageNames = [NSMutableArray array];
    NSMutableArray *types = [NSMutableArray array];
    for (int i = 1; i < 9; i++) {
        [imageNames addObject:[NSString stringWithFormat:@"IU-%d.png", i]];
        [types addObject:@"1"];
    }
    types[0] = @"0";
    types[1] = @"0";
    _brands = imageNames;
    _types = types;
    [self.cvBrands reloadData];
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _brands.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"BannerCVCell";
    BannerCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [cell bannerCVCellWithType:_types[indexPath.item] imageURL:_brands[indexPath.item] videoURL:_brands[indexPath.item]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenWidth, 200);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = _brands[indexPath.item];
    
    DemoViewController *vc = [DemoViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    
    NSLog(@"select index %zd", indexPath.item);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    WuxianViewController *vc = [WuxianViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UICollectionView *)cvBrands {
    if (!_cvBrands) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.estimatedItemSize = CGSizeMake(kScreenWidth, 200);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _cvBrands = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _cvBrands.backgroundColor = [UIColor lightGrayColor];
        _cvBrands.delegate = self;
        _cvBrands.dataSource = self;
        _cvBrands.pagingEnabled = YES;
        
        [_cvBrands registerClass:[BannerCVCell class] forCellWithReuseIdentifier:NSStringFromClass([BannerCVCell class])];
        
        [self.view addSubview:_cvBrands];
    }
    
    return _cvBrands;
}

@end
