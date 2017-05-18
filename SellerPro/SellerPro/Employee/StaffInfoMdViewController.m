//
//  StaffInfoMdViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/5/14.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "StaffInfoMdViewController.h"
#import "DTMyTableViewCell.h"

@interface StaffInfoMdViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView    *myTableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *flagArr;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (nonatomic, strong) NSMutableArray *dataFlag;

@end

static NSString *const kDTMyCellIdentifier = @"myCellIdentifier";
@implementation StaffInfoMdViewController
- (UITableView *)myTableView
{
    if (!_myTableView) {
        if (_isWorkType) {
            _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 104) style:UITableViewStylePlain];

        }else{
            _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 104) style:UITableViewStylePlain];

        }
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
        if (_isWorkType) {
//            _dataSource = @[@"洗车工",@"维修工"];
        }else{
            _dataSource = @[@"在职",@"离职"];
            if (_cusID.integerValue == 0) {
                 _flagArr = @[@"0",@"1"];
            }else{
                _flagArr = @[@"1",@"0"];
            }
           
        }
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
//    [self.view addSubview:btn];
    if (_isWorkType) {
        self.title = @"选择职位";
        [self featchData];
    }else{
        self.title = @"设置工作状态";
    }
}
-(void)save:(UIButton *)sender{
    
}

#pragma mark - tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGSwipeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTMyCellIdentifier];
    if (indexPath.section == 0) {
        UIImageView *redV = [[UIImageView alloc] init];
        redV.frame = CGRectMake(0, 0, 22, 22);
        if (!_isWorkType) {
            NSString *str = ((NSString *)self.flagArr[indexPath.row]).integerValue == 0 ? @"staffmanagement_btn_option_seleted" : @"staffmanagement_btn_option_unseleted";
            redV.image = [UIImage imageNamed:str];
        }else{
            NSString *flag = self.dataFlag[indexPath.row];
            NSString *str = flag.integerValue == 0 ? @"staffmanagement_btn_option_seleted" : @"staffmanagement_btn_option_unseleted";
            redV.image = [UIImage imageNamed:str];
        }
        [Tools configCornerOfView:redV with:3];
        cell.accessoryView = redV;

        
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGSwipeTableCell *myCell = (MGSwipeTableCell *)cell;
    if (_isWorkType) {
        NSDictionary *dict = self.dataSource[indexPath.row];
        myCell.textLabel.text = [dict objectForKey:@"name"];
    }else{
        myCell.textLabel.text = self.dataSource[indexPath.row];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_isWorkType) {
        if (self.delegate) {
            NSDictionary *dict = self.dataSource[indexPath.row];
            [self.delegate  didSelectedData: [dict objectForKey:@"name"] withId:[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]]];
        }
    }else{
        if (indexPath.row == 0) {
            if (self.delegate) {
                [self.delegate  didSelectedData: @"0" withType:NO];
            }
        }else{
            if (self.delegate) {
                [self.delegate  didSelectedData: @"1" withType:NO];
            }
        }
        
    }
    [self.myTableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - private action
-(void)featchData{
    [DTNetManger workStypeListWithCallBack:^(NSError *error, id response) {
        if (response && [response isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray*)response;
            if (arr.count>0) {
                _dataFlag = [NSMutableArray array];
                 self.dataSource = [NSArray arrayWithArray:(NSArray*)response];
                for (NSDictionary *dic in self.dataSource) {
                    NSString *str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
                    if ([str isEqualToString:_cusID]) {
                        [_dataFlag addObject:@"0"];
                    }else{
                        [_dataFlag addObject:@"1"];
                    }
                }
                _myTableView.frame = CGRectMake(0, 0, KSCREEN_WIDTH, 52*self.dataSource.count) ;
            }else{
                [MBProgressHUD showError:@"暂无数据" toView:self.view];
            }
            [self.myTableView reloadData];
        }else{
            if ([response  isKindOfClass:[NSString class]]) {
                [MBProgressHUD showError:(NSString *)response toView:self.view];
                
            }
        }
    }];
}

@end

