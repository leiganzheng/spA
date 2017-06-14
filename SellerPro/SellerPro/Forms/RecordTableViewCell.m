//
//  RecordTableViewCell.m
//  SellerPro
//
//  Created by leiganzheng on 2017/6/8.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "RecordTableViewCell.h"

@implementation RecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.dotB.layer.masksToBounds = YES;
    self.dotB.layer.cornerRadius = self.dotB.bounds.size.width/2;
    self.dotB.backgroundColor = RGB(17, 156, 254);
    UIImage *img=[UIImage imageNamed:@"bg_history record"];
    self.bgImag.image = [img stretchableImageWithLeftCapWidth:9 topCapHeight:10];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
