//
//  QRCodeViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/5/10.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "QRCodeViewController.h"

@interface QRCodeViewController ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *veryBtn;
@property (weak, nonatomic) IBOutlet UIImageView *qrV;

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [Tools QRCodeGenerator:self.qrV withUrl:[self.dict objectForKey:@"url"]];
    [self openCountdown];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tap{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
// 开启倒计时效果
-(void)openCountdown{
    NSString *mytime = [NSString stringWithFormat:@"%@",[self.dict objectForKey:@"expires"]];
    __block NSInteger time = mytime.integerValue-1; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self.veryBtn setTitle:@"二维码到期" forState:UIControlStateNormal];
                [self.veryBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                self.veryBtn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = (int)time;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self.veryBtn setTitle:[NSString stringWithFormat:@"二维码有效期：(%.2d)", seconds] forState:UIControlStateNormal];
                [self.veryBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                self.veryBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}


@end
