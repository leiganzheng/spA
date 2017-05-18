//
//  AuthorSettingViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/5/15.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "AuthorSettingViewController.h"
#import "DTMyTableViewCell.h"

@interface AuthorSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView    *myTableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *dataSource1;
@property (nonatomic, strong) NSMutableArray *dataFlag;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end

static NSString *const kDTMyCellIdentifier = @"myCellIdentifier";
@implementation AuthorSettingViewController
- (UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT-108) style:UITableViewStyleGrouped];
        _myTableView.rowHeight = 52;
        _myTableView.delegate   = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = [UIColor clearColor];
        _myTableView.separatorColor = DT_Base_LineColor;
        [_myTableView registerClass:[MGSwipeTableCell class] forCellReuseIdentifier:kDTMyCellIdentifier];
    }
    return _myTableView;
}
- (NSArray *)dataSource1
{
    if (!_dataSource1) {
//        _dataSource = @[@[@"权限一",@"权限二",@"权限三",@"权限四"],@[@"权限一",@"权限二",@"权限三",@"权限四"]];
        _dataSource1 = @[@"权限一",@"权限二",@"权限三",@"权限四"];
        
    }
    return _dataSource1;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置权限";
    [self setLeftBackNavItem];
    _dataFlag = [[NSMutableArray alloc] initWithObjects:@"0",@"0",@"0",@"0", nil];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.myTableView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, KSCREEN_HEIGHT-108, KSCREEN_WIDTH, 44);
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    btn.backgroundColor = RGB(17, 157, 255);
    [btn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [self featchData];
    
}


#pragma mark - tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 44;
}
//-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//        return @"请指定权限组";
//}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,KSCREEN_WIDTH,44)];
    v.backgroundColor = [UIColor clearColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(KSCREEN_WIDTH-100, 7, 80, 30);
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn setTitle:@"全选" forState:UIControlStateNormal];
    [Tools configCornerOfView:btn with:3];
    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btn.layer.borderWidth = 1;
    [btn addTarget:self action:@selector(allSelect:) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:btn];
    
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(4, 0, 200, 44)];
    lb.textAlignment = NSTextAlignmentLeft;
    lb.textColor = [UIColor blackColor];
    NSDictionary *dict = self.dataSource[section];
    lb.text = [NSString stringWithFormat:@"%@权限",[dict objectForKey:@"name"]];
    [v addSubview:lb];

    
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGSwipeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTMyCellIdentifier];
   
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGSwipeTableCell *myCell = (MGSwipeTableCell *)cell;
    myCell.textLabel.text = self.dataSource1[indexPath.row];
    UIImageView *redV = [[UIImageView alloc] init];
    redV.frame = CGRectMake(0, 0, 22, 22);
    NSString *flag = self.dataFlag[indexPath.row];
    NSString *str = flag.integerValue == 0 ? @"staffmanagement_btn_option_seleted" : @"staffmanagement_btn_option_unseleted";
    redV.image = [UIImage imageNamed:str];
    [Tools configCornerOfView:redV with:3];
    cell.accessoryView = redV;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *str = self.dataFlag[indexPath.row];
    NSString *temp = str.integerValue == 0 ? @"1":@"0";
    [_dataFlag replaceObjectAtIndex:indexPath.row withObject:temp];
    [self.myTableView reloadData];
}
#pragma mark - private action
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
            [self.myTableView.mj_header endRefreshing];
        }else{
            if ([response  isKindOfClass:[NSString class]]) {
                [MBProgressHUD showError:(NSString *)response toView:self.view];
                [self.myTableView.mj_header endRefreshing];
            }
        }
    }];
}
-(void)save:(UIButton *)sender{
    
}
- (void)allSelect:(UIButton*)sender{
    _dataFlag =  [[NSMutableArray alloc] initWithObjects:@"0",@"0",@"0",@"0", nil];
    [self.myTableView reloadData];
}
@end


