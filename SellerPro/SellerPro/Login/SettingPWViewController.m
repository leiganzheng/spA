//
//  SettingPWViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/5/7.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "SettingPWViewController.h"
#import "LoginViewController.h"
@interface SettingPWViewController ()
@property (weak, nonatomic) IBOutlet UIView *bgPhone;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *passWordTF;
@property (weak, nonatomic) IBOutlet UIView *customView;
@property (weak, nonatomic) IBOutlet UIView *setView;

@end

@implementation SettingPWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置密码";
    [self setLeftBackNavItem];
    [Tools configCornerOfView:_bgPhone with:3];
    [Tools configCornerOfView:_doneBtn with:3];
    [Tools configCornerOfView:_loginBtn with:3];
    self.customView.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doneAction:(id)sender {
    self.customView.hidden = NO;
    self.setView.hidden = YES;
    if ([self check]) {
        [DTNetManger modifyPassWordWith:self.phone PW:self.passWordTF.text code:self.code callBack:^(NSError *error, NSArray *response) {
            
        }];
    }
  
}
- (BOOL)check{
    if (_passWordTF.text.length == 0) {
        [MBProgressHUD showError:@"请输入新密码" toView:self.view];
        return NO;
    }
    return YES;
}

- (void)tap{
    [_passWordTF resignFirstResponder];
}
- (IBAction)login:(id)sender {
    UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    LoginViewController *cvc = [board instantiateViewControllerWithIdentifier:@"LoginViewController"];
     UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cvc];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}



@end
