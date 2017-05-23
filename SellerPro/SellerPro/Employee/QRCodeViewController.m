//
//  QRCodeViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/5/10.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "QRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ScanResultViewController.h"

@interface QRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *veryBtn;
@property (weak, nonatomic) IBOutlet UIImageView *qrV;
@property (strong, nonatomic)AVCaptureSession * session;//输入输出的中间桥梁
@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"拍照";
    [self setLeftBackNavItem];
     UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
    [self scan];
    [self buildView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tap{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark -AVCaptureMetadataOutputObjectsDelegate method

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        //[session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        //输出扫描字符串
        NSLog(@"%@",metadataObject.stringValue);
    }
}
#pragma mark -private method
- (void)buildView{
    UIView *bgv = [[UIView alloc] initWithFrame:self.view.bounds];
    bgv.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    [self.view addSubview:bgv];
    
    
    UILabel *lb1 = [[UILabel alloc] initWithFrame:CGRectMake(10,self.view.center.y-40-100, KSCREEN_WIDTH-20, 44)];
    lb1.textAlignment = NSTextAlignmentCenter;
    lb1.text = @"请将客户的车牌号对准拍照区域";
    lb1.textColor = [UIColor whiteColor];
    [bgv addSubview:lb1];
    
    UIView *scanV = [[UIView alloc] initWithFrame:CGRectMake(10,self.view.center.y-40, KSCREEN_WIDTH-20, 80)];
    scanV.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    [bgv addSubview:scanV];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.view.center.x-40,KSCREEN_HEIGHT - 180, 80, 80);
    [btn setTitle:@"拍照" forState:UIControlStateNormal];
    btn.backgroundColor = RGB(17, 157, 255);
    [Tools configCornerOfView:btn with:40];
    [btn addTarget:self action:@selector(photo) forControlEvents:UIControlEventTouchUpInside];
    [bgv addSubview:btn];

}
- (void)photo{
    UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    ScanResultViewController *cvc = [board instantiateViewControllerWithIdentifier:@"ScanResultViewController"];
    [self.navigationController pushViewController:cvc animated:YES];

}
- (void)scan{
    // Do any additional setup after loading the view, typically from a nib.
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    _session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [_session addInput:input];
    [_session addOutput:output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    //开始捕获
    [_session startRunning];
}
@end
