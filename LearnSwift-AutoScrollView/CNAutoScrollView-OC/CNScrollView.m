//
//  CNScrollView.m
//  LearnSwift-AutoScrollView
//
//  Created by shscce on 15/4/24.
//  Copyright (c) 2015年 shscce. All rights reserved.
//

#import "CNScrollView.h"

@interface CNScrollView ()<UIScrollViewDelegate>

@end

@implementation CNScrollView{

    __weak UIScrollView *_scrollView; //用于滚动的scrollView
    __weak UIPageControl *_pageControl;//
    NSTimer *_timer; //定时器 用于自动滚动
    __weak UIImageView *_leftImageView; //左侧imageView
    __weak UIImageView *_centerImageView;//右侧imageView
    __weak UIImageView *_rightImageView; //右侧imageView
    BOOL _isAutoScrolling; //是否正在自动滚动中
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initScrollView];
        [self initPageControl];
    }
    return self;
}

#pragma mark - getters

/**
 *  获取self.View的高度
 *
 *  @return
 */
- (CGFloat)viewHeight{
    return self.frame.size.height;
}

/**
 *  获取self.view的宽度
 *
 *  @return <#return value description#>
 */
- (CGFloat)viewWidth{
    return self.frame.size.width;
}

#pragma mark - setters

/**
 *  设置当前index
 *
 *  @param currentIndex
 */
- (void)setCurrentIndex:(NSInteger)currentIndex{
    if (currentIndex < 0) {
        _currentIndex = [self.delegate numberOfPages] - 1;
    }else if (currentIndex > [self.delegate numberOfPages] - 1){
        _currentIndex = 0;
    }else{
        _currentIndex = currentIndex;
    }
    [self reloadImage];
}

/**
 *  设置是否自动滚动
 *
 *  @param autoScroll
 */
- (void)setAutoScroll:(BOOL)autoScroll{
    if (autoScroll && _isAutoScrolling == NO) {
        [self startTimer];
    }else{
        [self stopTimer];
    }
    _autoScroll = autoScroll;
}

/**
 *  设置代理
 *
 *  @param delegate
 */
- (void)setDelegate:(id<CNScrollViewDelegate>)delegate{
    _delegate = delegate;
    _pageControl.numberOfPages = [delegate numberOfPages];
    if (_pageControl.numberOfPages == 1) {
        _scrollView.scrollEnabled = NO;
    }
    [self reloadImage];
}


#pragma mark - timer相关

/**
 *  开启自动滚动
 */
- (void)startTimer{
    _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    _isAutoScrolling = YES;
}

/**
 *  关闭自动滚动
 */
- (void)stopTimer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _isAutoScrolling = NO;
}

/**
 *  自动滚动时 下一页
 */
- (void)nextPage{
    [UIView animateWithDuration:.3 animations:^{
        [_scrollView setContentOffset:CGPointMake(2*[self viewWidth], 0)];
    } completion:^(BOOL finished) {
        self.currentIndex++;
    }];
}

#pragma mark - 界面初始化

/**
 *  初始化scrollView
 */
- (void)initScrollView{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [self viewWidth], [self viewHeight])];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    [scrollView addSubview:_leftImageView = [self createImageView:0]];
    [scrollView addSubview:_centerImageView = [self createImageView:1]];
    [scrollView addSubview:_rightImageView = [self createImageView:2]];
    scrollView.contentSize = CGSizeMake(3*[self viewWidth], [self viewHeight]);
    
    [self addSubview:_scrollView = scrollView];
}

/**
 *  初始化pageControl
 */
- (void)initPageControl{
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, [self viewHeight] - 40, [self viewWidth], 20)];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    pageControl.pageIndicatorTintColor = [UIColor greenColor];
    [pageControl setHidesForSinglePage:YES];
    [self addSubview:_pageControl = pageControl];
}

/**
 *  创建一个imageView
 *
 *  @param index 根据index判断imageView x轴偏离位置
 *
 *  @return
 */
- (UIImageView *)createImageView:(NSInteger)index{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(index * [self viewWidth], 0, [self viewWidth], [self viewHeight])];
    imageView.autoresizingMask = NO;
    imageView.layer.masksToBounds = YES;
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [imageView addGestureRecognizer:tap];
    return imageView;
}

/**
 *  处理imageView点击时间
 *
 *  @param tap
 */
- (void)handleTap:(UITapGestureRecognizer *)tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedIndex:)]) {
        [self.delegate didSelectedIndex:self.currentIndex];
    }
}

#pragma mark - 方法

/**
 *  设置各个imageView显示的图片
 *
 *  @param leftImageIndex   左侧图片显示的index
 *  @param centerImageIndex 中间图片显示的index
 *  @param rightImageIndex  右侧图片显示的index
 */
- (void)setImage:(NSInteger)leftImageIndex centerImageIndex:(NSInteger)centerImageIndex rightImageIndex:(NSInteger)rightImageIndex{
    NSString *leftImageName = [self.delegate imageNameOfIndex:leftImageIndex];
    NSString *rightImageName = [self.delegate imageNameOfIndex:rightImageIndex];
    NSString *centerImageName = [self.delegate imageNameOfIndex:centerImageIndex];
    
    [_leftImageView setImage:[UIImage imageNamed:leftImageName]];
    [_centerImageView setImage:[UIImage imageNamed:centerImageName]];
    [_rightImageView setImage:[UIImage imageNamed:rightImageName]];

}

/**
 *  重新设置各个imageView的图片
 */
- (void)reloadImage{
    NSInteger leftImageIndex = 0,rightItemIndex = 0;
    if (self.currentIndex == 0) {
        leftImageIndex = [self.delegate numberOfPages] - 1;
        rightItemIndex = 1;
    }else if (self.currentIndex == [self.delegate numberOfPages] - 1){
        leftImageIndex = [self.delegate numberOfPages] - 2;
        rightItemIndex = 0;
    }else{
        leftImageIndex = self.currentIndex - 1;
        rightItemIndex = self.currentIndex + 1;
    }
    [self setImage:leftImageIndex centerImageIndex:self.currentIndex rightImageIndex:rightItemIndex];
    [_scrollView setContentOffset:CGPointMake([self viewWidth], 0)];
    _pageControl.currentPage = self.currentIndex;
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.autoScroll) {
        [self startTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger tempIndex = self.currentIndex;
    if (offsetX < [self viewWidth] * 0.7) {
        tempIndex --;
    }else if (offsetX > [self viewWidth] * 1.3){
        tempIndex ++;
    }
    if (self.currentIndex == tempIndex) {
        return;
    }
    self.currentIndex = tempIndex;
    if (self.delegate && [self.delegate respondsToSelector:@selector(indexDidChange:)]) {
        [self.delegate indexDidChange:self.currentIndex];
    }
}
@end
