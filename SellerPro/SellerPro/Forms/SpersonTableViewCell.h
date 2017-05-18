//
//  SpersonTableViewCell.h
//  SellerPro
//
//  Created by leiganzheng on 2017/5/9.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpersonTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *logo;
@property (weak, nonatomic) IBOutlet UILabel *logoName;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *price;
@end
