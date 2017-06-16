//
//  BanksViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/6/14.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "BanksViewController.h"

@interface BanksViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView    *myTableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSMutableArray *flagSource;
@property (nonatomic,strong)UIButton *btn;

@end

static NSString *const kDTMyCellIdentifier = @"myCellIdentifier";
@implementation BanksViewController
- (UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT-114) style:UITableViewStylePlain];
        _myTableView.rowHeight = 60;
        _myTableView.delegate   = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = [UIColor clearColor];
        _myTableView.separatorColor = [UIColor lightGrayColor];
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kDTMyCellIdentifier];
    }
    return _myTableView;
}
- (NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = @[@"中国银行",@"中国建设银行",@"中国农业银行",@"中国工商银行",@"民生银行",@"招商银行",@"兴业银行",@"中信实业银行",@"恒丰银行",@"广东发展银行",@"深圳发展银行",@"光大银行",@"交通银行",@"华夏银行",@"上海浦东发展银行"];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"银行列表";
    _flagSource = [NSMutableArray arrayWithObjects:@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1", nil];
    for (int i=0; i<_dataSource.count; i++) {
        NSString *temp = self.dataSource[i];
        if ([self.name isEqualToString:temp]) {
            [_flagSource replaceObjectAtIndex:i withObject:@"0"];
        }
    }
    [self.view addSubview:self.myTableView];
    [self setLeftBackNavItem];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark - tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTMyCellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
   
    cell.textLabel.text = self.dataSource[indexPath.row];
    UIButton *arrBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *str = self.flagSource[indexPath.row];
    if ([str isEqualToString:@"0"]) {
         [arrBtn setImage:[UIImage imageNamed:@"staffmanagement_btn_option_seleted-1"] forState:0];
    }else{
         [arrBtn setImage:[UIImage imageNamed:@""] forState:0];
    }
   
    arrBtn.frame = CGRectMake(0, 10, 60, 24);
    cell.accessoryView = arrBtn;

    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *myCell = (UITableViewCell *)cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    for (int i=0; i<self.flagSource.count; i++) {
        if (i==indexPath.row) {
            [_flagSource replaceObjectAtIndex:indexPath.row withObject:@"0"];
        }else{
            [_flagSource replaceObjectAtIndex:indexPath.row withObject:@"1"];
        }
    }
    
    [self.myTableView reloadData];
    if (self.resultBlock) {
        self.resultBlock(self.dataSource[indexPath.row]);
    }
}
- (void)save:(UIButton *)sender{
    
    
}

@end

