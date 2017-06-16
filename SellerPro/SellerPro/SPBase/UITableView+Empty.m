//
//  UITableView+Empty.m
//  SellerPro
//
//  Created by leiganzheng on 2017/5/11.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "UITableView+Empty.h"

@implementation UITableView (Empty)
- (void) tableViewDisplayWitMsg:(NSString *) message ifNecessaryForRowCount:(NSUInteger) rowCount
{
    if (rowCount == 0) {
        // Display a message when the table is empty
        // 没有数据的时候，UILabel的显示样式
        UIView *bgV = [UIView new];
//        bgV.backgroundColor = [UIColor lightGrayColor];
        bgV.frame = CGRectMake(0, 0, KSCREEN_WIDTH, 300);
        
        UIImageView *imagV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 42, 37)];
        imagV.image = [UIImage imageNamed:@"icon_null history record"];
        imagV.center = CGPointMake(bgV.center.x, bgV.center.y+110);
        [bgV addSubview:imagV];
        UILabel *messageLabel = [UILabel new];
        
        messageLabel.text = message;
        messageLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        messageLabel.textColor = [UIColor lightGrayColor];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [messageLabel sizeToFit];
        messageLabel.center = CGPointMake(bgV.center.x, imagV.center.y+45);
        [bgV addSubview:messageLabel];
        
        self.backgroundView = bgV;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        self.backgroundView = nil;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}
@end
