//
//  LoadCarInfoViewController.h
//  SellerPro
//
//  Created by leiganzheng on 2017/6/15.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "DTBaseViewController.h"
#import "TakePhotoViewController.h"

@interface LoadCarInfoViewController : DTBaseViewController
@property(nonatomic,strong)UIImage *licenseImage;
@property (nonatomic, strong) NSString *plate_license;
@property (nonatomic, strong) TakePhotoViewController *vc;
@end
