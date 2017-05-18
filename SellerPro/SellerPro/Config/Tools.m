//
//  Tools.m
//  SellerPro
//
//  Created by leiganzheng on 2017/5/8.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "Tools.h"
#import "AppDelegate.h"
#import <CommonCrypto/CommonDigest.h>
#import <CoreImage/CoreImage.h>

@implementation Tools

+(void)configCornerOfView:(UIView *)view with:(NSInteger)value{
    if (view) {
        view.layer.cornerRadius = 3;
        view.layer.masksToBounds = YES;
    }
}
+(void)enterRootViewController:(UIViewController *)vc animated:(BOOL)animated{
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIView *animationView = [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:NO];
    if (appDelegate) {
        [appDelegate.window addSubview:animationView];
        UIViewController *control = appDelegate.window.rootViewController;
        UIViewController *viewController = control.presentingViewController;
        if (viewController) {
            [viewController dismissViewControllerAnimated:NO completion:^{
                [self changeRootViewController:vc animationView:animationView animated:YES];
            }];
        }else{
            [self changeRootViewController:vc animationView:animationView animated:YES];
        }
    }
}
+(void)changeRootViewController:(UIViewController *)vc animationView:(UIView*)animationView animated:(BOOL)animated{
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = vc;
    if (animated) {
        [appDelegate.window bringSubviewToFront:animationView];
        [UIView animateWithDuration:0.5 animations:^{
            animationView.transform = CGAffineTransformMakeScale(3.0, 3.0);
            animationView.alpha = 0;
        } completion:^(BOOL finished) {
            [animationView removeFromSuperview];
        }];
    }else{
        [animationView removeFromSuperview];
    }
}
+ (void)configOrignNetWork{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"ios",@"client-type",
                         OpenUDID.value,@"client-imei",
                         @"1.0",@"client-version",
                         [self timeStamp:YES], @"timestamp",
                         [self signature],@"signature",
                         ((AppDelegate*)[UIApplication sharedApplication].delegate).token, @"token",
                         ((AppDelegate*)[UIApplication sharedApplication].delegate).rtoken,@"refresh-token",
                         nil];
    [HYBNetworking configCommonHttpHeaders:dic];

}
+(NSString*)timeStamp:(BOOL)flag{
    NSDate *senddate = [NSDate date];
    
    NSLog(@"date1时间戳 = %ld",time(NULL));
    NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
    NSLog(@"date2时间戳 = %@",date2);
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *date1 = [dateformatter stringFromDate:senddate];
    NSLog(@"获取当前时间   = %@",date1);
    
    // 时间戳转时间
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[senddate timeIntervalSince1970]];
    //    NSString *confromTimespStr = [dateformatter stringFromDate:confromTimesp];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[confromTimesp timeIntervalSince1970]];  //    NSLog(@"时间戳转时间   = %@",confromTimespStr);
    if (flag) {
        if (timeSp.length >10) {
            return [timeSp substringToIndex:10];
        }
        return timeSp;
    }else{
        return timeSp;
    }
}
+(NSString*)signature{
    //    merchant_ios
    NSString * str = [NSString stringWithFormat:@"%@%@", @"merchant_ios", [self timeStamp:NO]];
    //sha1
    const char *cstr = [str cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [NSData dataWithBytes:cstr length:str.length];
    //使用对应的CC_SHA1,CC_SHA256,CC_SHA384,CC_SHA512的长度分别是20,32,48,64
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    //使用对应的CC_SHA256,CC_SHA384,CC_SHA512
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    //    if (output.length >40) {
    //        return [output substringToIndex:40];
    //    }
    return output;
}
+(void)QRCodeGenerator:(UIImageView *)imageView withUrl:(NSString *)url{
    // 1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.恢复默认
    [filter setDefaults];
    
    // 3.给过滤器添加数据(正则表达式/账号和密码)
    NSData *data = [url dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    
    //因为生成的二维码模糊，所以通过createNonInterpolatedUIImageFormCIImage:outputImage来获得高清的二维码图片
    
    // 5.显示二维码
    imageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:283];
}
/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
@end
