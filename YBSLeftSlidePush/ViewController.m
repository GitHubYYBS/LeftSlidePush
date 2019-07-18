//
//  ViewController.m
//  YBSLeftSlidePush
//
//  Created by 严兵胜 on 2019/7/17.
//  Copyright © 2019 严兵胜. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+YBSLeftSlidePush.h"



#import "TextNotLeftPushViewController.h"

@interface ViewController ()<YBSViewControllerPushDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256) / 255.0f green:arc4random_uniform(256) / 255.0f blue:arc4random_uniform(256) / 255.0f alpha:1];
    
    UIButton *btn = [UIButton new];
    btn.frame = CGRectMake(100, 100, 150, 100);
    btn.backgroundColor = [UIColor redColor];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    [btn setTitle:@"第一个界面" forState:0];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:25];
    [self.view addSubview:btn];
    
    self.navigationController.ybs_openLeftSlidePushBool = true;
    self.ybs_pushDelegate = self;
}

- (void)ybs_pushToNextViewController{
    
    [self.navigationController pushViewController:[TextNotLeftPushViewController new] animated:true];
}

- (void)pushToNextViewController{
    
    [self.navigationController pushViewController:[TextNotLeftPushViewController new] animated:true];
}


@end
