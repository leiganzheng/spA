//
//  AddCarSViewController.h
//  SellerPro
//
//  Created by leiganzheng on 2017/6/8.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "DTBaseViewController.h"
typedef void (^CarGoodBolck)(NSDictionary *dict);

@interface AddCarSViewController : DTBaseViewController
@property (nonatomic, copy) CarGoodBolck resultBlock;
@end
