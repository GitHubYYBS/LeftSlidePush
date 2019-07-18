//
//  YBSNavigationViewController.m
//  PinJinJin
//
//  Created by 啦啦啊 on 2019/5/30.
//  Copyright © 2019 aolm. All rights reserved.
//

#import "YBSNavigationViewController.h"

@interface YBSNavigationViewController ()

@end

@implementation YBSNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationBar.hidden = true;

}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.childViewControllers.count > 0){
        // 每次Push时隐藏tabBar
        viewController.hidesBottomBarWhenPushed = true;
    }
    // 调用系统的push方法  实现控制器的跳转
    [super pushViewController:viewController animated:animated];
}

- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}



@end
