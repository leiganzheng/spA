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

@end

@implementation ScanResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"识别结果";
    [self setLeftBackNavItem];
    [Tools configCornerOfView:self.saveBtn with:3];
    [Tools configCornerOfView:self.reTakePBtn with:3];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
