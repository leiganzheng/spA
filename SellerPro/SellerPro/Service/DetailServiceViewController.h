//
//  DetailServiceViewController.h
//  SellerPro
//
//  Created by leiganzheng on 2017/5/15.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTBaseViewController.h"

@interface DetailServiceViewController : DTBaseViewController
@property (nonatomic,strong) NSArray *dataSource;
@property (nonatomic,strong) NSString *myTitle;
@property (nonatomic,strong) NSString *customID;
@property (nonatomic,strong) NSString *cateID;
@end
