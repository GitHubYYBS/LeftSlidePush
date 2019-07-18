//
//  YBSTabBarViewController.m
//  PinJinJin
//
//  Created by 啦啦啊 on 2019/5/30.
//  Copyright © 2019 aolm. All rights reserved.
//

#import "YBSTabBarViewController.h"
#import "YBSNavigationViewController.h"
#import "ViewController.h"

#import "UIViewController+YBSLeftSlidePush.h"

@interface YBSTabBarViewController ()<UINavigationControllerDelegate,UITabBarControllerDelegate,UITabBarDelegate>

@property (nonatomic, copy) NSArray *itemTitleArray;


@end

@implementation YBSTabBarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.tabBar.tintColor = [UIColor redColor];
    
    [self setUpAllChildViewController];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}




- (void)setUpAllChildViewController{
    
    
    [self setUpOneChileViewController:[ViewController new]];
    [self setUpOneChileViewController:[UIViewController new]];
    [self setUpOneChileViewController:[UIViewController new]];
    [self setUpOneChileViewController:[ViewController new]];
    [self setUpOneChileViewController:[ViewController new]];
    
}

// 添加一个控制器
- (void)setUpOneChileViewController:(UIViewController *)vc{
    YBSNavigationViewController *nav = [[YBSNavigationViewController alloc] initWithRootViewController:vc];
    nav.tabBarItem.title = @"啦啦";
    nav.tabBarItem.image = [UIImage imageNamed:@"tab_mine"];
    
    [self addChildViewController:nav];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    // 特别重要
    NSInteger chlidNum = [UIApplication sharedApplication].keyWindow.rootViewController.ybs_topViewController.navigationController.childViewControllers.count;
    self.tabBar.hidden = (chlidNum > 1)? YES : NO;
}


- (BOOL)shouldAutorotate{
    //在viewControllers中返回需要改变的NavigationController
    return [[self.viewControllers firstObject] shouldAutorotate];
}







@end
