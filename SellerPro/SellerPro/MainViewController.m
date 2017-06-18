//
//  MainViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/5/7.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "MainViewController.h"
#import "DTMyTableViewCell.h"
#import "StaffViewController.h"
#import "ProgramViewController.h"
#import "ForgetPWViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "ScanResultViewController.h"
#import "TakePhotoViewController.h"

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

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
        _dataSource = @[@"个人业绩",@"我的佣金"];
    }
    return _dataSource;
}
- (NSArray *)iconSource
{
    if (!_iconSource) {
        _iconSource = @[@"home_icon_form",@"home_btn_staff"];
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
    return 300;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,KSCREEN_WIDTH,300)];
    v.backgroundColor = [UIColor clearColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 40, KSCREEN_WIDTH-40, 44);
    [btn setTitle:@"开始接待" forState:UIControlStateNormal];
    btn.backgroundColor = RGB(17, 157, 255);
    [Tools configCornerOfView:btn with:3];
    [btn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:btn];
    
    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(0,250,KSCREEN_WIDTH,44)];
    v1.backgroundColor = [UIColor clearColor];
    
    
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(KSCREEN_WIDTH/2-5, 0, 10, 44)];
    lb.text = @"/";
    lb.textColor = [UIColor lightGrayColor];
    [v1 addSubview:lb];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(lb.frame.origin.x-90, 0, 90, 44);
    [btn1 setTitle:@"退出登录" forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor clearColor];
    btn1.titleLabel.textAlignment = NSTextAlignmentRight;
    btn1.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn1 setTitleColor:[UIColor lightGrayColor] forState:0];
    [btn1 addTarget:self action:@selector(logOut:) forControlEvents:UIControlEventTouchUpInside];
    [v1 addSubview:btn1];
    
   
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(lb.frame.origin.x+5, 0, 90, 44);
    [btn2 setTitle:@"修改密码" forState:UIControlStateNormal];
    btn2.titleLabel.textAlignment = NSTextAlignmentLeft;
    btn2.backgroundColor = [UIColor clearColor];
    btn2.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn2 setTitleColor:[UIColor lightGrayColor] forState:0];
    [btn2 addTarget:self action:@selector(mdpW:) forControlEvents:UIControlEventTouchUpInside];
    [v1 addSubview:btn2];
    [v addSubview:v1];
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
            StaffViewController *cvc = [[StaffViewController alloc]init];
            [self.navigationController pushViewController:cvc animated:YES];
        }
 
            break;
        case 1:
        {
            ProgramViewController *cvc = [[ProgramViewController alloc] init];
            [self.navigationController pushViewController:cvc animated:YES];
        }
            break;
        case 2:
        {
//            ServiceViewController *cvc = [board instantiateViewControllerWithIdentifier:@"ServiceViewController"];
//            [self.navigationController pushViewController:cvc animated:YES];
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
-(void)goOhterVC{
    StaffViewController *cvc = [[StaffViewController alloc]init];
    [self.navigationController pushViewController:cvc animated:YES];

}
-(void)save:(UIButton *)sender
{
//    UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
//    ScanResultViewController *cvc = [board instantiateViewControllerWithIdentifier:@"ScanResultViewController"];
//    [self.navigationController pushViewController:cvc animated:YES];
    TakePhotoViewController *vc = [[TakePhotoViewController alloc]init];
     vc.vc = self;
     [self.navigationController pushViewController:vc animated:YES];
}
- (void)logOut:(UIButton *)sender{
    ((AppDelegate*)[UIApplication sharedApplication].delegate).phone = @"";
    [((AppDelegate*)[UIApplication sharedApplication].delegate).myTimer invalidate];
    ((AppDelegate*)[UIApplication sharedApplication].delegate).myTimer = nil;
    UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    LoginViewController *cvc = [board instantiateViewControllerWithIdentifier:@"LoginViewController"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cvc];
    [Tools enterRootViewController:nav animated:YES];
}
-(void)mdpW:(UIButton *)sender{
     UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    ForgetPWViewController *cvc = [board instantiateViewControllerWithIdentifier:@"ForgetPWViewController"];
    [self.navigationController pushViewController:cvc animated:YES];

}
@end
