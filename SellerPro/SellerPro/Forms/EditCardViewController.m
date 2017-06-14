//
//  EditCardViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/5/23.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "EditCardViewController.h"
#import "BanksViewController.h"

@interface EditCardViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *card;
@property (weak, nonatomic) IBOutlet UITextField *bank;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end

@implementation EditCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑银行卡";
    [self setLeftBackNavItem];
    self.bank.delegate = self;
    [Tools configCornerOfView:self.saveBtn with:3];
    self.view.backgroundColor = RGB(243, 240, 246);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //写你要实现的：页面跳转的相关代码
    BanksViewController *bank = [[BanksViewController alloc]init];
    bank.resultBlock = ^(NSString *name) {
        if (name.length!=0) {
            self.bank.text = name;
        }
    };
    [self.navigationController pushViewController:bank animated:YES];
    return NO;
}
- (IBAction)saveAction:(id)sender {
    if (self.card.text.length==0 || self.bank.text.length==0) {
        [MBProgressHUD showError:@"请输入卡号或者选择银行" toView:self.view];
    }else{
        if (self.block) {
            self.block(self.bank.text, self.card.text);
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    
}
- (void)tap{
    [self.card   resignFirstResponder];
}
@end
