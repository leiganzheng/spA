//
//  CarInfoViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/5/30.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "CarInfoViewController.h"
#import "ServiceViewController.h"

@interface CarInfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profile;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *baoxian;
@property (weak, nonatomic) IBOutlet UILabel *weizhang;
@property (weak, nonatomic) IBOutlet UILabel *nianjian;

@end

@implementation CarInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"车辆概况";
    [self setLeftBackNavItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)recordService:(id)sender {
    ServiceViewController *vc = [[ServiceViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
