//
//  ScanAddViewController.h
//  SellerPro
//
//  Created by leiganzheng on 2017/6/13.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "DTBaseViewController.h"
typedef void (^ResultAddBolck)(NSDictionary *dict);
@interface ScanAddViewController : DTBaseViewController
@property (nonatomic, copy) ResultAddBolck resultBlock;
@end
