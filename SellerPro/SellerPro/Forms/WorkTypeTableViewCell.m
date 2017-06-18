//
//  WorkTypeTableViewCell.m
//  SellerPro
//
//  Created by leiganzheng on 2017/6/8.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "WorkTypeTableViewCell.h"

@implementation WorkTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.deBtn.layer.borderColor = RGB(211, 217, 222).CGColor;
    self.deBtn.layer.borderWidth = 1;
    [self.deBtn setTitleColor:RGB(220, 107, 107) forState:0];
    self.addBtn.layer.borderColor = RGB(211, 217, 222).CGColor;
    self.addBtn.layer.borderWidth = 1;
    self.resultBtn.layer.borderColor = RGB(211, 217, 222).CGColor;
    self.resultBtn.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
