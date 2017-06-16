//
//  EmployeeViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/5/7.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "ServiceViewController.h"
#import "WorkTypeViewController.h"
#import "CarGoodViewController.h"
#import "CustomFooterView.h"

@interface ServiceViewController () <TabContainerDelegate,TabContainerDataSource>
@property (nonatomic) NSUInteger numberOfTabs;
@property (nonatomic,strong) CustomFooterView *footer;
@end

@implementation ServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = self;
    self.delegate = self;
    [self setLeftBackNavItem];
    self.title = @"服务内容";
    self.numberOfTabs = 2;   ///////当设置数量时，去调用setter方法去加载控件
    self.footer= [[CustomFooterView alloc]initWithFrame:CGRectMake(0, KSCREEN_HEIGHT-123, KSCREEN_WIDTH, 60)];
    self.footer.resultBlock = ^(NSString *name) {
            if (name.length ==0) {
                [MBProgressHUD showError:@"金额不能为空" toView:self.view];
                return;
            }
        [MBProgressHUD showMessag:@"申请中" toView:self.view];
        [DTNetManger staffWithdrawApply:name callBack:^(NSError *error, id response) {
            [MBProgressHUD hiddenFromView:self.view];
            if (response&&[response isKindOfClass:[NSString class]]) {
                NSString *temp = (NSString *)response;
                if ([temp isEqualToString:@"success"]) {
                    [MBProgressHUD showError:@"申请成功" toView:self.view];
                }else{
                    [MBProgressHUD showError:temp toView:self.view];
                }
            }
        }];

    };
    [self.view addSubview:self.footer];
}
-(void)footerView{

}
- (void)setNumberOfTabs:(NSUInteger)numberOfTabs {
    
    // Set numberOfTabs
    _numberOfTabs = numberOfTabs;
    
    // Reload data
    [self reloadData];
    
}


- (void)selectTabWithNumberThree {
    [self selectTabAtIndex:0];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Interface Orientation Changes
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    // Update changes after screen rotates
    [self performSelector:@selector(setNeedsReloadOptions) withObject:nil afterDelay:duration];
}

#pragma mark --TabContainerDataSource
-(NSUInteger)numberOfTabsForTabContainer:(TabContainerViewController *)tabContainer {
    return self.numberOfTabs;
}

-(UIView *)tabContainer:(TabContainerViewController *)tabContainer viewForTabAtIndex:(NSUInteger)index {
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.0];
    label.text = @"汽车商品";
    if (index == 1) {
        label.text = @"汽车服务";
    }
    
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    
    return label;
}

-(UIViewController *)tabContainer:(TabContainerViewController *)tabContainer contentViewControllerForTabAtIndex:(NSUInteger)index{
    if (index == 0) {
        WorkTypeViewController *cvc = [[WorkTypeViewController alloc] init];
        cvc.resultBlock = ^(NSString *num) {
            self.footer.ServiceTotal = num;
            
            NSString *temp = self.footer.goodTotal.length == 0 ? @"0" :  self.footer.goodTotal;
            self.footer.lb1.text = [NSString stringWithFormat:@"商品：¥%@ 服务：¥%@",temp,self.footer.ServiceTotal];
            self.footer.lb.text = [NSString stringWithFormat:@"合计：¥%li",[self.footer.goodTotal integerValue] + [self.footer.ServiceTotal integerValue]];
        };
        return cvc;
    }else{
        CarGoodViewController *cvc = [[CarGoodViewController alloc] init];
        cvc.resultBlock = ^(NSString *num) {
            self.footer.goodTotal = num;
            NSString *temp = self.footer.ServiceTotal.length == 0 ? @"0" :  self.footer.ServiceTotal;
            self.footer.lb1.text = [NSString stringWithFormat:@"商品：¥%@ 服务：¥%@",self.footer.goodTotal,temp];
             self.footer.lb.text = [NSString stringWithFormat:@"合计：¥%li",[self.footer.goodTotal integerValue] + [self.footer.ServiceTotal integerValue]];
        };
        return cvc;
    }
}


#pragma mark --TabContainerDelegate
-(CGFloat)heightForTabInTabContainer:(TabContainerViewController *)tabContainer {
    return 44;
}

-(UIColor *)tabContainer:(TabContainerViewController *)tabContainer colorForComponent:(TabContainerComponent)component withDefault:(UIColor *)color {
    switch (component) {
        case TabContainerIndicator:
            return [RGB(17, 157, 255) colorWithAlphaComponent:1];
        case TabContainerTabsView:
            return [[UIColor whiteColor] colorWithAlphaComponent:1];
        case TabContainerContent:
            return [[UIColor whiteColor] colorWithAlphaComponent:1];
        default:
            return color;
    }
}





@end

