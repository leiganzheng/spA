//
//  ContentViewController.h
//  ICViewPager
//
//  Created by Ilter Cengiz on 28/08/2013.
//  Copyright (c) 2013 Ilter Cengiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTBaseViewController.h"
@interface ContentViewController : DTBaseViewController

@property NSString *labelString;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end
