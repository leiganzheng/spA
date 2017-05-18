//
//  FromsMViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/5/7.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "FromsMViewController.h"
#import "FPPopoverController.h"
#import "TimeViewController.h"
#import "SFormViewController.h"
#import "PersionViewController.h"
#import "ProgramViewController.h"

@interface FromsMViewController () <TabContainerDelegate,TabContainerDataSource,TimeViewControllerDelegate>
@property (nonatomic) NSUInteger numberOfTabs;
@property (nonatomic,strong) FPPopoverController*popover;
@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,strong)SFormViewController *formVc;
@property (nonatomic,strong)PersionViewController *personVc;
@property (nonatomic,strong)ProgramViewController *programVc;
@property (nonatomic,assign) NSInteger currentIndex;
@end

@implementation FromsMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = self;
    self.delegate = self;
    [self setLeftBackNavItem];
    self.title = @"业绩报表";
    self.numberOfTabs = 3;   ///////当设置数量时，去调用setter方法去加载控件
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn setTitle:@"2017-04" forState:UIControlStateNormal];
    [_btn setImage:[UIImage imageNamed:@"home_btn_dropdown"] forState:UIControlStateNormal];
    _btn.frame = CGRectMake(0, 0, 80, 44);
    _btn.titleEdgeInsets = UIEdgeInsetsMake(0, -_btn.imageView.frame.size.width - _btn.frame.size.width + _btn.titleLabel.intrinsicContentSize.width, 0, 0);
    _btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -_btn.titleLabel.frame.size.width - _btn.frame.size.width + _btn.imageView.frame.size.width);
    [_btn addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_btn];
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
    if (index == 0) {
        label.text = @"服务单";
    }
    if (index == 1) {
        label.text = @"个人榜";
    }
    if (index == 2) {
        label.text = @"项目榜";
    }

    
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    
    return label;
}

-(UIViewController *)tabContainer:(TabContainerViewController *)tabContainer contentViewControllerForTabAtIndex:(NSUInteger)index {
    if (index == 0) {
        _formVc = [[SFormViewController alloc] init];
        return _formVc;
    }else if (index == 1){
        _personVc = [[PersionViewController alloc] init];
        return _personVc;
    }else{
        _programVc = [[ProgramViewController alloc] init];
        return _programVc;
    }
}
-(void)tabContainer:(TabContainerViewController *)tabContainer didChangeTabToIndex:(NSUInteger)index{
    self.currentIndex = index;
}
#pragma mark -- private method
- (void)select:(UIButton*)sender{
    TimeViewController *vc = [[TimeViewController alloc]init];
    vc.delegate = self;
    _popover = [[FPPopoverController alloc] initWithViewController:vc];
    _popover.contentSize = CGSizeMake(200, 300);
    _popover.arrowDirection = UIMenuControllerArrowUp;
    [_popover presentPopoverFromView:sender];
}

#pragma mark --TimeViewControllerDelegate
- (void)didSelectedDate:(NSString *)date{
    [_btn setTitle:date forState:UIControlStateNormal];
    [_popover dismissPopoverAnimated:YES];
    if (self.currentIndex == 0) {
        [_formVc featchDataWithDate:date];
    }else if (self.currentIndex == 1){
       [_personVc featchDataWithDate:date];
    }else{
        [_programVc featchDataWithDate:date];
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
            return [[UIColor blackColor] colorWithAlphaComponent:1];
        case TabContainerContent:
            return [[UIColor whiteColor] colorWithAlphaComponent:1];
        default:
            return color;
    }
}
@end

