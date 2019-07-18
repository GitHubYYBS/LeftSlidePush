//
//  UIViewController+YBSLeftSlidePush.h
//  YBSLeftSlidePush
//
//  Created by 严兵胜 on 2019/7/17.
//  Copyright © 2019 严兵胜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBSLeftSlidePushNavVcDelegate.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ^^^^^^^^ UIViewController 拓展 ^^^^^^^^

// 交给单独控制器处理
@protocol YBSViewControllerPushDelegate <NSObject>

@optional

- (void)ybs_pushToNextViewController;

@end


static NSString *const YBSLeftSlidePushViewDidAppearNotification_Key = @"ViewDidAppearNotification";

static NSString *const YBSLeftSlidePushCurDidAppearVc_Key = @"YBSLeftSlidePushCurDidAppearVc";

@interface UIViewController (YBSLeftSlidePush)

/** push代理 */
@property (nonatomic, weak) id<YBSViewControllerPushDelegate> ybs_pushDelegate;

/// 获取目前在栈顶的控制器
- (UIViewController *)ybs_topViewController;

@end



// ------------------------------ 华丽的风格线 ----------------------------------

#pragma mark - ^^^^^^^^ UINavigationController 拓展 ^^^^^^^^

@interface UINavigationController (YBSLeftSlidePush)<YBSVcLeftSildPushDelegate>

/** 是否开启左滑push操作，默认是NO，此时不可禁用控制器的滑动返回手势 */
@property (nonatomic, assign) BOOL ybs_openLeftSlidePushBool;

@end

NS_ASSUME_NONNULL_END
