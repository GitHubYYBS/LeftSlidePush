//
//  UIViewController+YBSLeftSlidePush.m
//  YBSLeftSlidePush
//
//  Created by 严兵胜 on 2019/7/17.
//  Copyright © 2019 严兵胜. All rights reserved.
//

#import "UIViewController+YBSLeftSlidePush.h"
#import <objc/runtime.h>

#import "YBSLeftSlidePushNavVcDelegate.h"

#pragma mark - ^^^^^^^^ UINavigationController 拓展 ^^^^^^^^
@implementation UINavigationController (YBSLeftSlidePush)
+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(viewDidLoad);
        SEL swizzledSelector = @selector(ybs_leftSlidePushNavViewDidLoad);
        [self swizzlingInClass:[self class] originalSelector:originalSelector swizzledSelector:swizzledSelector];
    });
}

+ (void)swizzlingInClass:(Class)cls originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector
{
    Class class = cls;
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class,originalSelector,method_getImplementation(swizzledMethod),method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,swizzledSelector,method_getImplementation(originalMethod),method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)ybs_leftSlidePushNavViewDidLoad{
    
    // 处理特殊控制器
    if ([self isKindOfClass:[UIImagePickerController class]]) return;
    if ([self isKindOfClass:[UIVideoEditorController class]]) return;
    
    // 设置代理
    self.delegate = self.navDelegate;
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ybs_handleNotification:) name:YBSLeftSlidePushViewDidAppearNotification_Key object:nil];
    
    [self ybs_leftSlidePushNavViewDidLoad];
}

#pragma mark - Notification Handle
- (void)ybs_handleNotification:(NSNotification *)notify{
    
    UIViewController *vc = (UIViewController *)notify.object[YBSLeftSlidePushCurDidAppearVc_Key];
    BOOL isRootVC = vc == self.viewControllers.firstObject;
    
    // 先移除
    self.interactivePopGestureRecognizer.delegate = nil;
    self.interactivePopGestureRecognizer.enabled = NO;
    [self.interactivePopGestureRecognizer.view removeGestureRecognizer:self.screenPanGesture];
    
    // 给self.interactivePopGestureRecognizer.view 添加全屏滑动手势
    if (!isRootVC && ![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.panGesture]) {
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.panGesture];
    }
    
    // 添加手势处理
    if (self.ybs_openLeftSlidePushBool) {
        [self.panGesture addTarget:self.navDelegate action:@selector(ybs_panGestureAction:)];
    }else {
        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
        [self.panGesture addTarget:[self systemTarget] action:internalAction];
    }
}


- (BOOL)ybs_openLeftSlidePushBool{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setYbs_openLeftSlidePushBool:(BOOL)ybs_openLeftSlidePushBool{
    objc_setAssociatedObject(self, @selector(ybs_openLeftSlidePushBool), @(ybs_openLeftSlidePushBool), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YBSLeftSlidePushNavVcDelegate *)navDelegate {
    YBSLeftSlidePushNavVcDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    if (!delegate) {
        delegate = [YBSLeftSlidePushNavVcDelegate new];
        delegate.navigationController = self;
        delegate.ybs_pushDelegate = self;
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegate;
}

- (UIScreenEdgePanGestureRecognizer *)screenPanGesture {
    UIScreenEdgePanGestureRecognizer *panGesture = objc_getAssociatedObject(self, _cmd);
    if (!panGesture) {
        panGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self.navDelegate action:@selector(ybs_panGestureAction:)];
        panGesture.edges = UIRectEdgeLeft;
        
        objc_setAssociatedObject(self, _cmd, panGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGesture;
}

- (UIPanGestureRecognizer *)panGesture {
    UIPanGestureRecognizer *panGesture = objc_getAssociatedObject(self, _cmd);
    if (!panGesture) {
        panGesture = [[UIPanGestureRecognizer alloc] init];
        panGesture.maximumNumberOfTouches = 1;
        
        objc_setAssociatedObject(self, _cmd, panGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGesture;
}

- (id)systemTarget {
    NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
    id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
    
    return internalTarget;
}

#pragma mark - YBSVcLeftSildPushDelegate
- (void)ybs_pushNextVc{
    // 获取当前控制器
    UIViewController *currentVC = self.visibleViewController;
    
    if ([currentVC.ybs_pushDelegate respondsToSelector:@selector(ybs_pushToNextViewController)]) {
        [currentVC.ybs_pushDelegate ybs_pushToNextViewController];
    }
}




- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YBSLeftSlidePushViewDidAppearNotification_Key object:nil];
}

@end



// ------------------------------ 华丽的风格线 ----------------------------------

#pragma mark - ^^^^^^^^ UIViewController 拓展 ^^^^^^^^

@implementation UIViewController (YBSLeftSlidePush)
+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(viewDidAppear:);
        SEL swizzledSelector = @selector(ybs_leftSlidePushViewDidAppear:);
        [self swizzlingInClass:[self class] originalSelector:originalSelector swizzledSelector:swizzledSelector];
    });
}

+ (void)swizzlingInClass:(Class)cls originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector
{
    Class class = cls;
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class,originalSelector,method_getImplementation(swizzledMethod),method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,swizzledSelector,method_getImplementation(originalMethod),method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)ybs_leftSlidePushViewDidAppear:(BOOL)animated{
    
//    self.navigationController.ybs_openLeftSlidePushBool = self.ybs_pushDelegate;
    
    // 在每次视图出现的时候重新设置当前控制器的手势
    [[NSNotificationCenter defaultCenter] postNotificationName:YBSLeftSlidePushViewDidAppearNotification_Key object:@{YBSLeftSlidePushCurDidAppearVc_Key: self}];
    [self ybs_leftSlidePushViewDidAppear:animated];
}

static const void* YBSLeftSlidePushDelegate_Key = @"YBSLeftSlidePushDelegate";
- (id<YBSViewControllerPushDelegate>)ybs_pushDelegate{
    return objc_getAssociatedObject(self, YBSLeftSlidePushDelegate_Key);
}

- (void)setYbs_pushDelegate:(id<YBSViewControllerPushDelegate>)ybs_pushDelegate{
    objc_setAssociatedObject(self, YBSLeftSlidePushDelegate_Key, ybs_pushDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



// 获取栈顶控制器
- (UIViewController *)ybs_topViewController
{
    return [self topViewControllerWithRootViewController:self];
}

- (UIViewController *)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]])
    {
        
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    }
    else if ([rootViewController isKindOfClass:[UINavigationController class]])
    {
        
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
        
    }
    else if (rootViewController.presentedViewController)
    {
        
        return [self topViewControllerWithRootViewController:rootViewController.presentedViewController];
        
    }
    else
    {
        return rootViewController;
    }
}


@end
