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
#import "QRCodeViewController.h"

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
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT-144) style:UITableViewStylePlain];
        _myTableView.rowHeight = 100;
        _myTableView.delegate   = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = [UIColor clearColor];
        _myTableView.separatorColor = [UIColor clearColor];
        _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self featchData];
            
        }];
        [_myTableView registerClass:[DTMyTableViewCell class] forCellReuseIdentifier:kDTMyCellIdentifier];
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
    if (self.isAdd) {
        [self setLeftBackNavItem];
        self.title = @"添加员工";
    }
    [self featchData];
}

#pragma mark - tableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
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
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,KSCREEN_WIDTH,80)];
        v.backgroundColor = [UIColor clearColor];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 40, KSCREEN_WIDTH, 44);
        [btn setImage:[UIImage imageNamed:@"staffmanagement_btn_addwork_pressed"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"staffmanagement_btn_addwork_normal"] forState:UIControlStateSelected];
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
        [v addSubview:btn];
        return v;
    }
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DTMyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTMyCellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    DTMyTableViewCell *myCell = (DTMyTableViewCell *)cell;
    myCell.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    myCell.titleLabel.textColor = DT_Base_TitleColor;
    myCell.iconView.hidden = NO;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"洗" forState:UIControlStateNormal];
    btn.backgroundColor =RGB(17, 157, 255);
    btn.frame = CGRectMake(0, 0, 60, 60);
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = btn.frame.size.width/2;
    //    btn.layer.borderColor = RGB(17, 157, 255).CGColor;
    //    btn.layer.borderWidth = 1;
    [myCell.iconView addSubview:btn];

    NSDictionary *dict = self.dataSource[indexPath.row];
    myCell.titleLabel.text = [dict objectForKey:@"name"];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isAdd) {
        NSDictionary *dict = self.dataSource[indexPath.row];
        [DTNetManger getUrlOfWorkTypeWith:[dict objectForKey:@"id"] callBack:^(NSError *error, id response) {
            if (response && [response isKindOfClass:[NSDictionary class]]) {
                UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
                QRCodeViewController *cvc = [board instantiateViewControllerWithIdentifier:@"QRCodeViewController"];
                cvc.dict = (NSDictionary *)response;
                cvc.view.backgroundColor=[UIColor colorWithWhite:0 alpha:0.4];
                //关键语句，必须有
                cvc.modalPresentationStyle = UIModalPresentationOverFullScreen;
                [self presentViewController:cvc animated:YES completion:^{
                    cvc.view.superview.backgroundColor = [UIColor clearColor];
                }];

            }else{
                [MBProgressHUD showError:error.description toView:self.view];
            }
        }];
    }else{
        NSDictionary *dict = self.dataSource[indexPath.row];
        UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
        AddWorkTypeViewController *cvc = [board instantiateViewControllerWithIdentifier:@"AddWorkTypeViewController"];
        cvc.isAdd = NO;
        cvc.nameStr = [dict objectForKey:@"name"];
         cvc.workType = [dict objectForKey:@"id"];
        [self.navigationController pushViewController:cvc animated:YES];
    }
}
#pragma mark -- private method
- (void)save:(UIButton *)sender{
    UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    AddWorkTypeViewController *cvc = [board instantiateViewControllerWithIdentifier:@"AddWorkTypeViewController"];
    cvc.isAdd = YES;
    [self.navigationController pushViewController:cvc animated:YES];
}
-(void)featchData{
    [DTNetManger workStypeListWithCallBack:^(NSError *error, id response) {
        if (response && [response isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray*)response;
            if (arr.count>0) {
                self.dataSource = [NSArray arrayWithArray:(NSArray*)response];
                [_myTableView reloadData];
            }else{
                [MBProgressHUD showError:@"暂无数据" toView:self.view];
            }
        }else{
            if ([response  isKindOfClass:[NSString class]]) {
                [MBProgressHUD showError:(NSString *)response toView:self.view];
            }
        }
    }];
}
@end

