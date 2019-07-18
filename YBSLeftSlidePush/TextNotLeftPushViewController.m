//
//  TextNotLeftPushViewController.m
//  YBSLeftSlidePush
//
//  Created by 严兵胜 on 2019/7/17.
//  Copyright © 2019 严兵胜. All rights reserved.
//

#import "TextNotLeftPushViewController.h"

@interface TextNotLeftPushViewController ()

@end

@implementation TextNotLeftPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256) / 255.0f green:arc4random_uniform(256) / 255.0f blue:arc4random_uniform(256) / 255.0f alpha:1];
    
    UIButton *btn = [UIButton new];
    btn.frame = CGRectMake(100, 100, 200, 100);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(shfdals) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    [btn setTitle:[NSString stringWithFormat:@"第%ld个界面(pop)",self.navigationController.childViewControllers.count] forState:0];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:25];
    [self.view addSubview:btn];
    
    UIButton *btn_1 = [UIButton new];
    btn_1.frame = CGRectMake(100, 200, 200, 100);
    btn_1.backgroundColor = [UIColor blueColor];
    [btn_1 addTarget:self action:@selector(sdfasdfsd) forControlEvents:UIControlEventTouchUpInside];
    [btn_1 setTitleColor:[UIColor whiteColor] forState:0];
    [btn_1 setTitle:[NSString stringWithFormat:@"第%ld个界面(push)",self.navigationController.childViewControllers.count] forState:0];
    btn_1.titleLabel.font = [UIFont boldSystemFontOfSize:25];
    [self.view addSubview:btn_1];
}

- (void)shfdals{
    [self.navigationController popViewControllerAnimated:true];
}

- (void)sdfasdfsd{
    
    [self.navigationController pushViewController:[TextNotLeftPushViewController new] animated:true];
}
    
    
    

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
