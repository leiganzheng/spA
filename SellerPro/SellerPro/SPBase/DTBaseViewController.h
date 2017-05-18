//
//  DTBaseViewController.h
//  
//
//  Created by leiganzheng on 2017/5/7.
//  Copyright © 2017年 fly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTBaseViewController : UIViewController

@property (nonatomic, strong) NSString *navTitle;

- (void)hideNavBar:(BOOL)isHide;
- (void)setLeftBackNavItem;
@end
