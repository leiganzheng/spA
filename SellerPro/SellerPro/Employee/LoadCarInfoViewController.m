//
//  LoadCarInfoViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/6/15.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "LoadCarInfoViewController.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "CarInfoViewController.h"

@interface LoadCarInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView    *myTableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSMutableArray *data;
@property (weak, nonatomic) IBOutlet UIImageView *imgeV;

@property (weak, nonatomic) IBOutlet UILabel *plase_num;
@property (nonatomic,strong)UIView *mask;
@property (nonatomic, strong) IQKeyboardReturnKeyHandler    *returnKeyHandler;

@property (nonatomic, strong)NSString *name ;
@property (nonatomic, strong)NSString *car_type;

@end
static NSString *const kDTMyCellIdentifier = @"myCellIdentifier";
@implementation LoadCarInfoViewController
- (UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 125, KSCREEN_WIDTH, KSCREEN_HEIGHT-184) style:UITableViewStylePlain];
        _myTableView.rowHeight = 50;
        _myTableView.delegate   = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = [UIColor clearColor];
        _myTableView.separatorColor = [UIColor clearColor];
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kDTMyCellIdentifier];
    }
    return _myTableView;
}
- (NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = @[@" 车主姓名",@" 联系方式",@" 车辆类型",@" 车辆品牌",@" 车辆型号",@" 车牌号",@" 发动机号",@" 车架号",@" 注册日期",@" 行驶证照片",@" 年检地点",@" 年检到期时间",@" 保险公司名称",@" 保险到期时间"];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftBackNavItem];
    [self.view addSubview:self.myTableView];
    self.imgeV.backgroundColor = RGB(211, 217, 222);
    self.imgeV.contentMode = UIViewContentModeScaleAspectFit;
    self.imgeV.image = self.licenseImage;
    
    self.title =@"资料补充";
    self.data = [NSMutableArray array];
    self.plate_license = @"粤S777ML";
    self.plase_num.backgroundColor = RGB(211, 217, 222);
    [Tools configCornerOfView:_plase_num with:3];
    _plase_num.layer.borderColor = RGB(211, 217, 222).CGColor;
    _plase_num.layer.borderWidth = 1;
    [self maskView];
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
    
    UIButton *_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn setTitle:@"跳过" forState:UIControlStateNormal];
    _btn.frame = CGRectMake(0, 0, 60, 44);
    [_btn addTarget:self action:@selector(select) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_btn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,KSCREEN_WIDTH,80)];
    v.backgroundColor = RGB(242, 246, 249);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15,18, KSCREEN_WIDTH-30, 44);
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    btn.backgroundColor = RGB(17, 157, 255);
    [Tools configCornerOfView:btn with:3];
    [btn addTarget:self action:@selector(loadData) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:btn];
    
    return v;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTMyCellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.dataSource[indexPath.row];
    for (UIView *f in cell.contentView.subviews) {
        if ([f isKindOfClass:[UITextField class]]) {
            [f removeFromSuperview];
        }
    }
    UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(15, 3, KSCREEN_WIDTH-30, 44)];
    [cell.contentView addSubview:tf];
    tf.backgroundColor = [UIColor whiteColor];
    [Tools configCornerOfView:tf with:3];
    tf.placeholder = self.dataSource[indexPath.row];
    tf.layer.borderColor = RGB(211, 217, 222).CGColor;
    tf.layer.borderWidth = 1;
    return cell;
}

- (IBAction)submitAction:(id)sender {
    [self loadData];
    
}
-(void)maskView{
     self.mask= [[UIView alloc] initWithFrame:self.view.frame];
    self.mask.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5f];
    self.mask.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.mask addGestureRecognizer:tap];

    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 236, 300)];
    imageV.center = CGPointMake( self.mask.center.x,  self.mask.center.y-50);
    imageV.backgroundColor = [UIColor clearColor];
    imageV.image = [UIImage imageNamed:@"Group 2"];
    [ self.mask addSubview:imageV];
    
    UITextView *tf = [[UITextView alloc] initWithFrame:CGRectMake(58, 100, 140, 60)];
    tf.textColor = [UIColor whiteColor];
    tf.backgroundColor = [UIColor clearColor];
    tf.text = @"提交成功，感谢您的录入，您将获得来自92汽车俱乐部的佣金！";
    [imageV addSubview:tf];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(36, 200, 80, 40);
    [btn setTitle:@"我的业绩" forState:0];
    btn.center = CGPointMake(imageV.center.x, 180);
    [imageV addSubview:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(36, 240, 80, 40);
    btn1.center = CGPointMake(imageV.center.x, 220);
    [btn1 setTitle:@"回首页" forState:0];
    [btn1 addTarget:self action:@selector(homeAction) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:btn1];
    [self.view addSubview: self.mask];
}
-(void)homeAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)tap{
    self.mask.hidden = YES;
}
-(void)select{
    [self dismissViewControllerAnimated:NO completion:^{
        UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
        CarInfoViewController *cvc = [board instantiateViewControllerWithIdentifier:@"CarInfoViewController"];
        cvc.plate_license = self.plate_license;
        [self.vc.navigationController pushViewController:cvc animated:YES];
    }];
}
-(void)loadData{
    
    if (self.name.length ==0 ||self.car_type.length ==0 ||self.plate_license.length ==0) {
        [MBProgressHUD showError:@"请输入内容" toView:self.view];
    }else{
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        [dict setObject:_nametf.text forKey:@"name"];
//        [dict setObject:_phonetf.text forKey:@"phone"];
//        [dict setObject:self.plate_license forKey:@"plate_license"];
//        [dict setObject:_fdhTF.text forKey:@"engine_number"];
//        [dict setObject:_cjhTF.text forKey:@"frame_number"];
    
        [MBProgressHUD showMessag:@"提交中" toView:self.view];
        [DTNetManger customerAddWith:dict callBack:^(NSError *error, id response) {
            [MBProgressHUD hiddenFromView:self.view];
            if (response&&[response isKindOfClass:[NSString class]]) {
                NSString *temp = (NSString *)response;
                if ([temp isEqualToString:@"success"]) {
                    self.mask.hidden = NO;
                }
            }
        }];
    }
   
}
@end
