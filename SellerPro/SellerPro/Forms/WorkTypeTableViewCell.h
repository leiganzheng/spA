//
//  WorkTypeTableViewCell.h
//  SellerPro
//
//  Created by leiganzheng on 2017/6/8.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkTypeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *nameTitel;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *deBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *resultBtn;

@end
