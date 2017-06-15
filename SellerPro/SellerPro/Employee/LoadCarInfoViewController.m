//
//  LoadCarInfoViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/6/15.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "LoadCarInfoViewController.h"
#import "IQKeyboardReturnKeyHandler.h"

@interface LoadCarInfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgeV;

@property (weak, nonatomic) IBOutlet UITextField *nametf;
@property (weak, nonatomic) IBOutlet UITextField *phonetf;
@property (weak, nonatomic) IBOutlet UITextField *juliTF;
@property (weak, nonatomic) IBOutlet UITextField *fdhTF;
@property (weak, nonatomic) IBOutlet UITextField *cjhTF;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UILabel *plase_num;
@property (nonatomic,strong)UIView *mask;
@property (nonatomic, strong) IQKeyboardReturnKeyHandler    *returnKeyHandler;
@end

@implementation LoadCarInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftBackNavItem];
    self.imgeV.contentMode = UIViewContentModeScaleAspectFit;
    self.imgeV.image = self.licenseImage;
    self.title =@"资料补充";
    [Tools configCornerOfView:_nametf with:3];
    [Tools configCornerOfView:_submitBtn with:3];
    _nametf.frame = CGRectMake(_nametf.frame.origin.x, _nametf.frame.origin.y, _nametf.bounds.size.width, 44);
    _nametf.layer.borderColor = RGB(211, 217, 222).CGColor;
    _nametf.layer.borderWidth = 1;
    _nametf.placeholder = @"车主姓名";
     _phonetf.placeholder = @"联系方式";
     _juliTF.placeholder = @"行驶里程";
     _fdhTF.placeholder = @"发动机号";
     _cjhTF.placeholder = @"车架号";
    self.plate_license = @"粤S777ML";
    
    [Tools configCornerOfView:_phonetf with:3];
    _phonetf.frame = CGRectMake(_phonetf.frame.origin.x, _phonetf.frame.origin.y, _phonetf.bounds.size.width, 44);
    _phonetf.layer.borderColor = RGB(211, 217, 222).CGColor;
    _phonetf.layer.borderWidth = 1;
    
    [Tools configCornerOfView:_juliTF with:3];
    _juliTF.frame = CGRectMake(_juliTF.frame.origin.x, _juliTF.frame.origin.y, _juliTF.bounds.size.width, 44);
    _juliTF.layer.borderColor = RGB(211, 217, 222).CGColor;
    _juliTF.layer.borderWidth = 1;
    
    [Tools configCornerOfView:_fdhTF with:3];
    _fdhTF.frame = CGRectMake(_fdhTF.frame.origin.x, _fdhTF.frame.origin.y, _fdhTF.bounds.size.width, 44);
    _fdhTF.layer.borderColor = RGB(211, 217, 222).CGColor;
    _fdhTF.layer.borderWidth = 1;
    
    [Tools configCornerOfView:_cjhTF with:3];
    _cjhTF.frame = CGRectMake(_cjhTF.frame.origin.x, _cjhTF.frame.origin.y, _cjhTF.bounds.size.width, 44);
    _cjhTF.layer.borderColor = RGB(211, 217, 222).CGColor;
    _cjhTF.layer.borderWidth = 1;
    
    [Tools configCornerOfView:_plase_num with:3];
    _plase_num.layer.borderColor = RGB(211, 217, 222).CGColor;
    _plase_num.layer.borderWidth = 1;
    [self maskView];
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    imageV.image = [[UIImage imageNamed:@"BG_Red envelopes"] stretchableImageWithLeftCapWidth:140 topCapHeight:120];
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
-(void)loadData{
    if (_nametf.text.length ==0 ||_phonetf.text.length ==0 ||_cjhTF.text.length ==0 ||_fdhTF.text.length ==0 ||self.plate_license.length ==0 ) {
        [MBProgressHUD showError:@"请输入内容" toView:self.view];
    }else{
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:_nametf.text forKey:@"name"];
        [dict setObject:_phonetf.text forKey:@"phone"];
        [dict setObject:self.plate_license forKey:@"plate_license"];
        [dict setObject:_fdhTF.text forKey:@"engine_number"];
        [dict setObject:_cjhTF.text forKey:@"frame_number"];
        
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
