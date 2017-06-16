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
#import "MGSwipeTableCell.h"

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
        _myTableView.separatorColor = [UIColor lightGrayColor];
        _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self featchData];
            
        }];
//        [_myTableView registerNib:[UINib nibWithNibName:@"CarInfoTableViewCell" bundle:nil] forCellReuseIdentifier:kDTMyCellIdentifier];
         [_myTableView registerClass:[MGSwipeTableCell class] forCellReuseIdentifier:kDTMyCellIdentifier];
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
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,177,80)];
    v.backgroundColor = [UIColor clearColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(KSCREEN_WIDTH/2-88, 20, 177, 44);
    [btn setTitle:@"添加服务" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"btn_add service1"] forState:0];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -20, 0.0, 0.0)];
    btn.backgroundColor = RGB(17, 157, 255);
    [btn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:btn];
    [Tools configCornerOfView:btn with:3];
    [Tools configCornerOfView:v with:3];
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGSwipeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTMyCellIdentifier];
    cell.backgroundColor = [UIColor whiteColor];
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 60, 60)];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.layer.masksToBounds = YES;
    lb.layer.cornerRadius = lb.bounds.size.width/2;
    lb.backgroundColor = RGB(36, 201, 216);
    lb.textColor = [UIColor whiteColor];
    lb.text = @"洗";
    [cell.contentView addSubview:lb];
    
    UILabel *lb1 = [[UILabel alloc] initWithFrame:CGRectMake(90, 30, 200, 40)];
    lb1.textAlignment = NSTextAlignmentLeft;
    lb1.textColor = [UIColor blackColor];
    lb1.text = @"洗车服务一";
    [cell.contentView addSubview:lb1];
    
    UILabel *lb2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    lb2.textAlignment = NSTextAlignmentRight;
    lb2.textColor = [UIColor redColor];
    lb2.text = @"¥200";
    cell.accessoryView = lb2;
    
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"" icon:[UIImage imageNamed:@"btn_delete service" ] backgroundColor:RGB(211, 217, 222)]];
    cell.rightSwipeSettings.transition = MGSwipeTransition3D;
    return cell;
}
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    MGSwipeTableCell *myCell = (MGSwipeTableCell *)cell;
//    NSDictionary *dict = self.dataSource[indexPath.row];
////    myCell.name.text = [dict objectForKey:@"name"];
////    myCell.price.text = [dict objectForKey:@"price"];
//}
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
//    [DTNetManger orderGetDetail:^(NSError *error, id response) {
//        if (response && [response isKindOfClass:[NSDictionary class]]) {
//            NSDictionary *dict = (NSDictionary*)response;
//            self.dataSource = [dict objectForKey:@"service"];
//            [self.myTableView reloadData];
//        }else{
//            
//        }
//        
//    }];

}

@end
