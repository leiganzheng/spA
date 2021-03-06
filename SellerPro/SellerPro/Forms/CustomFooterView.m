//
//  CustomFooterView.m
//  SellerPro
//
//  Created by leiganzheng on 2017/6/8.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "CustomFooterView.h"

@implementation CustomFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        /* 添加子控件的代码*/
        [self subview];
    }
    return self;
}
-(void)subview{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH/2, 60)];
    v.backgroundColor = [UIColor blackColor];
    [self addSubview:v];
    
    self.lb = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 20)];
     self.lb.textAlignment = NSTextAlignmentLeft;
     self.lb.textColor = [UIColor whiteColor];
     self.lb.font = [UIFont systemFontOfSize:15];
     self.lb.text = @"合计：¥0";
    [v addSubview: self.lb];
    
    self.lb1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 32, 200, 20)];
    self.lb1.textAlignment = NSTextAlignmentLeft;
    self.lb1.textColor = [UIColor whiteColor];
    self.lb1.font = [UIFont systemFontOfSize:15];
    self.lb1.text = @"商品：¥0 服务：¥0";
    [v addSubview:self.lb1];
    
    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(KSCREEN_WIDTH/2, 0, KSCREEN_WIDTH/2, 60)];
    v1.backgroundColor = RGB(17, 157, 255);
    [self addSubview:v1];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"结算" forState:UIControlStateNormal];
    btn.backgroundColor = RGB(17, 156, 254);
    btn.frame = CGRectMake(0, 0, KSCREEN_WIDTH/2, 60);
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [v1 addSubview:btn];
}
-(void)save{
    if (_resultBlock) {
        _resultBlock([NSString stringWithFormat:@"%li",[self.goodTotal integerValue] + [self.ServiceTotal integerValue]]);
    }
}
@end
