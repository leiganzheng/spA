//
//  TimeViewController.h
//  SellerPro
//
//  Created by leiganzheng on 2017/5/8.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTBaseViewController.h"

@protocol TimeViewControllerDelegate <NSObject>

- (void)didSelectedDate:(NSString *)date;

@end

@interface TimeViewController : DTBaseViewController
@property(assign,nonatomic)id<TimeViewControllerDelegate> delegate;
@end
