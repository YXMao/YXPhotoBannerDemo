//
//  YXPhotoBannerView.h
//  YXPhotoBannerDemo
//
//  Created by YX on 15/9/1.
//  Copyright (c) 2015年 xxx.xxx.xxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YXPhotoBannerView;

@protocol YXPhotoBannerViewDelegate <NSObject>

- (void)YXPhotoBannerView:(YXPhotoBannerView *)bannerView didSelectIndex:(NSInteger)index;

@end


@interface YXPhotoBannerView : UIView

/**
 *  是否支持自动滚屏
 */
@property(nonatomic,assign)BOOL isAutoScroll;

/**
 *  是否支持屏幕点击
 */
@property(nonatomic,assign)BOOL isSupportClick;

/**
 *  代理
 */
@property(nonatomic,assign)id<YXPhotoBannerViewDelegate> delegate;


/**
 *  初始化横幅视图
 *
 *  @param rect   位置
 *  @param images 图片源
 */

- (instancetype)initWithFrame:(CGRect)rect images:(NSArray *)images;

@end
