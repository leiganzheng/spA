//
//  TimeViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/5/8.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "TimeViewController.h"
#import "DTMyTableViewCell.h"

@interface TimeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView    *myTableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

static NSString *const kDTMyCellIdentifier = @"myCellIdentifier";
@implementation TimeViewController
- (UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 180, 230) style:UITableViewStylePlain];
        _myTableView.rowHeight = 40;
        _myTableView.delegate   = self;
        _myTableView.dataSource = self;
        _myTableView.separatorColor = DT_Base_LineColor;
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kDTMyCellIdentifier];
    }
    return _myTableView;
}
- (NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = @[@"2017-01",@"2017-02",@"2017-03",@"2017-04",@"2017-05",@"2017-06",@"2017-07",@"2017-08",@"2017-09",@"2017-10",@"2017-11",@"2017-12"];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择月份";
    [self setLeftBackNavItem];
    [self.view addSubview:self.myTableView];
}

#pragma mark - tableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTMyCellIdentifier];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *myCell = (UITableViewCell *)cell;
    myCell.textLabel.text = self.dataSource[indexPath.row];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate) {
        [self.delegate  didSelectedDate: self.dataSource[indexPath.row]];
    }
}
#pragma mark - private action
// 免责声明
@end
