//
//  YXPhotoBannerView.m
//  YXPhotoBannerDemo
//
//  Created by YX on 15/9/1.
//  Copyright (c) 2015年 xxx.xxx.xxx. All rights reserved.
//

#import "YXPhotoBannerView.h"

#define WIDTH  CGRectGetWidth(self.viewFrame)
#define HEIGHT CGRectGetHeight(self.viewFrame)

#define TIME_INTERVAL 2//滚动时间间隔

@interface YXPhotoBannerView()<UIScrollViewDelegate>
{
    NSTimer * _timer;
}

//主scrollview
@property(nonatomic,strong)UIScrollView * mainScrollView;

//图片源
@property(nonatomic,strong)NSMutableArray * imageNames;

//视图源
@property(nonatomic,strong)NSMutableArray * views;

//视图尺寸
@property(nonatomic,assign)CGRect viewFrame;

//分页控件
@property(nonatomic,strong)UIPageControl * pageControl;

//当前页数
@property(nonatomic,assign)NSInteger currentPage;

//初始化横幅
- (void)initBanner;

//加载图片
- (void)reloadImage;

//得到真实的索引
- (NSInteger)getActualIndex:(NSInteger)index;

//按钮响应事件
- (void)btnPressed:(UIButton *)sender;
- (void)btnTouchDown;

//开始计时
- (void)startTimer;
//暂停计时
- (void)pauseTimer;
//暂停计时
- (void)stopTimer;
//计时器响应操作
- (void)repondToTimer;

@end


@implementation YXPhotoBannerView



- (instancetype)initWithFrame:(CGRect)rect images:(NSArray *)images
{
   self = [super initWithFrame:rect];
    if (self) {
        //设置默认值
        self.isAutoScroll = NO;
        self.isSupportClick = NO;
        self.currentPage = 0;
        
        //参数赋值
        [self.imageNames addObjectsFromArray:images];
        self.viewFrame = rect;
        
        //初始化banner
        [self initBanner];
    }
    return self;
}


- (void)initBanner
{
    //初始化横幅
    for (int i = 0; i < 3; i ++) {
        
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH * i, 0, WIDTH, HEIGHT)];
        [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(btnTouchDown) forControlEvents:UIControlEventTouchDown];
        //取消按钮的高亮置灰效果
        [btn setAdjustsImageWhenHighlighted:NO];
        [self.mainScrollView addSubview:btn];
        
        if (i == 0) {
            //左视图，最后一张图
            [btn setBackgroundImage:[UIImage imageNamed:self.imageNames[self.imageNames.count - 1]] forState:UIControlStateNormal];
        }
        else {
            //中间视图,//右视图
            [btn setBackgroundImage:[UIImage imageNamed:self.imageNames[i - 1]] forState:UIControlStateNormal];
        }
        [self.views addObject:btn];
    }
    
    //初始化分页控件
    self.pageControl.currentPage = 0;
   
}

- (void)reloadImage
{
    //设置当前滑动到的页数
    if (self.mainScrollView.contentOffset.x < WIDTH) {
        //向左滑动
        self.currentPage = [self getActualIndex:--self.currentPage];
    }
    else if(self.mainScrollView.contentOffset.x > WIDTH){
        //向右滑动
        self.currentPage = [self getActualIndex:++self.currentPage];
    }
    
    //获取左，中，右视图
    UIButton * leftBtn = (UIButton *)self.views[0];
    UIButton * centerBtn = (UIButton *)self.views[1];
    UIButton * rightBtn = (UIButton *)self.views[2];
    
    //重置视图图片
    [leftBtn setBackgroundImage:[UIImage imageNamed:self.imageNames[[self getActualIndex:(self.currentPage - 1)]]] forState:UIControlStateNormal];
    [centerBtn setBackgroundImage:[UIImage imageNamed:self.imageNames[[self getActualIndex:self.currentPage]]] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:self.imageNames[[self getActualIndex:(self.currentPage + 1)]]] forState:UIControlStateNormal];
    
    //重置偏移量
    [self.mainScrollView setContentOffset:CGPointMake(WIDTH, 0) animated:NO];
    
    //设置pageControl当前显示页数
    self.pageControl.currentPage = self.currentPage;
}

- (NSInteger)getActualIndex:(NSInteger)index
{
    return (index + self.imageNames.count) % self.imageNames.count;
}

#pragma mark - 响应事件
- (void)btnPressed:(UIButton *)sender
{
    [self startTimer];
    if (self.isSupportClick && self.delegate && [self.delegate respondsToSelector:@selector(YXPhotoBannerView:didSelectIndex:)]) {
        [self.delegate YXPhotoBannerView:self didSelectIndex:self.currentPage];
    }
}

- (void)btnTouchDown
{
    [self pauseTimer];
}

#pragma mark - 计时器相关操作
- (void)startTimer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:TIME_INTERVAL target:self selector:@selector(repondToTimer) userInfo:nil repeats:YES];
        
    }
    _timer.fireDate = [NSDate dateWithTimeInterval:TIME_INTERVAL sinceDate:[NSDate date]];
}

- (void)pauseTimer
{
    if (_timer && _timer.isValid) {
        _timer.fireDate = [NSDate distantFuture];
    }
}

- (void)stopTimer
{
    if (_timer && _timer.isValid) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)repondToTimer
{
    //自动向前滚动一页
    [self.mainScrollView setContentOffset:CGPointMake(WIDTH * 2, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //开始拖拽时，暂停自动播放
    [self pauseTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //重新加载图片
    [self reloadImage];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //重新加载图片
    [self reloadImage];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    //结束拖拽时，开启自动播放
    [self startTimer];
}

#pragma mark - setter
- (void)setIsAutoScroll:(BOOL)isAutoScroll
{
    if (isAutoScroll) {
        _isAutoScroll = isAutoScroll;
        //启动计时器
        [self startTimer];
    }
}

#pragma mark - getter
- (UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        
        _mainScrollView = [[UIScrollView alloc]initWithFrame:self.viewFrame];
        //设置代理
        _mainScrollView.delegate = self;
        //设置尺寸
        _mainScrollView.contentSize = CGSizeMake(WIDTH * 3, HEIGHT);
        //设置偏移量
        _mainScrollView.contentOffset = CGPointMake(WIDTH, 0);
        //启动分页
        _mainScrollView.pagingEnabled = YES;
        //隐藏滚动条
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        
        [self addSubview:_mainScrollView];
    }
    return _mainScrollView;
}


- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.bounds = CGRectMake(0, 0, 120, 20);
        _pageControl.center = CGPointMake(WIDTH / 2, HEIGHT - 20);
        //设置总页数
        _pageControl.numberOfPages = self.imageNames.count;
        //设置样式
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
        [self addSubview:_pageControl];
    }
    return _pageControl;
}

- (NSMutableArray *)imageNames
{
    if (!_imageNames) {
        _imageNames = [[NSMutableArray alloc]init];
    }
    return _imageNames;
}

- (NSMutableArray *)views
{
    if (!_views) {
        _views = [[NSMutableArray alloc]init];
    }
    return _views;
}

@end
