//
//  CustomFooterView.h
//  SellerPro
//
//  Created by leiganzheng on 2017/6/8.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^MoneyBolck)(NSString *name);
@interface CustomFooterView : UIView
@property (nonatomic, copy) MoneyBolck resultBlock;
@property (nonatomic, strong) NSString *goodTotal;
@property (nonatomic, strong) NSString *ServiceTotal;
@property (nonatomic,strong)UILabel *lb ;
@property (nonatomic,strong)UILabel *lb1 ;
@end
