//
//  Tools.h
//  SellerPro
//
//  Created by leiganzheng on 2017/5/8.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject

+(void)configCornerOfView:(UIView *)view with:(NSInteger)value;
+(void)enterRootViewController:(UIViewController *)vc animated:(BOOL)animated;
+(void)configOrignNetWork;

+(void)QRCodeGenerator:(UIImageView *)imageView withUrl:(NSString*)url;

@end
