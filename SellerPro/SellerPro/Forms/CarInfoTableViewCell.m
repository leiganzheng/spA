//
//  CarInfoTableViewCell.m
//  SellerPro
//
//  Created by leiganzheng on 2017/6/8.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "CarInfoTableViewCell.h"

@implementation CarInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.name.layer.masksToBounds = YES;
    self.name.layer.cornerRadius = self.name.bounds.size.width/2;
    self.name.backgroundColor = RGB(36, 201, 216);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
