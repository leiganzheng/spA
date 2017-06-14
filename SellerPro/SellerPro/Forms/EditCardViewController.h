//
//  EditCardViewController.h
//  SellerPro
//
//  Created by leiganzheng on 2017/5/23.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "DTBaseViewController.h"
typedef void (^RBolck)(NSString *bank,NSString *card);
@interface EditCardViewController : DTBaseViewController
@property (nonatomic, copy) RBolck block;
@end
