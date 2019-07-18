//
//  YBSLeftSlidePushTransitionAnimation.m
//  YBSLeftSlidePush
//
//  Created by 严兵胜 on 2019/7/17.
//  Copyright © 2019 严兵胜. All rights reserved.
//

#import "YBSLeftSlidePushTransitionAnimation.h"
#import <UIKit/UIKit.h>


#define YBS_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define YBS_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define YBSDeviceVersion [[[UIDevice currentDevice] systemVersion] floatValue]



#pragma mark - ^^^^^^^^ UIView 拓展 ^^^^^^^^

@interface UIView (YBSCapture)

/// 捕获当前视图生成图像
- (UIImage *)ybs_captureCurrentViewRutenImage;

@end

@implementation UIView (YBSCapture)

- (UIImage *)ybs_captureCurrentViewRutenImage{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end



// ------------------------------ 华丽的风格线 ----------------------------------



@interface YBSLeftSlidePushTransitionAnimation ()<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL scale;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) UIViewController *fromViewController;
@property (nonatomic, weak) UIViewController *toViewController;

// 在做左滑push时 tabBar 发生的位移乱序(系统bug) 提供一张tabBar 的截图 添加到当前控制器底部 以提供tabBar 正常移动的假象
@property (nonatomic, strong) UIImageView *tabBarCaptureImageView;

@end

@implementation YBSLeftSlidePushTransitionAnimation

+ (instancetype)transitionWithScale:(BOOL)scale {
    YBSLeftSlidePushTransitionAnimation *pushAnimation = [YBSLeftSlidePushTransitionAnimation new];
    pushAnimation.scale = scale;
    return pushAnimation;
}

- (UIImageView *)tabBarCaptureImageView{
    if (!_tabBarCaptureImageView) {
        _tabBarCaptureImageView = [UIImageView new];
    }
    return _tabBarCaptureImageView;
}

#pragma mark - UIViewControllerAnimatedTransitioning
// 转场动画的时间
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return UINavigationControllerHideShowBarDuration;
}

// 转场动画
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // 获取转场容器
    UIView *containerView = [transitionContext containerView];
    
    // 获取转场前后的控制器
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    self.containerView      = containerView;
    self.fromViewController = fromVC;
    self.toViewController   = toVC;
    self.transitionContext  = transitionContext;
    
    [self animateTransition];
}

#pragma mark - 完成动画

- (void)completeTransition {
    [self.transitionContext completeTransition:!self.transitionContext.transitionWasCancelled];
    [self.tabBarCaptureImageView removeFromSuperview];
}


#pragma mark - 动画
- (void)animateTransition{
    
    // 修复系统bug 提供tabBar 假象
    if (self.fromViewController.navigationController.childViewControllers.count < 3) {
        UITabBar *tabBar = self.fromViewController.tabBarController.tabBar;
        self.tabBarCaptureImageView.image = [tabBar ybs_captureCurrentViewRutenImage];
        self.tabBarCaptureImageView.frame = CGRectMake(0, YBS_SCREEN_HEIGHT - tabBar.bounds.size.height, tabBar.bounds.size.width, tabBar.bounds.size.height);
        [self.fromViewController.view addSubview:self.tabBarCaptureImageView];
    }
    
    BOOL tabbarIsHidden = self.toViewController.hidesBottomBarWhenPushed;
    self.fromViewController.tabBarController.tabBar.hidden = tabbarIsHidden;
    
    [self.containerView addSubview:self.toViewController.view];
    
    // 设置转场前的frame
    self.toViewController.view.frame = CGRectMake(YBS_SCREEN_WIDTH, 0, YBS_SCREEN_WIDTH, YBS_SCREEN_HEIGHT);
    
    if (self.scale) {
        // 初始化阴影并添加
        self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBS_SCREEN_WIDTH, YBS_SCREEN_HEIGHT)];
        self.shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        [self.fromViewController.view addSubview:self.shadowView];
    }
    
    self.toViewController.view.layer.shadowColor   = [[UIColor blackColor] CGColor];
    self.toViewController.view.layer.shadowOpacity = 0.6;
    self.toViewController.view.layer.shadowRadius  = 8;
    
    // 执行动画
    [UIView animateWithDuration:[self transitionDuration:self.transitionContext] animations:^{
        self.shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        if (self.scale) {
            if (YBSDeviceVersion >= 11.0) {
                CGRect frame = self.fromViewController.view.frame;
                frame.origin.x = 15;
                frame.origin.y = 20;
                frame.size.height -= 2 * 20;
                self.fromViewController.view.frame = frame;
            }else {
                self.fromViewController.view.transform = CGAffineTransformMakeScale(0.9, 0.92);
            }
        }else {
            self.fromViewController.view.frame = CGRectMake(- (0.3 * YBS_SCREEN_WIDTH), 0, YBS_SCREEN_WIDTH, YBS_SCREEN_HEIGHT);
        }
        
        self.toViewController.view.frame = CGRectMake(0, 0, YBS_SCREEN_WIDTH, YBS_SCREEN_HEIGHT);
    }completion:^(BOOL finished) {
        [self completeTransition];
        [self.shadowView removeFromSuperview];
    }];
}

@end
