//
//  WorkTypeViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/5/8.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "WorkTypeViewController.h"
#import "DTMyTableViewCell.h"
#import "AddWorkTypeViewController.h"
#import "WorkTypeTableViewCell.h"
#import "CustomFooterView.h"
#import "ScanAddViewController.h"

@interface WorkTypeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView    *myTableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger totalMoney;
@end

static NSString *const kDTMyCellIdentifier = @"myCellIdentifier";
@implementation WorkTypeViewController
- (UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT-80) style:UITableViewStylePlain];
        _myTableView.rowHeight = 100;
        _myTableView.delegate   = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = [UIColor clearColor];
        _myTableView.separatorColor = [UIColor lightGrayColor];
//        _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            
//        }];
        [_myTableView registerNib:[UINib nibWithNibName:@"WorkTypeTableViewCell" bundle:nil] forCellReuseIdentifier:kDTMyCellIdentifier];
    }
    return _myTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.myTableView];
    self.dataSource = [NSMutableArray array];

    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark - tableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    [tableView tableViewDisplayWitMsg:@"暂无数据" ifNecessaryForRowCount:self.dataSource.count];
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.isAdd){
        return 0.01;
    }
    return 80;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (!self.isAdd) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,177,80)];
        v.backgroundColor = [UIColor clearColor];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(KSCREEN_WIDTH/2-88, 20, 177, 44);
        [btn setTitle:@"添加商品" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"btn_scanning barcode"] forState:0];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -20, 0.0, 0.0)];
        btn.backgroundColor = RGB(17, 157, 255);
        [btn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
        [v addSubview:btn];
        [Tools configCornerOfView:btn with:3];
        [Tools configCornerOfView:v with:3];

        return v;

    }
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkTypeTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:kDTMyCellIdentifier];
    cell1.backgroundColor = [UIColor whiteColor];
    cell1.selectionStyle =  UITableViewCellSelectionStyleNone;
    cell1.rightButtons = @[[MGSwipeButton buttonWithTitle:@"" icon:[UIImage imageNamed:@"btn_delete service"] backgroundColor:RGB(211, 217, 222) callback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
        NSIndexPath *index = [tableView indexPathForCell:cell];
        NSDictionary *d = self.dataSource[index.row];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        if (self.resultBlock) {
            NSInteger num = 0;
            for (NSDictionary *dict in self.dataSource) {
                num = num + [[dict objectForKey:@"price"] integerValue]*(cell1.resultBtn.titleLabel.text.integerValue);
            }
            self.totalMoney = num;
            _resultBlock([NSString stringWithFormat:@"%li",(long)self.totalMoney]);
        }
        [self.myTableView reloadData];
        return  YES;
    }]];

    cell1.rightSwipeSettings.transition = MGSwipeTransition3D;
    [cell1.deBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    [cell1.addBtn addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    return cell1;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkTypeTableViewCell *myCell = (WorkTypeTableViewCell *)cell;
    NSDictionary *dict = self.dataSource[indexPath.row];
    myCell.nameT.text = [dict objectForKey:@"name"];
    myCell.price.text = [NSString stringWithFormat:@"¥%@",[dict objectForKey:@"price"]];
    [myCell.img sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"picture"]] placeholderImage:[UIImage imageNamed:@"" ]];
    [myCell.resultBtn setTitle:@"1" forState:0];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(void)delete:(UIButton *)sender{
    WorkTypeTableViewCell *cell = (WorkTypeTableViewCell*)[[sender superview]superview];
    NSInteger num = cell.resultBtn.titleLabel.text.integerValue;
    NSIndexPath *indexPath = [self.myTableView indexPathForCell:cell];
    [cell.resultBtn setTitle:[NSString stringWithFormat:@"%li",(long)(num-1==0 ? 0 : num-1)] forState:0];
    if (self.resultBlock) {
        NSDictionary *dict = self.dataSource[indexPath.row];
        self.totalMoney = self.totalMoney - [[dict objectForKey:@"price"] integerValue];
        _resultBlock([NSString stringWithFormat:@"%li",(long)self.totalMoney]);
    }

}
-(void)add:(UIButton *)sender{
    WorkTypeTableViewCell *cell = (WorkTypeTableViewCell*)[[sender superview]superview];
    NSIndexPath *indexPath = [self.myTableView indexPathForCell:cell];
    NSInteger num = cell.resultBtn.titleLabel.text.integerValue;
    [cell.resultBtn setTitle:[NSString stringWithFormat:@"%li",(long)(num+1)] forState:0];
    if (self.resultBlock) {
        NSDictionary *dict = self.dataSource[indexPath.row];
        self.totalMoney = self.totalMoney + [[dict objectForKey:@"price"] integerValue];
        _resultBlock([NSString stringWithFormat:@"%li",(long)self.totalMoney]);
    }


}
#pragma mark -- private method
- (void)save:(UIButton *)sender{
//    UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
//    AddWorkTypeViewController *vc =[[AddWorkTypeViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//    NSMutableDictionary *valueD = [NSMutableDictionary dictionary];
//    [valueD setObject:@"金装美孚1号全合成机油1L 0W-40" forKey:@"name"];
//    [valueD setObject:@"100" forKey:@"price"];
//    [valueD setObject:@"price" forKey:@"picture"];
//    [self.dataSource addObject:valueD];
//    if (self.resultBlock) {
//        NSInteger num = 0;
//        for (NSDictionary *dict in self.dataSource) {
//            num = num + [[dict objectForKey:@"price"] integerValue];
//        }
//        self.totalMoney = num;
//        _resultBlock([NSString stringWithFormat:@"%li",(long)self.totalMoney]);
//    }
//    [self.myTableView reloadData];
    ScanAddViewController *vc = [[ScanAddViewController alloc] init];
    vc.resultBlock = ^(NSDictionary *dict) {
        if (dict) {
            [self.dataSource addObject:dict];
            if (self.resultBlock) {
                NSInteger num = 0;
                for (NSDictionary *dict in self.dataSource) {
                    num = num + [[dict objectForKey:@"price"] integerValue];
                }
                self.totalMoney = num;
                _resultBlock([NSString stringWithFormat:@"%li",(long)self.totalMoney]);
            }
            [self.myTableView reloadData];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)featchData{

}
@end

