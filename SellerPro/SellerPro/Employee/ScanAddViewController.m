//
//  ScanAddViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/6/13.
//  Copyright © 2017年 karashock. All rights reserved.
//


#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#import "ScanAddViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ScanView.h"
#import "LoadView.h"
#import "ScanResultViewController.h"

@interface ScanAddViewController ()
<AVCaptureMetadataOutputObjectsDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIAlertViewDelegate
>
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) UIButton *lightButton;
@property (nonatomic, strong) UIButton *imageButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *slideLineView;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat viewWidth;
//flash
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) ScanView *scan;
@property (nonatomic, strong) NSString *code;
@end

@implementation ScanAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫一扫";
    [self setLeftBackNavItem];
    _viewWidth = 50.0;
    self.isOpen = NO;
    self.view.backgroundColor = [UIColor greenColor];
    
    UIButton *_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn setTitle:@"开灯" forState:UIControlStateNormal];
    _btn.frame = CGRectMake(0, 0, 60, 44);
    _btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [_btn addTarget:self action:@selector(lightButtonDidTouch) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_btn];
    
    [self reLoad];
    [self.view addSubview:_bgView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_session) {
        [self setupAVFoundation];
    }
}
-(void)reLoad{
    //    设置loading界面
    [self setupBgView];
    //    设置扫面界面
    [self setupScanView];
    //    设置扫描线
    [self setupTimer];
}
- (void)setupBgView {
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _bgView.backgroundColor = [UIColor blackColor];
    
    LoadView *loadView = [[LoadView alloc]init];
    [_bgView addSubview:loadView];
    // 动画开始
    [loadView startAnimating];
}

- (void)setupScanView {
    _scan = [[ScanView alloc]initWithFrame:self.view.bounds];
    _scan.backgroundColor = [UIColor clearColor];
    
    _slideLineView = [[UIView alloc]initWithFrame:CGRectMake(_viewWidth, 181, ScreenWidth - _viewWidth * 2, 1)];
    _slideLineView.backgroundColor = [UIColor greenColor];
    [_scan addSubview:_slideLineView];
    [self.view addSubview:_scan];
    [self setupSubView];
}

- (void)setupSubView {
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 360, ScreenWidth, 50.0)];
    _titleLabel.text = @"请将二维码/条形码放入框内";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    [_scan addSubview:_titleLabel];
    
    _lightButton = [[UIButton alloc]initWithFrame:CGRectMake(100, 500, 50, 50)];
    [_lightButton setTitle:@"light" forState:UIControlStateNormal];
    [_lightButton addTarget:self action:@selector(lightButtonDidTouch) forControlEvents:UIControlEventTouchUpInside];
    //    [_scan addSubview:_lightButton];
    
    _imageButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.center.x-30, KSCREEN_HEIGHT-160, 60, 60)];
    [_imageButton setTitle:@"拍照" forState:UIControlStateNormal];
    _imageButton.backgroundColor = RGB(17, 157, 255);
    _imageButton.layer.masksToBounds = YES;
    _imageButton.layer.cornerRadius = _imageButton.frame.size.width/2;
    [_imageButton addTarget:self action:@selector(imageButtonDidTouch) forControlEvents:UIControlEventTouchUpInside];
//    [_scan addSubview:_imageButton];
}

- (void)lightButtonDidTouch {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (![device hasTorch]) {
        NSLog(@"no torch");
    }else {
        [device lockForConfiguration:nil];
        if (!self.isOpen) {
            [device setTorchMode: AVCaptureTorchModeOn];
            self.isOpen = YES;
        }
        else {
            [device setTorchMode: AVCaptureTorchModeOff];
            self.isOpen = NO;
        }
        [device unlockForConfiguration];
    }
}

- (void)imageButtonDidTouch {
    [_timer invalidate];
    _timer = nil;
    UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    ScanResultViewController *cvc = [board instantiateViewControllerWithIdentifier:@"ScanResultViewController"];
    [self.navigationController pushViewController:cvc animated:YES];
    
    
    //    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    //    //设置图片源(相簿)
    //    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    //    //设置代理
    //    picker.delegate = self;
    //    //设置可以编辑
    //    picker.allowsEditing = YES;
    //    //打开拾取器界面
    //    [self presentViewController:picker animated:YES completion:nil];
}

- (void)setupAVFoundation {
    //获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //计算中间可探测区域
    CGSize windowSize = [UIScreen mainScreen].bounds.size;
    CGSize scanSize = CGSizeMake(240,240);
    CGRect scanRect = CGRectMake((windowSize.width-scanSize.width)/2,
                                     (windowSize.height-scanSize.height)/2, scanSize.width, scanSize.height);
   //计算rectOfInterest 注意x,y交换位置
    scanRect = CGRectMake(scanRect.origin.y/windowSize.height,
                          scanRect.origin.x/windowSize.width,
                          scanRect.size.height/windowSize.height,
                          scanRect.size.width/windowSize.width);
//    //设置可探测区域
    output.rectOfInterest = scanRect;
    
    //初始化链接对象
    _session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    [_session addInput:input];
    [_session addOutput:output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeInterleaved2of5Code,AVMetadataObjectTypeITF14Code,AVMetadataObjectTypeDataMatrixCode];
    
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:_previewLayer atIndex:0];
    
    //开始捕获
    [_session startRunning];
    //移除loading view
    [_bgView removeFromSuperview];
}

- (void)setupTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.8 target:self selector:@selector(animationView) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)animationView {
    [UIView animateWithDuration:1.5 animations:^{
        _slideLineView.transform = CGAffineTransformMakeTranslation(0, 179);
    } completion:^(BOOL finished) {
        _slideLineView.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark UIImagePickerControllerDelegate methods
//完成选择图片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    // 销毁控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 根据URL找到CIImage
    CIImage *ciImage = [[CIImage alloc]initWithCGImage:image.CGImage];
    if (ciImage){
        // 创建CIDetector
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy: CIDetectorAccuracyHigh }];
        NSArray *features = [detector featuresInImage:ciImage];
        if ([features count] > 0) {
            for (CIFeature *feature in features) {
                if (![feature isKindOfClass:[CIQRCodeFeature class]]) {
                    continue;
                }
                CIQRCodeFeature *qrFeature = (CIQRCodeFeature *)feature;
                NSString *code = qrFeature.messageString;
                [self scanSuccess];
                [self goodInfo:code];
               
            }
        }else {
            [self setupTimer];
        }
    }
}
//取消选择图片
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)goodInfo:(NSString *)barcode{
    [MBProgressHUD showMessag:@"处理中" toView:self.view];
    [DTNetManger goodGetWith:barcode type:@"1" callBack:^(NSError *error, id response) {
        [MBProgressHUD hiddenFromView:self.view];
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary*)response;
            if (self.resultBlock) {
                self.resultBlock(dic);
            }
             [self.navigationController popViewControllerAnimated:YES];
        }else{
            if ([response  isKindOfClass:[NSString class]]) {
                [MBProgressHUD showError:(NSString *)response toView:self.view];
            }
            [self.session startRunning];
            [self setupTimer];
        }
    }];
}
-(void)showResult{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"扫码结果"
                                                    message:@"是否添加"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"添加",nil];
    [alert show];
}
#pragma marks -- UIAlertViewDelegate
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self.session startRunning];
        [self setupTimer];
    }else{
        [self goodInfo:self.code];
    }
}
#pragma mark 输出的代理
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count > 0) {
        [_timer invalidate];
        _timer = nil;
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex: 0];
//        if (self.resultBlock) {
//            self.resultBlock(metadataObject.stringValue);
            [self scanSuccess];
        self.code =metadataObject.stringValue;
        [self showResult];
//        }
        //输出扫描字符串
//        [self.navigationController popViewControllerAnimated:YES];
    }
}
//扫描成功的提示音
- (void)scanSuccess {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(1109);
}
@end
