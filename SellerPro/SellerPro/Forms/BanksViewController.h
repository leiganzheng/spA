//
//  BanksViewController.h
//  SellerPro
//
//  Created by leiganzheng on 2017/6/14.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "DTBaseViewController.h"
typedef void (^MyResultBolck)(NSString *name);
@interface BanksViewController : DTBaseViewController
@property (nonatomic, copy) MyResultBolck resultBlock;
@property (nonatomic, strong)NSString *name;

@end
