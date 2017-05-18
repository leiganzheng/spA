//
//  SFormViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/5/8.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "SFormViewController.h"
#import "SFormTableViewCell.h"

@interface SFormViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView    *myTableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *iconSource;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *date;
@end

static NSString *const kDTMyCellIdentifier = @"myCellIdentifier";
@implementation SFormViewController
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
      
       [_myTableView registerNib:[UINib nibWithNibName:@"SFormTableViewCell" bundle:nil] forCellReuseIdentifier:kDTMyCellIdentifier];
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
    self.page = 1;
    self.date = @"2017-04";
    [self.view addSubview:self.myTableView];
    [self featchData];
}

#pragma mark - tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     [tableView tableViewDisplayWitMsg:@"暂无数据" ifNecessaryForRowCount:self.dataSource.count];
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return ((NSArray*)self.dataSource[section]).count;
    return _dataSource.count;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return 0.01;
//    }
//    return 40;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.01;
//}
//-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    if (section ==0) {
//        return  @"";
//    }else{
//        return @"-----昨天------";
//    }
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFormTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTMyCellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    SFormTableViewCell *myCell = (SFormTableViewCell*)cell;
    NSDictionary *dict = self.dataSource[indexPath.row];
    myCell.time.text = [dict objectForKey:@"pay_time"];
    myCell.price.text = [dict objectForKey:@"price"];
    NSArray *arr = (NSArray*)[dict objectForKey:@"service"];
    NSMutableString *str = [[NSMutableString alloc]init];
    for (NSDictionary *dic in arr) {
        [str appendString:[dic objectForKey:@"name"]];
    }
    myCell.name.text = str;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (void)featchDataWithDate:(NSString *)date{
    self.page = 1;
    self.date = date;
    [self featchData];
}
-(void)featchData{
    
}
@end
