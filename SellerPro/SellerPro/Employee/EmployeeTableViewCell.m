//
//  EmployeeTableViewCell.m
//  SellerPro
//
//  Created by leiganzheng on 2017/5/9.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "EmployeeTableViewCell.h"

@implementation EmployeeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [Tools configCornerOfView:_bgView with:3];
    self.logo.layer.masksToBounds = YES;
    self.logo.layer.cornerRadius = self.logo.frame.size.width/2;
    self.logo.layer.borderColor = RGB(17, 157, 255).CGColor;
    self.logo.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
