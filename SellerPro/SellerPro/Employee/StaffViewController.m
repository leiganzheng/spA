//
//  StaffViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/5/8.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "StaffViewController.h"
#import "StaffInfoViewController.h"
#import "EmployeeTableViewCell.h"
#import "AddEmployeeViewController.h"

@interface StaffViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView    *myTableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *iconSource;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UILabel *sum;
@property (nonatomic, strong) UILabel *customerSum;


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
    self.date = @"2017-04";
    [self featchData];
    [self featchOrderSun];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark - tableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
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
    img.image = [UIImage imageNamed:@"staffmanagement_img_bg"];
    [v addSubview:img];
    UIButton *_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn setTitle:@"2017-04" forState:UIControlStateNormal];
    [_btn setImage:[UIImage imageNamed:@"home_btn_dropdown"] forState:UIControlStateNormal];
    _btn.frame = CGRectMake(KSCREEN_WIDTH-80, 8, 80, 44);
    _btn.titleEdgeInsets = UIEdgeInsetsMake(0, -_btn.imageView.frame.size.width - _btn.frame.size.width + _btn.titleLabel.intrinsicContentSize.width, 0, 0);
    _btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -_btn.titleLabel.frame.size.width - _btn.frame.size.width + _btn.imageView.frame.size.width);
    [_btn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    
    [v addSubview:_btn];
    
    self.sum = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 200, 40)];
    self.sum.textAlignment = NSTextAlignmentLeft;
    self.sum.textColor = [UIColor whiteColor];
    
    [v addSubview:self.sum];
    
    self.customerSum = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 250, 40)];
    self.customerSum.font = [UIFont systemFontOfSize:20.0f];
    self.customerSum.textAlignment = NSTextAlignmentLeft;
    self.customerSum.textColor = [UIColor whiteColor];

    [v addSubview:self.customerSum];
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
    StaffInfoViewController *cvc = [[StaffInfoViewController alloc] init];
    cvc.staffID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
    cvc.workStr = [dict objectForKey:@"customer_id"];
    [self.navigationController pushViewController:cvc animated:YES];
}
- (void)save:(UIButton *)sender{
 
}
-(void)featchOrderSun{
    [DTNetManger orderSumWith:@"2017-04" callBack:^(NSError *error, id response) {
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary*)response;
            self.sum.text = [NSString stringWithFormat:@"客户:%@人",dic[@"count_customer"]];
            self.customerSum.text = [NSString stringWithFormat:@"¥%@",dic[@"count_money"]];
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
