//
//  StaffViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/5/8.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "StaffViewController.h"
#import "EmployeeTableViewCell.h"
#import "AddEmployeeViewController.h"
#import "FPPopoverController.h"
#import "TimeViewController.h"
#import "CarInfoDetailViewController.h"

@interface StaffViewController ()<UITableViewDelegate,UITableViewDataSource,TimeViewControllerDelegate>

@property (nonatomic, strong) UITableView    *myTableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSDictionary *dataDict;
@property (nonatomic, strong) NSArray *iconSource;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UILabel *sum;
@property (nonatomic, strong) UILabel *customerSum;
@property (nonatomic,strong) FPPopoverController*popover;
@property (nonatomic,strong)UIButton *btn;


@end

static NSString *const kDTMyCellIdentifier = @"myCellIdentifier";
@implementation StaffViewController
- (UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT-144) style:UITableViewStylePlain];
        _myTableView.rowHeight = 60;
        _myTableView.delegate   = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = [UIColor clearColor];
        _myTableView.separatorColor = [UIColor clearColor];
        _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self featchData];
            
        }];
//        _myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            [self featchData];
//        }];
        [_myTableView registerNib:[UINib nibWithNibName:@"EmployeeTableViewCell" bundle:nil] forCellReuseIdentifier:kDTMyCellIdentifier];
    }
    return _myTableView;
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
    self.title = @"个人业绩";
    
    [self.view addSubview:self.myTableView];
    [self setLeftBackNavItem];
   self.page = 1;
    self.date =[NSString stringWithFormat:@"%@-%@", [Tools nowDateofYear] , [Tools nowDateofMonth]];
    [self featchData];
    [self featchOrderSun];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark - tableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [tableView tableViewDisplayWitMsg:@"暂无数据" ifNecessaryForRowCount:self.dataSource.count];
    return self.dataSource.count;
//    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 140;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,KSCREEN_WIDTH,140)];
    v.backgroundColor = [UIColor lightGrayColor];
    
    UIImageView *img = [[UIImageView alloc] init];
    img.frame = CGRectMake(0,0,KSCREEN_WIDTH,140);
    img.image = [[UIImage imageNamed:@"Rectangle"] stretchableImageWithLeftCapWidth:1 topCapHeight:70];
    [v addSubview:img];
    
    UIView *bgV = [[UIView alloc] initWithFrame:CGRectMake(KSCREEN_WIDTH-70, 8, 60, 24)];
    bgV.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    [v addSubview:bgV];
    bgV.layer.masksToBounds = YES;
    bgV.layer.cornerRadius = 10;
    
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn setTitle:[self.date substringFromIndex:5] forState:UIControlStateNormal];
    [_btn setImage:[UIImage imageNamed:@"btn_calendar"] forState:UIControlStateNormal];
    _btn.frame = CGRectMake(0, 0, 60, 24);
    [_btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -15, 0.0, 0.0)];
    _btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_btn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [bgV addSubview:_btn];
    
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 200, 40)];
    lb.textAlignment = NSTextAlignmentLeft;
    lb.textColor = [UIColor whiteColor];
    [v addSubview:lb];
    
    UILabel *lb1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, 250, 40)];
    lb1.font = [UIFont boldSystemFontOfSize:28.0f];
    lb1.textAlignment = NSTextAlignmentLeft;
    lb1.textColor = [UIColor whiteColor];
    if (_dataDict.allKeys != 0) {
         lb.text = [NSString stringWithFormat:@"客户:%@人",_dataDict[@"count_customer"]];
        lb1.text = [NSString stringWithFormat:@"¥%@",_dataDict[@"count_money"]];
    }
    [v addSubview:lb1];
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EmployeeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTMyCellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    EmployeeTableViewCell *myCell = (EmployeeTableViewCell *)cell;
//    myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *dict = self.dataSource[indexPath.row];
    myCell.name.text = [dict objectForKey:@"customer"];
    myCell.time.text = [dict objectForKey:@"pay_time"];
    myCell.logoName.text =[NSString stringWithFormat:@"消费¥:%@", [dict objectForKey:@"price"]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.dataSource[indexPath.row];
    UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    CarInfoDetailViewController *vc = [board instantiateViewControllerWithIdentifier:@"CarInfoDetailViewController"];
    vc.customID = dict[@"id"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)save:(UIButton *)sender{
    TimeViewController *vc = [[TimeViewController alloc]init];
    vc.delegate = self;
    _popover = [[FPPopoverController alloc] initWithViewController:vc];
    _popover.contentSize = CGSizeMake(200, 300);
    _popover.arrowDirection = UIMenuControllerArrowUp;
    [_popover presentPopoverFromView:sender];

}
#pragma mark --TimeViewControllerDelegate
- (void)didSelectedDate:(NSString *)date{
//    [_btn setTitle:date forState:UIControlStateNormal];
    [_popover dismissPopoverAnimated:YES];
    self.date = date;
    [self featchOrderSun];
    [self featchData];
    
}
-(void)featchOrderSun{
    [DTNetManger orderSumWith:self.date callBack:^(NSError *error, id response) {
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary*)response;
            self.dataDict = dic;
            [self.myTableView reloadData];
        }else{
            if ([response  isKindOfClass:[NSString class]]) {
                [MBProgressHUD showError:(NSString *)response toView:self.view];
            }
        }

    }];
}
-(void)featchData{
    [DTNetManger orderGetStaffPageWith:[NSString stringWithFormat:@"%li",(long)self.page] size:@"10" date:self.date callBack:^(NSError *error, id response) {
        if (response && [response isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray*)response;
            if (self.page == 1) {
                self.dataSource = [[NSMutableArray alloc] init];
                [self.dataSource removeAllObjects];
                if (arr.count>0) {
                    [self.dataSource addObjectsFromArray:arr];
                    [_myTableView reloadData];
                }else{
                    [MBProgressHUD showError:@"暂无数据" toView:self.view];
                }
                [self.myTableView.mj_header endRefreshing];
            }else{
                if (arr.count>0) {
                    [self.dataSource addObjectsFromArray:arr];
                    self.page = self.page + 1;
                    [_myTableView reloadData];
                }else{
                    [MBProgressHUD showError:@"暂无数据" toView:self.view];
                }
                [self.myTableView.mj_footer endRefreshing];
            }
        }else{
            if ([response  isKindOfClass:[NSString class]]) {
                [MBProgressHUD showError:(NSString *)response toView:self.view];
                [self.myTableView.mj_header endRefreshing];
                [self.myTableView.mj_footer endRefreshing];
            }
        }

    }];
}
@end
