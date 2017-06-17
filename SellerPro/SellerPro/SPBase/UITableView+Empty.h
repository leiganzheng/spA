//
//  UITableView+Empty.h
//  SellerPro
//
//  Created by leiganzheng on 2017/5/11.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Empty)
- (void) tableViewDisplayWitMsg:(NSString *) message ifNecessaryForRowCount:(NSUInteger) rowCount;
- (void) tableViewOtherDisplayWitMsg:(NSString *) message ifNecessaryForRowCount:(NSUInteger) rowCount;
@end
