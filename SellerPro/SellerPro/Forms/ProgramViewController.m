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
    [self setLeftBackNavItem];
    self.title =@"我的佣金";
    [self.view addSubview:self.myTableView];
    self.page = 1;
    self.date = @"2017-04";
    UIButton *_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn setTitle:@"提取佣金" forState:UIControlStateNormal];
    _btn.frame = CGRectMake(0, 0, 80, 44);
    _btn.titleEdgeInsets = UIEdgeInsetsMake(0, -_btn.imageView.frame.size.width - _btn.frame.size.width + _btn.titleLabel.intrinsicContentSize.width, 0, 0);
    _btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -_btn.titleLabel.frame.size.width - _btn.frame.size.width + _btn.imageView.frame.size.width);
    [_btn addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_btn];

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
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,KSCREEN_WIDTH,80)];
    v.backgroundColor = [UIColor lightGrayColor];
    UIImageView *img = [[UIImageView alloc] init];
    img.frame = CGRectMake(0,0,KSCREEN_WIDTH,80);
    img.image = [UIImage imageNamed:@"staffmanagement_img_bg"];
    [v addSubview:img];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 40, 200, 44);
    [btn setImage:[UIImage imageNamed:@"staffmanagement_btn_add_pressed"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"staffmanagement_btn_add"] forState:UIControlStateSelected];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:btn];
    return v;
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
- (void)select:(UIButton *)sender{
    
}
-(void)featchData{
    [DTNetManger staffMoneyGetPageWith:[NSString stringWithFormat:@"%li",(long)self.page] size:@"10" callBack:^(NSError *error, id response) {
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
