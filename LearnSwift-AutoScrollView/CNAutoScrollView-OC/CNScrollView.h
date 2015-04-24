//
//  CNScrollView.h
//  LearnSwift-AutoScrollView
//
//  Created by shscce on 15/4/24.
//  Copyright (c) 2015年 shscce. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol CNScrollViewDelegate <NSObject>

- (NSInteger)numberOfPages;
- (NSString *)imageNameOfIndex:(NSInteger)index;

@optional
- (void)didSelectedIndex:(NSInteger)index;
- (void)indexDidChange:(NSInteger)index;

@end

@interface CNScrollView : UIView

@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) BOOL autoScroll;
@property (weak, nonatomic) id<CNScrollViewDelegate> delegate;

@end
