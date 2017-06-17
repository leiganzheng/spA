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
@property (nonatomic,strong) UITextField *tf;
@end

static NSString *const kDTMyCellIdentifier = @"myCellIdentifier";
@implementation SFormViewController
- (UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _myTableView.rowHeight = 45;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
       [tableView tableViewDisplayWitMsg:@"暂无数据" ifNecessaryForRowCount:self.dataSource.count];
    return self.dataSource.count;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 320;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,KSCREEN_WIDTH,320)];
    v.backgroundColor = RGB(243, 240, 246);
    
    UIImageView *img = [[UIImageView alloc] init];
    img.frame = CGRectMake(0,10,KSCREEN_WIDTH,140);
    img.image = [UIImage imageNamed:@"bg_bankcard_pressed"];
    [v addSubview:img];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *bank = [userDefault objectForKey:@"bank"];
    NSString *card = [userDefault objectForKey:@"card"];
    
    self.card = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 200, 40)];
    self.card.textAlignment = NSTextAlignmentLeft;
    self.card.textColor = [UIColor whiteColor];
    self.card.text = card.length==0 ? @"暂无卡号":card;
    [v addSubview:self.card];
    
    self.bank = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, 250, 40)];
     self.bank.textAlignment = NSTextAlignmentLeft;
     self.bank.text = bank.length==0 ? @"暂无银行":bank;
     self.bank.textColor = [UIColor whiteColor];
    [v addSubview: self.bank];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(KSCREEN_WIDTH-50,30, 44, 44);
    [btn1 setImage:[UIImage imageNamed:@"btn_edit bankcard"] forState:0];
    [btn1 addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:btn1];

    
    self.tf= [[UITextField alloc] init];
    self.tf.frame = CGRectMake(10, 165, KSCREEN_WIDTH-20, 44);
    self.tf.backgroundColor = [UIColor whiteColor];
    self.tf.text = self.money;
    self.tf.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //设置显示模式为永远显示(默认不显示)
    self.tf.leftViewMode = UITextFieldViewModeAlways;
    [Tools configCornerOfView:self.tf with:3];
    self.tf.layer.borderColor = RGB(211, 217, 222).CGColor;
    self.tf.layer.borderWidth = 1;
    [v addSubview:self.tf];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10,230, KSCREEN_WIDTH-20, 44);
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    btn.backgroundColor = RGB(17, 157, 255);
    [Tools configCornerOfView:btn with:3];
    [btn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:btn];
    
    UILabel *lb3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 290, KSCREEN_WIDTH, 20)];
    lb3.textAlignment = NSTextAlignmentCenter;
    lb3.font = [UIFont systemFontOfSize:16];
    lb3.textColor = [UIColor lightGrayColor];
    lb3.text = @"--------结算记录-------";
    [v addSubview:lb3];
    
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFormTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTMyCellIdentifier];
    cell.backgroundColor = RGB(243, 240, 246);
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    SFormTableViewCell *myCell = (SFormTableViewCell*)cell;
    NSDictionary *dict = self.dataSource[indexPath.row];
    myCell.time.text = [dict objectForKey:@"create_time"];
    myCell.price.text = [NSString stringWithFormat:@"¥%@",[dict objectForKey:@"money"]];
    myCell.name.text = @"";
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
-(void)save{
    if (self.tf.text.length ==0) {
         [MBProgressHUD showError:@"金额不能为空" toView:self.view];
        return;
    }
    [MBProgressHUD showMessag:@"申请中" toView:self.view];
    [DTNetManger staffWithdrawApply:self.tf.text callBack:^(NSError *error, id response) {
        [MBProgressHUD hiddenFromView:self.view];
        if (response&&[response isKindOfClass:[NSString class]]) {
            NSString *temp = (NSString *)response;
            if ([temp isEqualToString:@"success"]) {
                [MBProgressHUD showError:@"申请成功" toView:self.view];
            }else{
                [MBProgressHUD showError:temp toView:self.view];
            }
        }
    }];
}
-(void)edit{
    UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    EditCardViewController *cvc = [board instantiateViewControllerWithIdentifier:@"EditCardViewController"];
    cvc.name = self.bank.text;
     cvc.cardNum = self.card.text;
    cvc.block = ^(NSString *bank, NSString *card) {
        self.bank.text = bank;
        self.card.text = card;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //存储到UserDefault
        if (bank.length!=0&&card.length!=0) {
            [userDefaults setObject:bank forKey:@"bank"];
            [userDefaults setObject:card forKey:@"card"];
            [userDefaults synchronize];
        }
       
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
