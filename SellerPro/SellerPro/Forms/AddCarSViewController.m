//
//  AddCarSViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/6/8.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "AddCarSViewController.h"
#import "EmployeeTableViewCell.h"
#import "AddEmployeeViewController.h"

@interface AddCarSViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView    *myTableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSDictionary *dataDict;
@property (nonatomic, strong) NSArray *iconSource;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UILabel *sum;
@property (nonatomic, strong) UILabel *customerSum;
@property (nonatomic,strong)UIButton *btn;


@end

static NSString *const kDTMyCellIdentifier = @"myCellIdentifier";
@implementation AddCarSViewController
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
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kDTMyCellIdentifier];
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
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark - tableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dict = self.dataSource[section];
    NSArray *arr = [dict objectForKey:@"sub"];
    return arr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSDictionary *dict = self.dataSource[section];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,KSCREEN_WIDTH,40)];
    v.backgroundColor = [UIColor lightGrayColor];
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn setTitle:[dict objectForKey:@"name"] forState:UIControlStateNormal];
    _btn.frame = CGRectMake(0, 10, 60, 24);
    [_btn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:_btn];
    
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTMyCellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    NSDictionary *dict = self.dataSource[indexPath.section];
    NSArray *arr = [dict objectForKey:@"sub"];
    NSDictionary *valueDict = arr[indexPath.row];
    cell.textLabel.text = [valueDict objectForKey:@"name"];
    UIButton *temp = [UIButton buttonWithType:UIButtonTypeCustom];
    [temp setTitle:[dict objectForKey:@"name"] forState:UIControlStateNormal];
    temp.frame = CGRectMake(0, 0, 24, 24);
    cell.accessoryView = temp;
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *myCell = (UITableViewCell *)cell;
    //    myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //    NSDictionary *dict = self.dataSource[indexPath.row];
    //    myCell.name.text = [dict objectForKey:@"customer"];
    //    myCell.time.text = [dict objectForKey:@"pay_time"];
    //    myCell.logoName.text =[NSString stringWithFormat:@"消费¥:%@", [dict objectForKey:@"price"]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
}
- (void)save:(UIButton *)sender{
 
    
}

-(void)featchData{
    [DTNetManger serviceGetCategoryList:^(NSError *error, id response) {
        if (response && [response isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray*)response;
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
            if ([response  isKindOfClass:[NSString class]]) {
                [MBProgressHUD showError:(NSString *)response toView:self.view];
                [self.myTableView.mj_header endRefreshing];
                [self.myTableView.mj_footer endRefreshing];
            }
        }
        
    }];
}
@end
