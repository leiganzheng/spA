//
//  CarGoodViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/6/1.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "CarGoodViewController.h"
#import "DTMyTableViewCell.h"
#import "AddCarSViewController.h"
#import "CarInfoTableViewCell.h"
#import "CustomFooterView.h"

@interface CarGoodViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView    *myTableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *iconSource;

@end

static NSString *const kDTMyCellIdentifier = @"myCellIdentifier";
@implementation CarGoodViewController
- (UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT-80) style:UITableViewStylePlain];
        _myTableView.rowHeight = 100;
        _myTableView.delegate   = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = [UIColor clearColor];
        _myTableView.separatorColor = [UIColor whiteColor];
        _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self featchData];
            
        }];
        [_myTableView registerNib:[UINib nibWithNibName:@"CarInfoTableViewCell" bundle:nil] forCellReuseIdentifier:kDTMyCellIdentifier];
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
    [self featchData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self featchData];
}
#pragma mark - tableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
        [btn setTitle:@"添加服务" forState:UIControlStateNormal];
        btn.backgroundColor = RGB(17, 157, 255);
        [btn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
        [v addSubview:btn];
        return v;
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTMyCellIdentifier];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarInfoTableViewCell *myCell = (CarInfoTableViewCell *)cell;
    NSDictionary *dict = self.dataSource[indexPath.row];
    myCell.name.text = [dict objectForKey:@"name"];
    myCell.price.text = [dict objectForKey:@"price"];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark -- private method
- (void)save:(UIButton *)sender{
    //    UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    AddCarSViewController *vc =[[AddCarSViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)featchData{
    [DTNetManger orderGetDetail:^(NSError *error, id response) {
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)response;
            self.dataSource = [dict objectForKey:@"service"];
            [self.myTableView reloadData];
        }else{
            
        }
        
    }];

}

@end
