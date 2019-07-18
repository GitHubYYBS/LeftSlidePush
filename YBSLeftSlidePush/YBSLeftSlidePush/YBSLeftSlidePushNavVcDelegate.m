//
//  YBSLeftSlidePushNavVcDelegate.m
//  YBSLeftSlidePush
//
//  Created by 严兵胜 on 2019/7/17.
//  Copyright © 2019 严兵胜. All rights reserved.
//

#import "YBSLeftSlidePushNavVcDelegate.h"
#import "UIViewController+YBSLeftSlidePush.h"
#import "YBSLeftSlidePushTransitionAnimation.h"


@interface YBSLeftSlidePushNavVcDelegate ()

@property (nonatomic, assign) BOOL isGesturePush;
/// push动画的百分比
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *pushTransition;
@end

@implementation YBSLeftSlidePushNavVcDelegate

#pragma mark - UINavigationControllerDelegate
-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    if ((self.navigationController.ybs_openLeftSlidePushBool && self.pushTransition)) {
        if (operation == UINavigationControllerOperationPush){
             return [YBSLeftSlidePushTransitionAnimation transitionWithScale:false];
        }
       
    }
    
    return nil;
}

-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    
    if ((self.navigationController.ybs_openLeftSlidePushBool && self.pushTransition)) {
        return self.pushTransition;
    }
    return nil;
}

#pragma mark - 滑动手势处理
- (void)ybs_panGestureAction:(UIPanGestureRecognizer *)gesture {
    
    
    // 进度
    CGFloat progress = [gesture translationInView:gesture.view].x / gesture.view.bounds.size.width;
    CGPoint translation = [gesture velocityInView:gesture.view];
    
    // 在手势开始的时候判断是push操作还是pop操作
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.isGesturePush = translation.x < 0 ? YES : NO;
    }
    
    // push时 progress < 0 需要做处理
    if (self.isGesturePush) progress = -progress;
    
    progress = MIN(1.0, MAX(0.0, progress));
    
    if (!_isGesturePush) return;
    
    if (gesture.state == UIGestureRecognizerStateBegan && self.navigationController.ybs_openLeftSlidePushBool && [self.ybs_pushDelegate respondsToSelector:@selector(ybs_pushNextVc)]) {
        self.pushTransition = [UIPercentDrivenInteractiveTransition new];
        self.pushTransition.completionCurve = UIViewAnimationCurveEaseOut;
        [self.ybs_pushDelegate ybs_pushNextVc];
        [self.pushTransition updateInteractiveTransition:0];
        return;
    }
    
    if (gesture.state == UIGestureRecognizerStateChanged && self.navigationController.ybs_openLeftSlidePushBool) {
        [self.pushTransition updateInteractiveTransition:progress];
        return;
    }
    
    if ((gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) && self.navigationController.ybs_openLeftSlidePushBool) {
        if (progress > 0.3) { // 滑动边距 严兵胜  大于这个距离才可puch
            [self.pushTransition finishInteractiveTransition];
        }else {
            [self.pushTransition cancelInteractiveTransition];
        }
        self.pushTransition = nil;
        self.isGesturePush  = NO;
        return;
    }
}

@end
