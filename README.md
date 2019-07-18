# LeftSlidePush
模仿目前主流短视频APP首页中左滑push 的功能 

### ````效果````
- ![Alt text](https://github.com/GitHubYYBS/LeftSlidePush/blob/master/%E5%BD%95%E5%B1%8F.gif?raw=true)

配置使用
- 包含该头文件
``` #import "UIViewController+YBSLeftSlidePush.h" ```
- 配置属性
``` 
self.navigationController.ybs_openLeftSlidePushBool = true;
elf.ybs_pushDelegate = self;
```
- 遵循代理``` <YBSViewControllerPushDelegate>```并实现代理方法
```
- (void)ybs_pushToNextViewController{
    
    [self.navigationController pushViewController:[TextNotLeftPushViewController new] animated:true];
}
```

实现思路及主要技术方法
- 通过```runtime```运行时为控制器及其他控件增加一系列的属性
- 通过运行时将控制器的```viewDidAppear:``` 方法进行交换 在该方法中实时为当前需要左滑push的控制器增加手势
- 为``` UINavigationController``` 拓展代理来实现手势相关操作
- 转场动画以及一系列的手势处理
- 由于在左滑push中 系统的TabBar 存在bug(滑动的同时位移存在偏差) 这里采用了为tabBar 提供一张截图 添加到底层的控制器View上 来解决该问题

手势核心代码
```
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
```

### 提别注意
笔者用的的架构模式是: UITabBarController -> UINavigationController ->控制器 这种方式
要保证在左滑push时 tabBar 正常消失和出现 还需要  
  
  - 在UITabBarController 中包含```#import "UIViewController+YBSLeftSlidePush.h"``` 并重写
  ```
  - (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    // 特别重要
    NSInteger chlidNum = [UIApplication sharedApplication].keyWindow.rootViewController.ybs_topViewController.navigationController.childViewControllers.count;
    self.tabBar.hidden = (chlidNum > 1)? YES : NO;
}
```

- 在UINavigationController 中 重写```- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated```
当然这步是一个项目的正常操作
```
 if (self.childViewControllers.count > 0){
        // 每次Push时隐藏tabBar
        viewController.hidesBottomBarWhenPushed = true;
    }
    // 调用系统的push方法  实现控制器的跳转
    [super pushViewController:viewController animated:animated];
    ```

    
    
