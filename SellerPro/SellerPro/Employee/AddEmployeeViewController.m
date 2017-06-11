//
//  AddEmployeeViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/5/9.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "AddEmployeeViewController.h"
#import "DTMyTableViewCell.h"

@interface AddEmployeeViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>

@property (nonatomic, strong) UITableView    *myTableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *iconSource;

@end

static NSString *const kDTMyCellIdentifier = @"myCellIdentifier";
@implementation AddEmployeeViewController
- (UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT-114) style:UITableViewStylePlain];
        _myTableView.rowHeight = 60;
        _myTableView.delegate   = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = [UIColor clearColor];
        _myTableView.separatorColor = DT_Base_LineColor;
        [_myTableView registerClass:[DTMyTableViewCell class] forCellReuseIdentifier:kDTMyCellIdentifier];
    }
    return _myTableView;
}
- (NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = @[@"洗车",@"打蜡",@"洗车"];
    }
    return _dataSource;
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
    self.title = @"添加员工";
    [self setLeftBackNavItem];
    [self.view addSubview:self.myTableView];
    [self subview];
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
    return 100;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,KSCREEN_WIDTH,100)];
    v.backgroundColor = [UIColor clearColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 40, KSCREEN_WIDTH-40, 44);
    [btn setTitle:@"添加新项目" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:0];
    [btn setImage:[UIImage imageNamed:@"btn_add service"] forState:0];
//    btn.backgroundColor = RGB(17, 157, 255);
    [Tools configCornerOfView:btn with:3];
    [btn addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:btn];

    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTMyCellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *myCell = (UITableViewCell *)cell;
  
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"¥45" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 60, 60);
    [btn setTitleColor:[UIColor redColor] forState:0];
    myCell.accessoryView = btn;
    myCell.textLabel.text = self.dataSource[indexPath.row];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"是否删除该项目？"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"删除"
                                  otherButtonTitles:nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}
#pragma mark -- UIActionSheetDelegate method

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {//删除
    }else if(buttonIndex == 3) {
    }
    
}
#pragma mark -- private method
-(void)subview{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, KSCREEN_HEIGHT-114, KSCREEN_WIDTH/2, 60)];
    v.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:v];
    
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH/2, 60)];
    lb.textAlignment = NSTextAlignmentCenter ;
    lb.textColor = [UIColor redColor];
    lb.text = @"¥321";
    [v addSubview:lb];
  
    
    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(KSCREEN_WIDTH/2, 0, KSCREEN_WIDTH/2, 60)];
    v1.backgroundColor = RGB(17, 157, 255);
    [v addSubview:v1];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"结账" forState:UIControlStateNormal];
    btn.backgroundColor = RGB(17, 157, 255);
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.frame = CGRectMake(0, 0, KSCREEN_WIDTH/2, 60);
    [btn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [v1 addSubview:btn];
}
-(void)add:(UIButton *)sender{
    
}
-(void)featchData{
    
}
@end
