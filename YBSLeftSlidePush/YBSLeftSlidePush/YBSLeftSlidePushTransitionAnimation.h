//
//  YBSLeftSlidePushTransitionAnimation.h
//  YBSLeftSlidePush
//
//  Created by 严兵胜 on 2019/7/17.
//  Copyright © 2019 严兵胜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YBSLeftSlidePushTransitionAnimation : NSObject<UIViewControllerAnimatedTransitioning>

/**
 初始化方法
 
 @param scale 是否需要缩放，默认为NO
 @return 实例对象
 */
+ (instancetype)transitionWithScale:(BOOL)scale;

/// 动画
- (void)animateTransition;

/// 完成动画
- (void)completeTransition;

@end

NS_ASSUME_NONNULL_END
