//
//  ForgetPWViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/5/7.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "ForgetPWViewController.h"
#import "SettingPWViewController.h"
#import "AppDelegate.h"

@interface ForgetPWViewController ()
@property (weak, nonatomic) IBOutlet UIView *bgPhone;
@property (weak, nonatomic) IBOutlet UIView *bgCode;
@property (weak, nonatomic) IBOutlet UIButton *nextStep;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) NSDictionary *dataDict;
@end

@implementation ForgetPWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码"; 
    [self setLeftBackNavItem];
    [Tools configCornerOfView:_bgPhone with:3];
    [Tools configCornerOfView:_bgCode with:3];
    [Tools configCornerOfView:_nextStep with:3];
    [Tools configCornerOfView:_codeBtn with:3];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
    NSString *phoneStr = ((AppDelegate*)[UIApplication sharedApplication].delegate).phone;
    if (phoneStr.length == 0) {
        _phoneTF.userInteractionEnabled = YES;
        _phoneTF.placeholder = @"请输入手机号";
        _phoneTF.textAlignment = NSTextAlignmentLeft;
        _phoneTF.font = [UIFont systemFontOfSize:16.0];
    }else{
        _phoneTF.text = phoneStr;
        _bgPhone.backgroundColor = [UIColor clearColor];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)getCode:(id)sender {
    if (_phoneTF.text.length == 0) {
        [MBProgressHUD showError:@"请输入手机号" toView:self.view];
    }else{
        [self openCountdown];
        [DTNetManger verifyCodeWith:_phoneTF.text callBack:^(NSError *error, id response) {
            if (response && [response isKindOfClass:[NSDictionary class]]) {
                self.dataDict = (NSDictionary *)response;
            }else{
                [MBProgressHUD showError:[response objectForKey:@"msg"] toView:self.view];
            }
        }];
    }
}
- (IBAction)nextStepAction:(id)sender {
    if ([self check]) {
        [DTNetManger checkVerifyCodeWith:self.phoneTF.text code:self.codeTF.text callBack:^(NSError *error,  id response) {
            if (response && [response isKindOfClass:[NSDictionary class]]) {
                UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
                SettingPWViewController *cvc = [board instantiateViewControllerWithIdentifier:@"SettingPWViewController"];
                cvc.phone = _phoneTF.text;
                cvc.code = _codeTF.text;
                [self.navigationController pushViewController:cvc animated:YES];
            }else{
                [MBProgressHUD showError:[response objectForKey:@"msg"] toView:self.view];
            }

        }];
    }
}
// 开启倒计时效果
-(void)openCountdown{
    
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self.codeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.codeBtn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self.codeBtn setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                [self.codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.codeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

- (BOOL)check{
    if (_phoneTF.text.length == 0) {
        [MBProgressHUD showError:@"请输入手机号" toView:self.view];
        return NO;
    }else{
        if (_codeTF.text.length == 0) {
            [MBProgressHUD showError:@"请输入验证码" toView:self.view];
            return NO;
        }
        return YES;
    }
}

- (void)tap{
    [_phoneTF resignFirstResponder];
    [_codeTF resignFirstResponder];
}

@end
