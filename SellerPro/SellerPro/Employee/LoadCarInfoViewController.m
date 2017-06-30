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

@interface LoadCarInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView    *myTableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSMutableArray *data;
@property (weak, nonatomic) IBOutlet UIImageView *imgeV;

@property (weak, nonatomic) IBOutlet UILabel *plase_num;
@property (nonatomic,strong)UIView *mask;
@property (nonatomic, strong) IQKeyboardReturnKeyHandler    *returnKeyHandler;

@property (nonatomic, strong)NSString *name ;
@property (nonatomic, strong)NSString *car_type;
@property (nonatomic, strong)NSMutableDictionary *dataDict;
@end
@implementation LoadCarInfoViewController
- (UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 125, KSCREEN_WIDTH, KSCREEN_HEIGHT-240) style:UITableViewStylePlain];
        _myTableView.rowHeight = 50;
        _myTableView.delegate   = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = [UIColor clearColor];
        _myTableView.separatorColor = [UIColor clearColor];
//        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kDTMyCellIdentifier];
    }
    return _myTableView;
}
- (NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = @[@" 车主姓名",@" 联系方式（必填）",@" 车辆类型（必填）",@" 车辆品牌",@" 车辆型号",@" 车牌号（必填）",@" 发动机号",@" 车架号",@" 注册日期",@" 行驶证照片",@" 年检地点",@" 年检到期时间",@" 保险公司名称",@" 保险到期时间"];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.myTableView];
    self.imgeV.backgroundColor = RGB(211, 217, 222);
    self.imgeV.contentMode = UIViewContentModeScaleAspectFit;
    self.imgeV.image = self.licenseImage;
    
    self.title =@"资料补充";
//    self.data = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
    self.dataDict = [NSMutableDictionary dictionary];
//    self.plate_license = @"粤S777ML";
    self.plase_num.backgroundColor = RGB(211, 217, 222);
    self.plase_num.text = self.plate_license.length==0 ? @"无数据": self.plate_license;
    [Tools configCornerOfView:_plase_num with:3];
    _plase_num.layer.borderColor = RGB(211, 217, 222).CGColor;
    _plase_num.layer.borderWidth = 1;
   
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
    
    UIButton *_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn setTitle:@"跳过" forState:UIControlStateNormal];
    _btn.frame = CGRectMake(0, 0, 60, 44);
    [_btn addTarget:self action:@selector(select) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_btn];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"staffmanagement_btn_back"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 30, 44);
    [btn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(15,KSCREEN_HEIGHT-114, KSCREEN_WIDTH-30, 44);
    [btn2 setTitle:@"提交" forState:UIControlStateNormal];
    btn2.backgroundColor = RGB(17, 157, 255);
    [Tools configCornerOfView:btn2 with:3];
    [btn2 addTarget:self action:@selector(loadData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
     [self maskView];
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
    return 0.01;
}
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,KSCREEN_WIDTH,80)];
//    v.backgroundColor = RGB(242, 246, 249);
//    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(15,18, KSCREEN_WIDTH-30, 44);
//    [btn setTitle:@"提交" forState:UIControlStateNormal];
//    btn.backgroundColor = RGB(17, 157, 255);
//    [Tools configCornerOfView:btn with:3];
//    [btn addTarget:self action:@selector(loadData) forControlEvents:UIControlEventTouchUpInside];
//    [v addSubview:btn];
//    
//    return v;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     NSString *CMainCell = [NSString stringWithFormat:@"CMainCell%li",(long)indexPath.row];     //  0
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CMainCell];  //  1
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: CMainCell];// 2
        UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(15, 3, KSCREEN_WIDTH-30, 44)];
        [cell.contentView addSubview:tf];
        tf.delegate = self;
        tf.backgroundColor = [UIColor whiteColor];
        [Tools configCornerOfView:tf with:3];
        tf.placeholder = self.dataSource[indexPath.row];
        tf.layer.borderColor = RGB(211, 217, 222).CGColor;
        tf.layer.borderWidth = 1;
        tf.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 12, 0)];
        //设置显示模式为永远显示(默认不显示)
        tf.leftViewMode = UITextFieldViewModeAlways;

    }
   
    return cell;
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //get cell
    UITableViewCell *cell  = (UITableViewCell *)[[textField superview] superview];
    NSIndexPath *indexPath = [self.myTableView indexPathForCell:cell];
    switch (indexPath.row) {
        case 0:
    
            [self.dataDict setObject:textField.text forKey:@"name"];
            break;
        case 1:
            self.name = textField.text;
            [self.dataDict setObject:textField.text forKey:@"phone"];
            break;
        case 2:
            self.car_type = textField.text;
            [self.dataDict setObject:textField.text forKey:@"car_type"];
            break;
        case 3:
            [self.dataDict setObject:textField.text forKey:@"car_band"];
            break;
        case 4:
            [self.dataDict setObject:textField.text forKey:@"car_model"];
            break;
        case 5:
            self.plate_license = textField.text;
            [self.dataDict setObject:textField.text forKey:@"plate_license"];
            break;
        case 6:
            [self.dataDict setObject:textField.text forKey:@"engine_number"];
            break;
        case 7:
            [self.dataDict setObject:textField.text forKey:@"frame_number"];
            break;
        case 8:
            [self.dataDict setObject:textField.text forKey:@"buy_time"];
            break;
        case 9:
            [self.dataDict setObject:textField.text forKey:@"drive_license"];
            break;
        case 10:
            [self.dataDict setObject:textField.text forKey:@"yearly_inspection_location"];
            break;
        case 11:
            [self.dataDict setObject:textField.text forKey:@"yearly_inspection_end_time"];
            break;
        case 12:
            [self.dataDict setObject:textField.text forKey:@"insurance_company"];
            break;
        case 13:
            [self.dataDict setObject:textField.text forKey:@"insurance_end_time"];
            break;
        default:
            break;
    }
    return  YES;
}
-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)maskView{
     self.mask= [[UIView alloc] initWithFrame:self.view.frame];
    self.mask.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5f];
    self.mask.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    tap.delegate = self;
    [self.mask addGestureRecognizer:tap];

    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 286, 276)];
    imageV.center = CGPointMake( self.mask.center.x,  self.mask.center.y-50);
    imageV.backgroundColor = [UIColor clearColor];
    imageV.image = [UIImage imageNamed:@"Group 2"];
    [ self.mask addSubview:imageV];
    
    UITextView *tf = [[UITextView alloc] initWithFrame:CGRectMake(50, 100, 196, 60)];
    tf.textColor = [UIColor whiteColor];
    tf.backgroundColor = [UIColor clearColor];
    tf.font = [UIFont systemFontOfSize:15];
    tf.editable = NO;
    tf.text = @"提交成功，感谢您的录入，您将获得来自92汽车俱乐部的佣金！";
    [imageV addSubview:tf];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(36, 220, 80, 40);
    [btn setTitle:@"我的业绩" forState:0];
    btn.center = CGPointMake(self.mask.center.x, imageV.center.y+60);
    [btn addTarget:self action:@selector(homeAction1) forControlEvents:UIControlEventTouchUpInside];
    [self.mask addSubview:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(36, 260, 80, 40);
    btn1.center = CGPointMake(self.mask.center.x, imageV.center.y+90);
    [btn1 setTitle:@"回首页" forState:0];
    [btn1 addTarget:self action:@selector(homeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.mask addSubview:btn1];
    [self.view addSubview: self.mask];
}
-(void)homeAction{
    [self dismissViewControllerAnimated:YES completion:^{
        
        [self.vc.navigationController popToRootViewControllerAnimated:YES];
    }];
    
}
-(void)homeAction1{
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.vc.navigationController popToRootViewControllerAnimated:YES];
        [self.vc.vc goOhterVC];
    }];
}
-(void)tap{
    self.mask.hidden = YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]){
        return NO;
    }
    return YES;
}
-(void)select{
//    if (self.vc == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
//    }
//    else{
//        [self dismissViewControllerAnimated:NO completion:^{
//        UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
//        CarInfoViewController *cvc = [board instantiateViewControllerWithIdentifier:@"CarInfoViewController"];
//        cvc.plate_license = self.plate_license;
//        [self.vc.navigationController pushViewController:cvc animated:YES];
//    }];
//    }
}
-(void)loadData{
    
        if (self.car_type.length ==0 ) {
             [MBProgressHUD showError:@"联系方式必填" toView:self.view];
            return;
        }
        if (self.car_type.length ==0 ) {
            [MBProgressHUD showError:@"车辆类型必填" toView:self.view];
            return;
        }
        if (self.car_type.length ==0 ) {
            [MBProgressHUD showError:@"车牌必填" toView:self.view];
            return;
        }
        [MBProgressHUD showMessag:@"提交中" toView:self.view];
        [DTNetManger customerAddWith:self.dataDict callBack:^(NSError *error, id response) {
            [MBProgressHUD hiddenFromView:self.view];
            if (response&&[response isKindOfClass:[NSString class]]) {
                NSString *temp = (NSString *)response;
                if ([temp isEqualToString:@"success"]) {
                    self.mask.hidden = YES;
                }else{
                    self.mask.hidden = NO;
                }
            }
        }];
   
}
@end
