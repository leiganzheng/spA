//
//  ScanResultViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/5/23.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "ScanResultViewController.h"
#import "CarInfoViewController.h"

@interface ScanResultViewController ()
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *reTakePBtn;
@property (weak, nonatomic) IBOutlet UIImageView *customImage;
@property (weak, nonatomic) IBOutlet UITextView *tf1;
@property (weak, nonatomic) IBOutlet UITextView *tf2;
@property (weak, nonatomic) IBOutlet UITextView *tf3;
@property (weak, nonatomic) IBOutlet UITextView *tf4;
@property (weak, nonatomic) IBOutlet UITextView *tf5;
@property (weak, nonatomic) IBOutlet UITextView *tf6;
@property (weak, nonatomic) IBOutlet UITextView *tf7;
@property (weak, nonatomic) IBOutlet UIButton *resultLb;

@end

@implementation ScanResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"识别结果";
    [self setLeftBackNavItem];
    [Tools configCornerOfView:self.saveBtn with:3];
    [Tools configCornerOfView:self.reTakePBtn with:3];
    self.customImage.image = self.licenseImage;
    if (self.plate_license.length==7) {
        [self.resultLb setTitle:@"识别成功" forState:0];
        self.tf1.text = [self.plate_license substringWithRange:NSMakeRange(0,1)];
        self.tf2.text = [self.plate_license substringWithRange:NSMakeRange(1,1)];
        self.tf3.text = [self.plate_license substringWithRange:NSMakeRange(2,1)];
        self.tf4.text = [self.plate_license substringWithRange:NSMakeRange(3,1)];
        self.tf5.text = [self.plate_license substringWithRange:NSMakeRange(4,1)];
        self.tf6.text = [self.plate_license substringWithRange:NSMakeRange(5,1)];
        self.tf7.text = [self.plate_license substringWithRange:NSMakeRange(6,1)];
    }else{
        [self.resultLb setTitle:@"识别失败" forState:0];
    }
   
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)saveAction:(id)sender {
    UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    CarInfoViewController *cvc = [board instantiateViewControllerWithIdentifier:@"CarInfoViewController"];
    [self.navigationController pushViewController:cvc animated:YES];

}
- (IBAction)retakePhotoAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private method

- (void)tap{
    [_tf1 resignFirstResponder];
    [_tf2 resignFirstResponder];
    [_tf3 resignFirstResponder];
    [_tf4 resignFirstResponder];
    [_tf5 resignFirstResponder];
    [_tf6 resignFirstResponder];
    [_tf7 resignFirstResponder];
}

@end
