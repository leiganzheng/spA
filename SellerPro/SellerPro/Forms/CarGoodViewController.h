//
//  CarGoodViewController.h
//  SellerPro
//
//  Created by leiganzheng on 2017/6/1.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "DTBaseViewController.h"
typedef void (^GoodBolck)(NSString *num);
@interface CarGoodViewController : DTBaseViewController
@property (nonatomic, copy) GoodBolck resultBlock;
@end
