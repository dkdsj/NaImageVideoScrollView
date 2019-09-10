//
//  AVKitDemoViewController.m
//  轮播图片加视频
//
//  Created by ZZ on 2019/9/9.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import "AVKitDemoViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface AVKitDemoViewController ()

@property (nonatomic, strong) AVAssetImageGenerator *imageGenerator;

@property (nonatomic, strong) UIScrollView *svVideo;
@property (nonatomic, strong) NSMutableArray *brands;

@property (nonatomic, strong) AVURLAsset *asset;
@end

@implementation AVKitDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initData];
    [self initView];
    [self loadData];
}

- (void)initData {
    _brands = [NSMutableArray array];

}

- (void)initView {
    _svVideo = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 65, kScreenWidth, 200)];
    _svVideo.pagingEnabled = YES;
    _svVideo.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:.3];
    [self.view addSubview:_svVideo];
}

- (void)loadData {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"movie" withExtension:@"mp4"];
    NSDictionary *options = @{ AVURLAssetPreferPreciseDurationAndTimingKey : @YES };
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:options];
    _asset = asset;
    
    NSArray<NSString *> *playableKeys = @[@"playableKey", @"duration"];
    
    [asset loadValuesAsynchronouslyForKeys:playableKeys completionHandler:^{
        NSError *err = nil;
        AVKeyValueStatus status = [asset statusOfValueForKey:@"playableKey" error:&err];
        
        switch (status) {
            case AVKeyValueStatusUnknown:
                
                break;
                
            case AVKeyValueStatusLoading:
                
                break;
                
            case AVKeyValueStatusLoaded:
                
                break;
                
            case AVKeyValueStatusFailed:
                
                break;
                
            case AVKeyValueStatusCancelled:
                
                break;
                
            default:
                break;
        }
    }];
    
    
    // 加载一张图片
    _imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    
    
    CMTime assetTime = asset.duration;
    Float64 durationSeconds = CMTimeGetSeconds(assetTime);
    NSLog(@"视频时长 %f", durationSeconds);
    CMTime actualTime;
    
    CMTime requestTime = CMTimeMakeWithSeconds(13, assetTime.timescale);
    CGImageRef imageRef = [_imageGenerator copyCGImageAtTime:requestTime actualTime:&actualTime error:nil];
    
    if (imageRef) {
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        CGFloat imageW = image.size.width;
        CGFloat imageH = image.size.height;
        
        //根据原图像比例缩放
        CGFloat ivH = kScreenWidth*imageH/imageW;
        
        UIImageView *iv = [[UIImageView alloc] initWithImage:image];
        iv.frame = CGRectMake(0, 200, kScreenWidth, ivH);
        //[self.view addSubview:iv];
        
        NSLog(@"actualTime %lld, %d = %.2f", actualTime.value, actualTime.timescale, actualTime.value*1.0/actualTime.timescale);
    }
    
    
    // 加载多张图片
    for (UIView *v in self.svVideo.subviews) {
        [v removeFromSuperview];
    }
    
    NSValue *value1 = [NSValue valueWithCMTime:CMTimeMakeWithSeconds(2, assetTime.timescale)];
    NSValue *value2 = [NSValue valueWithCMTime:CMTimeMakeWithSeconds(5, assetTime.timescale)];
    NSValue *value3 = [NSValue valueWithCMTime:CMTimeMakeWithSeconds(10, assetTime.timescale)];
    NSValue *value4 = [NSValue valueWithCMTime:CMTimeMakeWithSeconds(20, assetTime.timescale)];
    NSValue *value5 = [NSValue valueWithCMTime:CMTimeMakeWithSeconds(40, assetTime.timescale)];
    NSArray<NSValue *>*values = @[value1, value2, value3, value4, value5];
    
    [_imageGenerator generateCGImagesAsynchronouslyForTimes:values
                                          completionHandler:^(CMTime requestedTime,
                                                              CGImageRef  _Nullable imageREF,
                                                              CMTime actualTime,
                                                              AVAssetImageGeneratorResult result,
                                                              NSError * _Nullable error)
    {
        if (result==AVAssetImageGeneratorSucceeded) {
            NSLog(@"%lld - actualTime %lld", requestedTime.value, actualTime.value);
            
            if ([NSThread isMainThread]) {
                [self addSubImageView:imageREF];
            } else {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self addSubImageView:imageREF];
                });
            }
        }
    }];
}

- (void)addSubImageView:(CGImageRef)imageRef {
    if (imageRef) {
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        CGFloat imageW = image.size.width;
        CGFloat imageH = image.size.height;
        
        //根据原图像比例缩放
        CGFloat ivH = kScreenWidth*imageH/imageW;
        
        UIImageView *iv = [[UIImageView alloc] initWithImage:image];
        iv.frame = CGRectMake(kScreenWidth*self.brands.count, 0, kScreenWidth, ivH);
        iv.contentMode = UIViewContentModeScaleAspectFit;
        [self.svVideo addSubview:iv];
        
        [self.brands addObject:@1];
        self.svVideo.frame = CGRectMake(0, 88, kScreenWidth, ivH);
        self.svVideo.contentSize = CGSizeMake(kScreenWidth*(self.brands.count), ivH);
        
        NSLog(@"count:%zd contentsize.width:%f ", self.svVideo.subviews.count, self.svVideo.contentSize.width);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self transFormatAsset];
}

- (void)transFormatAsset {
    NSArray *presets = [AVAssetExportSession exportPresetsCompatibleWithAsset:_asset];
    AVAssetExportSession *aeSession;
    NSString *presetName;
    
    //
    if ([presets containsObject:AVAssetExportPreset3840x2160]) {
        presetName = AVAssetExportPreset3840x2160;
    }
    
    if (@available(iOS 11.0, *)) {
        if ([presets containsObject:AVAssetExportPresetHEVCHighestQuality]) {
            presetName = AVAssetExportPresetHEVCHighestQuality;
        }
    }
    
    if ([presets containsObject:AVAssetExportPresetHighestQuality]) {
        presetName = AVAssetExportPresetHighestQuality;
    }
    
    
    //输出路径 类型
    aeSession = [AVAssetExportSession exportSessionWithAsset:_asset presetName:AVAssetExportPreset3840x2160];
    aeSession.outputFileType = AVFileTypeMPEG4;
    aeSession.outputURL = [NSURL fileURLWithPath:@"/Users/zz/Desktop/abc.mp4"];
    
    
    // [起始位置 时长]
    CMTime start = CMTimeMakeWithSeconds(1.0, 600);
    CMTime duration = CMTimeMakeWithSeconds(4.0, 600);
    aeSession.timeRange = CMTimeRangeMake(start, duration);
    
    
    
    
    
    [aeSession exportAsynchronouslyWithCompletionHandler:^{
        NSLog(@"%ld", (long)aeSession.status);
        
        switch(aeSession.status) {
            case AVAssetExportSessionStatusUnknown:
                NSLog(@"AVAssetExportSessionStatusUnknown");
                break;
            case AVAssetExportSessionStatusWaiting:
                NSLog(@"AVAssetExportSessionStatusWaiting");
                break;
            case AVAssetExportSessionStatusExporting:
                NSLog(@"AVAssetExportSessionStatusExporting");
                break;
            case AVAssetExportSessionStatusCompleted:
                NSLog(@"AVAssetExportSessionStatusCompleted");
                break;
            case AVAssetExportSessionStatusFailed:
                NSLog(@"AVAssetExportSessionStatusFailed");
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"AVAssetExportSessionStatusCancelled");
                break;
            default:
                break;
        }
    }];
}

- (void)avplayerItemDemo {
    AVPlayerItem *item;
    AVPlayerItemTrack *track;
}

@end
