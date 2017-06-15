//
//  AppDelegate.m
//  SellerPro
//
//  Created by leiganzheng on 2017/5/7.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "IQKeyboardManager.h"
@interface AppDelegate ()<UIAlertViewDelegate>

@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UINavigationBar *navBar = [UINavigationBar appearance];
    navBar.translucent = NO;
    navBar.barStyle = UIBarStyleBlack;
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor] , NSFontAttributeName:DT_Nav_TitleFont}];
    navBar.barTintColor = [UIColor blackColor];
    [self setUpBaseNetwork];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    return YES;
}
- (void)setUpBaseNetwork
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring]; //检测网络
    [HYBNetworking updateBaseUrl:kDTBaseHostUrl];                   //默认hostUrl
    [HYBNetworking configRequestType:kHYBRequestTypeJSON       //请求类型 数据类型 Encode Url
                        responseType:kHYBResponseTypeJSON
                 shouldAutoEncodeUrl:YES
             callbackOnCancelRequest:NO];
    [HYBNetworking enableInterfaceDebug:NO];                        //是否开启debug模式
    [HYBNetworking obtainDataFromLocalWhenNetworkUnconnected:YES];  //网络异常时本地获取数据
    [HYBNetworking cacheGetRequest:YES shoulCachePost:YES];         //数据缓存
    [HYBNetworking setTimeout:20.f];                                //超时回调
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)openCountdown:(NSInteger)sum{
    [_myTimer invalidate];
    _myTimer =nil;
//    assert(sum == 0);
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:sum target:self selector:@selector(function) userInfo:nil repeats:NO];
//    __block NSInteger time = sum; //倒计时时间
//    
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//    
//    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
//    
//    dispatch_source_set_event_handler(_timer, ^{
//        
//        if(time <= 0){ //倒计时结束，关闭
//            
//            dispatch_source_cancel(_timer);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"Token失效，请重新登录" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [view show];
//            });
//            
//        }else{
//            
//            int seconds = time % 60;
//            dispatch_async(dispatch_get_main_queue(), ^{
//            });
//            time--;
//        }
//    });
//    dispatch_resume(_timer);
}
-(void)function{
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"Token失效，请重新登录" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [view show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //处理返回事件
        self.phone = @"";
        [self.myTimer invalidate];
        self.myTimer  = nil;
        UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
        LoginViewController *cvc = [board instantiateViewControllerWithIdentifier:@"LoginViewController"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cvc];
        [Tools enterRootViewController:nav animated:YES];
    }
}
@end
