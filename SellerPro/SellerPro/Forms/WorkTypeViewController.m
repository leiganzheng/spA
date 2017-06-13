//
//  WorkTypeViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/5/8.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "WorkTypeViewController.h"
#import "DTMyTableViewCell.h"
#import "AddWorkTypeViewController.h"
#import "WorkTypeTableViewCell.h"
#import "CustomFooterView.h"
#import "ScanAddViewController.h"

@interface WorkTypeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView    *myTableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *iconSource;

@end

static NSString *const kDTMyCellIdentifier = @"myCellIdentifier";
@implementation WorkTypeViewController
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
        [_myTableView registerNib:[UINib nibWithNibName:@"WorkTypeTableViewCell" bundle:nil] forCellReuseIdentifier:kDTMyCellIdentifier];
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
    if (self.isAdd){
        return 0.01;
    }
    return 80;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (!self.isAdd) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,177,80)];
        v.backgroundColor = [UIColor clearColor];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(KSCREEN_WIDTH/2-88, 20, 177, 44);
        [btn setTitle:@"添加商品" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"btn_scanning barcode"] forState:0];
        btn.backgroundColor = RGB(17, 157, 255);
        [btn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
        [v addSubview:btn];
        [Tools configCornerOfView:btn with:3];
        [Tools configCornerOfView:v with:3];

        return v;

    }
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTMyCellIdentifier];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkTypeTableViewCell *myCell = (WorkTypeTableViewCell *)cell;
    NSDictionary *dict = self.dataSource[indexPath.row];
    myCell.nameTitel.text = [dict objectForKey:@"name"];
    myCell.price.text = [NSString stringWithFormat:@"¥%@",[dict objectForKey:@"price"]];
    [myCell.img sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"picture"]] placeholderImage:[UIImage imageNamed:@"" ]];
    [myCell.resultBtn setTitle:[NSString stringWithFormat:@"¥%@",[dict objectForKey:@"quantity"]] forState:0];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark -- private method
- (void)save:(UIButton *)sender{
//    UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
//    AddWorkTypeViewController *vc =[[AddWorkTypeViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    ScanAddViewController *vc = [[ScanAddViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)featchData{
    [DTNetManger orderGetDetail:^(NSError *error, id response) {
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)response;
            self.dataSource = [dict objectForKey:@"good"];
            [self.myTableView reloadData];
        }else{
            
        }

    }];
}
@end

