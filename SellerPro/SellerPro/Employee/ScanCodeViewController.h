//
//  ScanCodeViewController.h
//  01-ScanCode(OC)
//
//  Created by 冯志浩 on 2017/4/10.
//  Copyright © 2017年 冯志浩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTBaseViewController.h"
typedef void (^ResultBolck)(NSString *str);
@interface ScanCodeViewController : DTBaseViewController
@property (nonatomic, copy) ResultBolck resultBlock;
@end
