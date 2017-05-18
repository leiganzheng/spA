//
//  MainViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/5/7.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "MainViewController.h"
#import "DTMyTableViewCell.h"
#import "EmployeeViewController.h"
#import "FromsMViewController.h"
#import "ServiceViewController.h"
#import "ForgetPWViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView    *myTableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *iconSource;

@end

static NSString *const kDTMyCellIdentifier = @"myCellIdentifier";
@implementation MainViewController
- (UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT) style:UITableViewStylePlain];
        _myTableView.rowHeight = 100;
        _myTableView.delegate   = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = [UIColor clearColor];
        _myTableView.separatorColor = [UIColor clearColor];
        [_myTableView registerClass:[DTMyTableViewCell class] forCellReuseIdentifier:kDTMyCellIdentifier];
    }
    return _myTableView;
}
- (NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = @[@"业绩报表",@"员工管理",@"服务项目",@"密码设置"];
    }
    return _dataSource;
}
- (NSArray *)iconSource
{
    if (!_iconSource) {
        _iconSource = @[@"home_icon_form",@"home_btn_staff",@"home_btn_servement",@"home_btn_password_setting"];
    }
    return _iconSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    [self.view addSubview:self.myTableView];

}

#pragma mark - tableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,KSCREEN_WIDTH,100)];
    v.backgroundColor = [UIColor clearColor];
    
    UIImageView * im= [[UIImageView alloc] init];
    im.frame = CGRectMake((KSCREEN_WIDTH - 150)/2, 40, 150, 28);
    im.image = [UIImage imageNamed:@"home_img_92logo"];
    [v addSubview:im];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((KSCREEN_WIDTH - 150)/2, im.frame.size.height+30, 150, 44);
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor clearColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor lightGrayColor] forState:0];
    [btn addTarget:self action:@selector(logOut:) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:btn];
    return v;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DTMyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTMyCellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    DTMyTableViewCell *myCell = (DTMyTableViewCell *)cell;
    myCell.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    myCell.titleLabel.textColor = DT_Base_TitleColor;
    myCell.iconView.hidden = NO;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
   
    myCell.iconView.image = [UIImage imageNamed:self.iconSource[indexPath.row]];
    myCell.titleLabel.text = self.dataSource[indexPath.row];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    switch (indexPath.row) {
        case 0:
        {
            FromsMViewController *cvc = [board instantiateViewControllerWithIdentifier:@"FromsMViewController"];
            [self.navigationController pushViewController:cvc animated:YES];
        }
 
            break;
        case 1:
        {
            EmployeeViewController *cvc = [board instantiateViewControllerWithIdentifier:@"EmployeeViewController"];
            [self.navigationController pushViewController:cvc animated:YES];
        }
            break;
        case 2:
        {
            ServiceViewController *cvc = [board instantiateViewControllerWithIdentifier:@"ServiceViewController"];
            [self.navigationController pushViewController:cvc animated:YES];
        }
  
            break;
        case 3:
        {
            ForgetPWViewController *cvc = [board instantiateViewControllerWithIdentifier:@"ForgetPWViewController"];
            [self.navigationController pushViewController:cvc animated:YES];
        }
  
            break;
            
        default:
            break;
    }

}
#pragma mark - private action
- (void)logOut:(UIButton *)sender{
    ((AppDelegate*)[UIApplication sharedApplication].delegate).phone = @"";
    [((AppDelegate*)[UIApplication sharedApplication].delegate).myTimer invalidate];
    ((AppDelegate*)[UIApplication sharedApplication].delegate).myTimer = nil;
    UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    LoginViewController *cvc = [board instantiateViewControllerWithIdentifier:@"LoginViewController"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cvc];
    [Tools enterRootViewController:nav animated:YES];
}
@end
