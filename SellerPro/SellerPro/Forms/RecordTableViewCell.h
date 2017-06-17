//
//  RecordTableViewCell.h
//  SellerPro
//
//  Created by leiganzheng on 2017/6/8.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *bgImag;
@property (weak, nonatomic) IBOutlet UIView *dotB;
@property (weak, nonatomic) IBOutlet UIView *lastlIne;

@end
