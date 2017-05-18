//
//  DddSeviceViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/5/8.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "DddSeviceViewController.h"
#import "DTMyTableViewCell.h"

@interface DddSeviceViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView    *myTableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *dataSource1;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (nonatomic,strong)UITextField *nameTF;
@property (nonatomic,strong)UITextField *priceTF;
@end

static NSString *const kDTMyCellIdentifier = @"myCellIdentifier";
@implementation DddSeviceViewController
- (UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 104) style:UITableViewStylePlain];
        _myTableView.rowHeight = 52;
        _myTableView.delegate   = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = [UIColor clearColor];
        _myTableView.separatorColor = DT_Base_LineColor;
        [_myTableView registerClass:[MGSwipeTableCell class] forCellReuseIdentifier:kDTMyCellIdentifier];
    }
    return _myTableView;
}
- (NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = @[@"项目名称",@"单价(元／次)"];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLeftBackNavItem];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.myTableView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, KSCREEN_HEIGHT-108, KSCREEN_WIDTH, 44);
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    btn.backgroundColor = RGB(17, 157, 255);
    [btn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    if (self.dict == nil) {
        self.title = @"添加服务资料";
    }else{
        self.title = @"修改服务资料";
        self.dataSource1 = @[[_dict objectForKey:@"name"],[NSString stringWithFormat:@"%@",[_dict objectForKey:@"price"]]];
        [self.myTableView reloadData];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
   
}
-(void)save:(UIButton *)sender{
    if (self.nameTF.text.length == 0) {
        [MBProgressHUD showError:@"请输入姓名" toView:self.view];
    }
    if (self.priceTF.text.length == 0) {
        [MBProgressHUD showError:@"请输入价格" toView:self.view];
    }
    [DTNetManger addServiceWith:[_dict objectForKey:@"id"] categoryId:self.cId name:self.nameTF.text price:self.priceTF.text callBack:^(NSError *error, id response) {
        if (response && [response isKindOfClass:[NSString class]]) {
            NSString *str = (NSString*)response;
            if (str.integerValue == 0) {
                [MBProgressHUD showError:@"成功" toView:self.view];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                 [MBProgressHUD showError:@"失败" toView:self.view];
            }
        }else{
            [MBProgressHUD showError:[(NSDictionary*)response objectForKey:@"msg"] toView:self.view];
        }
    }];
}

#pragma mark - tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGSwipeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTMyCellIdentifier];
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(4, 6, 200, 40)];
    lb.text = _dataSource[indexPath.row];
    lb.textAlignment = NSTextAlignmentLeft;
    lb.textColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:lb];

        if (indexPath.row == 0) {
            _nameTF = [[UITextField alloc] initWithFrame:CGRectMake(KSCREEN_WIDTH-210, 6, 200, 40)];
            NSString *str = _dataSource1[indexPath.row];
            _nameTF.placeholder = @"输入姓名";
            _nameTF.text = str;
            _nameTF.textAlignment = NSTextAlignmentRight;
            _nameTF.textColor = [UIColor lightGrayColor];
             [cell.contentView addSubview:_nameTF];
        }
        if (indexPath.row == 1) {
            _priceTF = [[UITextField alloc] initWithFrame:CGRectMake(KSCREEN_WIDTH-210, 6, 200, 40)];
            NSString *str = _dataSource1[indexPath.row];
            _priceTF.text = str;
            _priceTF.placeholder = @"输入价格";
            _priceTF.textAlignment = NSTextAlignmentRight;
            _priceTF.textColor = [UIColor lightGrayColor];
             [cell.contentView addSubview:_priceTF];
        }
   
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark - private action
- (void)tap{
    [_priceTF resignFirstResponder];
    [_nameTF resignFirstResponder];
}
- (void)featchData{
//    [DTNetManger getServiceInfoWith:self.cId callBack:^(NSError *error, id response) {
//        if (response && [response isKindOfClass:[NSArray class]]) {
//            NSDictionary *dict = (NSDictionary*)response;
//            if (dict.allKeys.count>0) {
//                self.dataSource1 = @[[dict objectForKey:@"name"],[NSString stringWithFormat:@"%@",[dict objectForKey:@"price"]]];
//                [_myTableView reloadData];
//            }else{
//                [MBProgressHUD showError:@"暂无数据" toView:self.view];
//            }
//        }else{
//            if ([response  isKindOfClass:[NSString class]]) {
//                [MBProgressHUD showError:(NSString *)response toView:self.view];
//            }
//        }
//    }];
}
@end

