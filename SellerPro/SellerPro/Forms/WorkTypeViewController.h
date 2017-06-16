//
//  WorkTypeViewController.h
//  SellerPro
//
//  Created by leiganzheng on 2017/5/8.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTBaseViewController.h"
typedef void (^ServiceBolck)(NSString *num);
@interface WorkTypeViewController : DTBaseViewController
@property(nonatomic,assign) BOOL isAdd;
@property (nonatomic, copy) ServiceBolck resultBlock;

@end
