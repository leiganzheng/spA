//
//  StaffInfoViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/5/8.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "StaffInfoViewController.h"
#import "DTMyTableViewCell.h"
#import "StaffInfoMdViewController.h"
#import "StaffInfoTableViewCell.h"

@interface StaffInfoViewController ()<UITableViewDelegate,UITableViewDataSource,StaffInfoMdViewControllerDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView    *myTableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *dataSource1;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (nonatomic,strong) NSString *flagStr;
@property (nonatomic,strong) NSString *flagStrH;
@property (nonatomic,strong)UITextField *nameTF;
@property(nonatomic,strong) NSString *workStrH;
@property(nonatomic,strong) NSString *typeID;
@end

static NSString *const kDTMyCellIdentifier = @"myCellIdentifier";
@implementation StaffInfoViewController
- (UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 265) style:UITableViewStylePlain];
        _myTableView.rowHeight = 52;
        _myTableView.delegate   = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = [UIColor clearColor];

       [_myTableView registerNib:[UINib nibWithNibName:@"StaffInfoTableViewCell" bundle:nil] forCellReuseIdentifier:kDTMyCellIdentifier];
    }
    return _myTableView;
}
- (NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = @[@"员工姓名",@"联系方式",@"员工职位",@"就职状态",@"设置独立权限"];
//        _dataSource1 = @[@"物件",@"13545678907",@"洗车工",@"在职",@""];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"员工信息";
//    [self setLeftBackNavItem];
    [self.view addSubview:self.myTableView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, KSCREEN_HEIGHT-108, KSCREEN_WIDTH, 44);
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    btn.backgroundColor = RGB(17, 157, 255);
    [btn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [self featchData];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 0, 20, 30);
    [btn1 setImage:[UIImage imageNamed:@"staffmanagement_btn_back"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn1];
}
-(void)back{
    if ([self updateCK]) {
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"是否放弃更改" message:nil delegate:self cancelButtonTitle:@"继续编辑" otherButtonTitles:@"放弃", nil];
        [view show];

    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 140;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,KSCREEN_WIDTH,140)];
    v.backgroundColor = [UIColor lightGrayColor];
    UIImageView *img = [[UIImageView alloc] init];
    img.frame = CGRectMake(0,0,KSCREEN_WIDTH,140);
    img.image = [UIImage imageNamed:@"staffmanagement_img_bg"];
    [v addSubview:img];
    UIButton *_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn setTitle:@"2017-04" forState:UIControlStateNormal];
    [_btn setImage:[UIImage imageNamed:@"home_btn_dropdown"] forState:UIControlStateNormal];
    _btn.frame = CGRectMake(KSCREEN_WIDTH-80, 8, 80, 44);
    _btn.titleEdgeInsets = UIEdgeInsetsMake(0, -_btn.imageView.frame.size.width - _btn.frame.size.width + _btn.titleLabel.intrinsicContentSize.width, 0, 0);
    _btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -_btn.titleLabel.frame.size.width - _btn.frame.size.width + _btn.imageView.frame.size.width);
    [_btn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    
    [v addSubview:_btn];
    
//    self.sum = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 200, 40)];
//    self.sum.textAlignment = NSTextAlignmentLeft;
//    self.sum.textColor = [UIColor whiteColor];
//    
//    [v addSubview:self.sum];
//    
//    self.customerSum = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 250, 40)];
//    self.customerSum.font = [UIFont systemFontOfSize:20.0f];
//    self.customerSum.textAlignment = NSTextAlignmentLeft;
//    self.customerSum.textColor = [UIColor whiteColor];
//    
//    [v addSubview:self.customerSum];
    return v;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StaffInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTMyCellIdentifier];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    StaffInfoTableViewCell *myCell = (StaffInfoTableViewCell *)cell;
    myCell.name.text = self.dataSource[indexPath.row];
    for (UIView *v in myCell.contentView.subviews) {
        if (v.tag == 100) {
            [v removeFromSuperview];
        }
    }
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(KSCREEN_WIDTH-230, 6, 240, 40)];
    v.tag = 100;
    NSString *str = _dataSource1[indexPath.row];
   
    if (indexPath.row == 0) {
        _nameTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, 200, 40)];
        NSString *str = _dataSource1[indexPath.row];
//        _nameTF.placeholder = @"输入姓名";
        _nameTF.text = str;
        _nameTF.textAlignment = NSTextAlignmentRight;
        _nameTF.textColor = [UIColor lightGrayColor];
        [v addSubview:_nameTF];
    }
    if (indexPath.row == 1) {
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, 200, 40)];
        lb.text = str;
        lb.textAlignment = NSTextAlignmentRight;
        lb.textColor = [UIColor lightGrayColor];
        [v addSubview:lb];
    }
    if (indexPath.row == 2) {
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, 200, 40)];
        lb.textAlignment = NSTextAlignmentRight;
        lb.textColor = [UIColor lightGrayColor];
        [v addSubview:lb];
        lb.text = self.workStr;
    }
    if (indexPath.row == 3) {
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, 200, 40)];
        lb.textAlignment = NSTextAlignmentRight;
        lb.textColor = [UIColor lightGrayColor];
        [v addSubview:lb];
        lb.text = self.flagStr.integerValue ==0 ? @"在职" : @"离职";
    }
    
   
    if (indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(200, 8, 22, 22);
        [btn setImage:[UIImage imageNamed:@"home_btn_next"] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor clearColor];
        [v addSubview:btn];

    }
//    cell.accessoryView = v;
    [myCell.contentView addSubview:v];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row ==2) {
        StaffInfoMdViewController *vc = [[StaffInfoMdViewController alloc]init];
        vc.isWorkType = YES;
        vc.cusID = self.workStr;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row ==3) {
        StaffInfoMdViewController *vc = [[StaffInfoMdViewController alloc]init];
        vc.isWorkType = NO;
        vc.cusID = self.flagStr;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row ==4) {
         [MBProgressHUD showError:@"功能开发中" toView:self.view];
        return ;
        if (self.flagStr.integerValue == 1) {
            [MBProgressHUD showError:@"离职状态，无法设置权限" toView:self.view];
        }else{
        
        }
    }

}
-(void)didSelectedData:(NSString *)data withType:(BOOL)falg{
    if (falg) {
        self.workStr = data;
    }else{
        self.flagStr = data;
    }
    [self.myTableView reloadData];
}
-(void)didSelectedData:(NSString *)data withId:(NSString *)customID{
    self.workStr = data;
    self.typeID = customID;
    [self.myTableView reloadData];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //处理返回事件
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
      NSLog(@"%@", NSStringFromClass([touch.view class]));
    UIView *v = touch.view;
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]||v.tag == 100) {//判断如果点击的是tableView的cell，就把手势给关闭了
        return NO;//关闭手势
    }//否则手势存在
    return YES;
}
#pragma mark - private action
-(void)save:(UIButton *)sender{
    if (_nameTF.text.length == 0) {
        [MBProgressHUD showError:@"输入名字" toView:self.view];
    }
    
}
- (BOOL)updateCK{
    if ([self.nameTF.text isEqualToString:self.dataSource1[0]]&&[self.workStrH isEqualToString:_workStr]&&[self.flagStr isEqualToString:self.flagStrH]) {
        return NO;
    }else{
        return YES;
    }
}
- (void)tap{
    [_nameTF resignFirstResponder];
}
-(void)featchData{
    if (self.staffID&&self.staffID.length != 0) {
        
    }
    
}
@end
