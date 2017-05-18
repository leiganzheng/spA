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
@property (nonatomic, assign) NSInteger page;

@end

static NSString *const kDTMyCellIdentifier = @"myCellIdentifier";
@implementation StaffViewController
- (UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT-144) style:UITableViewStylePlain];
        _myTableView.rowHeight = 90;
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
    [self.view addSubview:self.myTableView];
   self.page = 1;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self featchData];
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
    return 80;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,KSCREEN_WIDTH,80)];
    v.backgroundColor = [UIColor clearColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 40, KSCREEN_WIDTH, 44);
    [btn setImage:[UIImage imageNamed:@"staffmanagement_btn_add_pressed"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"staffmanagement_btn_add"] forState:UIControlStateSelected];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:btn];
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
    myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *dict = self.dataSource[indexPath.row];
    myCell.name.text = [dict objectForKey:@"name"];
    myCell.time.text = [dict objectForKey:@"create_time"];
    myCell.logoName.text = [dict objectForKey:@"work_type"];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.dataSource[indexPath.row];
    StaffInfoViewController *cvc = [[StaffInfoViewController alloc] init];
    cvc.staffID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
    cvc.workStr = [dict objectForKey:@"work_type"];
    [self.navigationController pushViewController:cvc animated:YES];
}
- (void)save:(UIButton *)sender{
 
}
-(void)featchData{
//    [DTNetManger StaffPageWith:[NSString stringWithFormat:@"%li",(long)self.page] size:@"10" callBack:^(NSError *error, id response) {
//        if (response && [response isKindOfClass:[NSArray class]]) {
//            NSArray *arr = (NSArray*)response;
//            if (self.page == 1) {
//                self.dataSource = [[NSMutableArray alloc] init];
//                [self.dataSource removeAllObjects];
//                if (arr.count>0) {
//                    [self.dataSource addObjectsFromArray:arr];
//                    [_myTableView reloadData];
//                }else{
//                    [MBProgressHUD showError:@"暂无数据" toView:self.view];
//                }
//                [self.myTableView.mj_header endRefreshing];
//            }else{
//                if (arr.count>0) {
//                    [self.dataSource addObjectsFromArray:arr];
//                    self.page = self.page + 1;
//                    [_myTableView reloadData];
//                }else{
//                    [MBProgressHUD showError:@"暂无数据" toView:self.view];
//                }
//                [self.myTableView.mj_footer endRefreshing];
//            }
//        }else{
//            if ([response  isKindOfClass:[NSString class]]) {
//                [MBProgressHUD showError:(NSString *)response toView:self.view];
//                [self.myTableView.mj_header endRefreshing];
//                [self.myTableView.mj_footer endRefreshing];
//            }
//        }
//    }];
}
@end
