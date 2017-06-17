//
//  LoginViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/5/7.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgetPWViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *login;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *pwTF;
@property (weak, nonatomic) IBOutlet UIImageView *logo;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDefault objectForKey:@"Pusername"];
    _phoneTF.text = @"13800138000";
    _pwTF.text = @"123";
    [Tools configCornerOfView:_login with:3];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
    [self.logo sd_setImageWithURL:[NSURL URLWithString:((AppDelegate*)[UIApplication sharedApplication].delegate).logo] placeholderImage:[UIImage imageNamed:@"LOGO"] options:SDWebImageProgressiveDownload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (IBAction)loginAction:(id)sender {
    if ([self check]) {
        [DTNetManger loginWith:_phoneTF.text PW:_pwTF.text callBack:^(NSError *error, id response) {
            if (response && [response isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = (NSDictionary *)response;
                ((AppDelegate*)[UIApplication sharedApplication].delegate).token = dict[@"token"];
                ((AppDelegate*)[UIApplication sharedApplication].delegate).rtoken = dict[@"refresh_token"];
                ((AppDelegate*)[UIApplication sharedApplication].delegate).phone = _phoneTF.text;
                ((AppDelegate*)[UIApplication sharedApplication].delegate).logo = dict[@"logo"];
                
                NSTimeInterval time=[dict[@"token_expires"] doubleValue];
                NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
                NSInteger i = [self interceptTimeStampFromStr:detaildate];
                
                [((AppDelegate*)[UIApplication sharedApplication].delegate) openCountdown:i];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                //登陆成功后把用户名存储到UserDefault
                [userDefaults setObject:_phoneTF.text forKey:@"Pusername"];
                [userDefaults synchronize];
                //跳转
                UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
                MainViewController *main = [board instantiateViewControllerWithIdentifier:@"MainViewController"];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:main];
                [Tools enterRootViewController:nav animated:YES];
            }else{
                if (response && [response isKindOfClass:[NSString class]]) {
                    [MBProgressHUD showError:(NSString*)response toView:self.view];
                }else{
                    [MBProgressHUD showError:@"登录失败，请重试" toView:self.view];
                }
                
            }
        }];
    }
}
- (NSInteger)interceptTimeStampFromStr:(NSDate *)str{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.0";
    // 截止时间字符串格式
    // 当前时间字符串格式
    NSString *nowDateStr = [dateFomatter stringFromDate:nowDate];
    // 截止时间data格式
    NSString *expireDateStr = [dateFomatter stringFromDate:str];
    // 当前时间data格式
    NSDate *expireDate = [dateFomatter dateFromString:expireDateStr];
    nowDate = [dateFomatter dateFromString:nowDateStr];
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:nowDate toDate:expireDate options:0];
    NSInteger sum = (dateCom.second)+(dateCom.minute*60)+(dateCom.hour*60*60)+(dateCom.day*24*60*60)+(dateCom.year*365*24*60*60);
//    NSLog(@"interceptTimeStampFromStr=%li ---  dateCom:%@",(long)sum,dateCom);
    return sum;
}
- (IBAction)forgetPW:(id)sender {
    UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    ForgetPWViewController *cvc = [board instantiateViewControllerWithIdentifier:@"ForgetPWViewController"];
    [self.navigationController pushViewController:cvc animated:YES];
}
- (BOOL)check{
    if (_phoneTF.text.length == 0) {
        [MBProgressHUD showError:@"请输入手机号" toView:self.view];
        return NO;
    }else{
        if (_pwTF.text.length == 0) {
             [MBProgressHUD showError:@"请输入密码" toView:self.view];
            return NO;
        }
        return YES;
    }
}
- (void)tap{
    [_phoneTF resignFirstResponder];
    [_pwTF resignFirstResponder];
}

@end
