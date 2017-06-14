//
//  SFormViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/5/8.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "SFormViewController.h"
#import "SFormTableViewCell.h"
#import "EditCardViewController.h"

@interface SFormViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView    *myTableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *iconSource;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) UILabel *card;
@property (nonatomic, strong) UILabel *bank;
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
    self.title = @"申请结算";
    [self setLeftBackNavItem];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 260;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,KSCREEN_WIDTH,260)];
    v.backgroundColor = RGB(243, 240, 246);
    
    UIImageView *img = [[UIImageView alloc] init];
    img.frame = CGRectMake(0,10,KSCREEN_WIDTH,140);
    img.image = [UIImage imageNamed:@"bg_bankcard_pressed"];
    [v addSubview:img];
    
    
    self.card = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, 200, 40)];
    self.card.textAlignment = NSTextAlignmentLeft;
    self.card.textColor = [UIColor whiteColor];
    self.card.text = @"88888888*****88888";
    [v addSubview:self.card];
    
    self.bank = [[UILabel alloc] initWithFrame:CGRectMake(15, 90, 250, 40)];
     self.bank.textAlignment = NSTextAlignmentLeft;
     self.bank.text = @"中国招商银行";
     self.bank.textColor = [UIColor whiteColor];
    [v addSubview: self.bank];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(KSCREEN_WIDTH-30,30, 15, 44);
    [btn1 setImage:[UIImage imageNamed:@"btn_edit bankcard"] forState:0];
    [btn1 addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:btn1];

    
    UITextField *tf = [[UITextField alloc] init];
    tf.frame = CGRectMake(10, 155, KSCREEN_WIDTH-20, 30);
    tf.backgroundColor = [UIColor whiteColor];
    tf.text = @"¥88";
    [Tools configCornerOfView:tf with:3];
    tf.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tf.layer.borderWidth = 1;
    [v addSubview:tf];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10,200, KSCREEN_WIDTH-20, 44);
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    btn.backgroundColor = RGB(17, 157, 255);
    [Tools configCornerOfView:btn with:3];
//    [btn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:btn];
    
    UILabel *lb3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 255, KSCREEN_WIDTH-20, 20)];
    lb3.textAlignment = NSTextAlignmentCenter;
    lb3.textColor = [UIColor blackColor];
    lb3.text = @"--------结算记录-------";
    [v addSubview:lb3];
    
    return v;
}

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
-(void)edit{
    UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    EditCardViewController *cvc = [board instantiateViewControllerWithIdentifier:@"EditCardViewController"];
    cvc.block = ^(NSString *bank, NSString *card) {
        self.bank.text = bank;
        self.card.text = card;
    };
    [self.navigationController pushViewController:cvc animated:YES];
}
-(void)featchData{
    [DTNetManger staffWithdrawGetPageWith:[NSString stringWithFormat:@"%li",(long)self.page] size:@"10" callBack:^(NSError *error, id response) {
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
