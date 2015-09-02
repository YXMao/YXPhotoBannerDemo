//
//  ViewController.m
//  YXPhotoBannerDemo
//
//  Created by YX on 15/9/1.
//  Copyright (c) 2015年 xxx.xxx.xxx. All rights reserved.
//

#import "ViewController.h"
#import "YXPhotoBannerView.h"

@interface ViewController ()<YXPhotoBannerViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YXPhotoBannerView * demo = [[YXPhotoBannerView alloc]initWithFrame:self.view.bounds images:@[@"1",@"2",@"3"]];
    //设置是否自动播放（默认不支持）
    demo.isAutoScroll = YES;
    //设置是否支持图片点击（默认不支持）
    demo.isSupportClick = YES;
    //设置代理
    demo.delegate = self;
    [self.view addSubview:demo];
    
}

#pragma mark - YXPhotoBannerViewDelegate
- (void)YXPhotoBannerView:(YXPhotoBannerView *)bannerView didSelectIndex:(NSInteger)index
{
    NSLog(@"You have clicked the index%ld",index);
}

@end
