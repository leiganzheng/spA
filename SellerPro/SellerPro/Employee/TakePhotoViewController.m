//
//  TakePhotoViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/6/13.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "TakePhotoViewController.h"
#import "ScanResultViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ScanOtherView.h"

@interface TakePhotoViewController ()
{
    
}

// AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
@property (nonatomic, strong)AVCaptureSession *session;

// AVCaptureDeviceInput对象是输入流
@property (nonatomic, strong)AVCaptureDeviceInput *videoInput;

// 照片输出流对象
@property (nonatomic, strong)AVCaptureStillImageOutput *stillImageOutput;

// 预览图层，来显示照相机拍摄到的画面
@property (nonatomic, strong)AVCaptureVideoPreviewLayer *previewLayer;

// 切换前后镜头的按钮
@property (nonatomic, strong)UIButton *toggleButton;

// 拍照按钮
@property (nonatomic, strong)UIButton *shutterButton;

// 放置预览图层的View
@property (nonatomic, strong)UIView *cameraShowView;

// 用来展示拍照获取的照片
@property (nonatomic, strong)UIImageView *imageShowView;
@property (nonatomic, strong) NSString *plate_license;
@property (nonatomic, strong) UIImage *licenseImage;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) ScanOtherView *scan;
@end

@implementation TakePhotoViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self initialSession];
        [self initCameraShowView];
//        [self initImageShowView];
        [self setupScanView];
        [self initButton];
    }
    return self;
}

- (void)initialSession
{
    self.session = [[AVCaptureSession alloc] init];
    
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:nil];
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    // 这是输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
}

- (void)initCameraShowView
{
    self.cameraShowView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.cameraShowView];
}

- (void)initImageShowView
{
    self.imageShowView = [[UIImageView alloc] initWithFrame:CGRectMake(30, self.view.center.y - 100, KSCREEN_WIDTH-60, 200)];
    self.imageShowView.contentMode = UIViewContentModeScaleToFill;
    self.imageShowView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.1];
    [self.view addSubview:self.imageShowView];
}
- (void)setupScanView {
    _scan = [[ScanOtherView alloc]initWithFrame:self.view.bounds];
    _scan.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scan];
}
- (void)initButton
{
    self.shutterButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.shutterButton.frame = CGRectMake(self.view.center.x-30, KSCREEN_HEIGHT-160, 60, 60);
    [self.shutterButton setTitle:@"拍照" forState:UIControlStateNormal];
    [self.shutterButton setTitleColor:[UIColor whiteColor] forState:0];
    self.shutterButton.backgroundColor = RGB(17, 157, 255);
    self.shutterButton.layer.masksToBounds = YES;
    self.shutterButton.layer.cornerRadius = self.shutterButton.frame.size.width/2;
    [self.shutterButton addTarget:self action:@selector(shutterCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.shutterButton];
    
}

// 这是获取前后摄像头对象的方法
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

- (AVCaptureDevice *)frontCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

- (AVCaptureDevice *)backCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftBackNavItem];
    self.title = @"拍照";
    UIButton *_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn setTitle:@"开灯" forState:UIControlStateNormal];
    _btn.frame = CGRectMake(0, 0, 60, 44);

    _btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_btn addTarget:self action:@selector(lightButtonDidTouch) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_btn];
    self.isOpen = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUpCameraLayer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.session) {
        [self.session startRunning];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (self.session) {
        [self.session stopRunning];
    }
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

- (void)setUpCameraLayer
{
    if (self.previewLayer == nil) {
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        UIView * view = self.cameraShowView;
        CALayer * viewLayer = [view layer];
        // UIView的clipsToBounds属性和CALayer的setMasksToBounds属性表达的意思是一致的,决定子视图的显示范围。当取值为YES的时候，剪裁超出父视图范围的子视图部分，当取值为NO时，不剪裁子视图。
        [viewLayer setMasksToBounds:NO];
        
        CGRect bounds = [view bounds];
        [self.previewLayer setFrame:bounds];
        viewLayer.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5].CGColor;
        [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
        
        [viewLayer addSublayer:self.previewLayer];
    }
}

// 这是拍照按钮的方法
- (void)shutterCamera
{
    AVCaptureConnection *videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        return;
    }
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [UIImage imageWithData:imageData];
        NSLog(@"image size = %@", NSStringFromCGSize(image.size));
  
//        self.imageShowView.image = image;
        [self ocrImage:nil];
    }];
}
-(void)ocrImage:(UIImage *)originImage{
    UIImage *tempImage = [UIImage imageNamed:@"3.pic_hd"];
    NSData *data = UIImageJPEGRepresentation(tempImage, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    if (encodedImageStr.length!=0) {
        [MBProgressHUD showMessag:@"处理中" toView:self.view];
        [DTNetManger customerOcrWith:encodedImageStr callBack:^(NSError *error, id response) {
            [MBProgressHUD hiddenFromView:self.view];
            if (response && [response isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary*)response;
                UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
                ScanResultViewController *cvc = [board instantiateViewControllerWithIdentifier:@"ScanResultViewController"];
                cvc.licenseImage = originImage;
                cvc.plate_license = dic[@"plate_license"];
                [self.navigationController pushViewController:cvc animated:YES];
            }else{
                if ([response  isKindOfClass:[NSString class]]) {
                    [MBProgressHUD showError:(NSString *)response toView:self.view];
                }
            }
        }];
    }else{
        [MBProgressHUD showError:@"图片错误，请重试" toView:self.view];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
