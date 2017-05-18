//
//  StaffInfoMdViewController.h
//  SellerPro
//
//  Created by leiganzheng on 2017/5/14.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTBaseViewController.h"
@protocol StaffInfoMdViewControllerDelegate <NSObject>

- (void)didSelectedData:(NSString *)data withType:(BOOL)falg;
- (void)didSelectedData:(NSString *)data withId:(NSString *)customID;
@end
@interface StaffInfoMdViewController : DTBaseViewController
@property(nonatomic,assign) BOOL isWorkType;
@property(nonatomic,assign) NSString *cusID;
@property(assign,nonatomic)id<StaffInfoMdViewControllerDelegate> delegate;
@end
