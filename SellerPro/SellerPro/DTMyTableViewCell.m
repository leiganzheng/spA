//
//  DTMyTableViewCell.m
//  DouTu
//
//  Created by 岳鹏飞 on 2017/3/18.
//  Copyright © 2017年 fly. All rights reserved.
//

#import "DTMyTableViewCell.h"

@implementation DTMyTableViewCell

- (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
    }
    return _iconView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = DT_Base_TitleFont;
        _titleLabel.textColor = [UIColor darkGrayColor];
    }
    return _titleLabel;
}
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [Tools configCornerOfView:_bgView with:3];
    }
    return _bgView;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).with.offset(4);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(KSCREEN_WIDTH-8, self.contentView.frame.size.height - 8));
    }];
    
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).with.offset(20);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(66, 66));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_iconView.mas_right).with.offset(18);
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-32);
    }];
}
- (void)prepareForReuse
{
    [super prepareForReuse];
    _iconView.image   = nil;
    _titleLabel.text  = nil;
}
@end
