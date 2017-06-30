//
//  CarInfoViewController.h
//  SellerPro
//
//  Created by leiganzheng on 2017/5/30.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "DTBaseViewController.h"
#import "TakePhotoViewController.h"
@interface CarInfoViewController : DTBaseViewController
@property (nonatomic, strong) NSString *plate_license;
@property (nonatomic, strong) UIImage *licenseImage;
@property (nonatomic, strong) TakePhotoViewController *vc;
@end
