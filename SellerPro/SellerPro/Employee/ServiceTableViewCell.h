//
//  ServiceTableViewCell.h
//  SellerPro
//
//  Created by leiganzheng on 2017/6/12.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgeV;
@property (weak, nonatomic) IBOutlet UITextView *name;
@property (weak, nonatomic) IBOutlet UILabel *price;

@end
