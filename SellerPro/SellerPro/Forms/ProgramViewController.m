//
//  ProgramViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/5/8.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "ProgramViewController.h"
#import "SprogramTableViewCell.h"

@interface ProgramViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView    *myTableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *iconSource;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *date;

@end

static NSString *const kDTMyCellIdentifier = @"myCellIdentifier";
@implementation ProgramViewController
- (UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT) style:UITableViewStylePlain];
        _myTableView.rowHeight = 90;
        _myTableView.delegate   = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = [UIColor clearColor];
        _myTableView.separatorColor = [UIColor clearColor];
        _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self featchData];
            
        }];
        _myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self featchData];
        }];
        _myTableView.mj_footer.hidden = YES;

       [_myTableView registerNib:[UINib nibWithNibName:@"SprogramTableViewCell" bundle:nil] forCellReuseIdentifier:kDTMyCellIdentifier];
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
    self.date = @"2017-04";
    [self featchData];
}

#pragma mark - tableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     [tableView tableViewDisplayWitMsg:@"暂无数据" ifNecessaryForRowCount:self.dataSource.count];
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SprogramTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTMyCellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    SprogramTableViewCell *myCell = (SprogramTableViewCell*)cell;
    NSDictionary *dict = self.dataSource[indexPath.row];
    myCell.name.text = [dict objectForKey:@"name"];
        myCell.price.text = [dict objectForKey:@"order_sum"];
        myCell.logo.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"order_count"]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (void)featchDataWithDate:(NSString *)date{
    self.date = date;
    self.page = 1;
    [self featchData];
}
-(void)featchData{
   
}

@end
