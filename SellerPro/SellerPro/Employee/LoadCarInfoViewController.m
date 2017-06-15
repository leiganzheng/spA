//
//  LoadCarInfoViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/6/15.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "LoadCarInfoViewController.h"

@interface LoadCarInfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgeV;
@property (weak, nonatomic) IBOutlet UITextView *tf1;
@property (weak, nonatomic) IBOutlet UITextView *tf2;
@property (weak, nonatomic) IBOutlet UITextView *tf3;
@property (weak, nonatomic) IBOutlet UITextView *tf4;
@property (weak, nonatomic) IBOutlet UITextView *tf5;
@property (weak, nonatomic) IBOutlet UITextView *tf6;
@property (weak, nonatomic) IBOutlet UITextView *tf7;
@property (weak, nonatomic) IBOutlet UITextField *nametf;
@property (weak, nonatomic) IBOutlet UITextField *phonetf;
@property (weak, nonatomic) IBOutlet UITextField *juliTF;
@property (weak, nonatomic) IBOutlet UITextField *fdhTF;
@property (weak, nonatomic) IBOutlet UITextField *cjhTF;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation LoadCarInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftBackNavItem];
    self.imgeV.contentMode = UIViewContentModeScaleAspectFit;
    self.imgeV.image = self.licenseImage;
    self.title =@"录入车辆信息";
    [Tools configCornerOfView:_nametf with:3];
    _nametf.frame = CGRectMake(_nametf.frame.origin.x, _nametf.frame.origin.y, _nametf.bounds.size.width, 44);
    _nametf.layer.borderColor = RGB(211, 217, 222).CGColor;
    _nametf.layer.borderWidth = 1;
    _nametf.placeholder = @"车主姓名";
     _phonetf.placeholder = @"联系方式";
     _juliTF.placeholder = @"行驶里程";
     _fdhTF.placeholder = @"发动机号";
     _cjhTF.placeholder = @"车架号";
    
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

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitAction:(id)sender {
}


@end
