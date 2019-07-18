//
//  YBSLeftSlidePushNavVcDelegate.h
//  YBSLeftSlidePush
//
//  Created by 严兵胜 on 2019/7/17.
//  Copyright © 2019 严兵胜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 左滑push代理
@protocol YBSVcLeftSildPushDelegate <NSObject>

- (void)ybs_pushNextVc;

@end




@interface YBSLeftSlidePushNavVcDelegate : NSObject<UINavigationControllerDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;
@property (nonatomic, weak) id<YBSVcLeftSildPushDelegate> ybs_pushDelegate;
// 手势Action
- (void)ybs_panGestureAction:(UIPanGestureRecognizer *)gesture;

@end

NS_ASSUME_NONNULL_END
