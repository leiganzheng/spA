//
//  AddCarSViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/6/8.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "AddCarSViewController.h"
#import "AddEmployeeViewController.h"
#import "Masonry.h"

@interface AddCarSViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView    *myTableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSDictionary *dataDict;
@property (nonatomic, strong) UILabel *sum;
@property (nonatomic, strong) UILabel *customerSum;
@property (nonatomic,strong)UIButton *btn;


@end

static NSString *const kDTMyCellIdentifier = @"myCellIdentifier";
@implementation AddCarSViewController
- (UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT) style:UITableViewStylePlain];
        _myTableView.delegate   = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = [UIColor clearColor];
        _myTableView.separatorColor = [UIColor clearColor];
        _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self featchData];
            
        }];
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kDTMyCellIdentifier];
    }
    return _myTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择服务";
    
    [self.view addSubview:self.myTableView];
    [self setLeftBackNavItem];
    [self featchData];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark - tableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dict = self.dataSource[section];
    NSArray *arr = [dict objectForKey:@"sub"];
    return arr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataSource[indexPath.section];
    NSArray *arr = [dict objectForKey:@"sub"];
    NSDictionary *valueDict = arr[indexPath.row];
    NSArray *servicesArr = valueDict[@"service"];
    if (servicesArr.count>2) {
        return 42+ (servicesArr.count/3+servicesArr.count%3)*(50+10)+20;
    }else if(servicesArr.count==2){
        return 42+50+8;
    }else{
        return 42;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSDictionary *dict = self.dataSource[section];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,KSCREEN_WIDTH,40)];
    v.backgroundColor = RGB(211, 217, 222);
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn setTitle:[dict objectForKey:@"name"] forState:UIControlStateNormal];
    _btn.frame = CGRectMake(0, 10, 60, 24);
    [_btn setTitleColor:[UIColor lightGrayColor] forState:0];
    [_btn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:_btn];
    
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTMyCellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dict = self.dataSource[indexPath.section];
    NSArray *arr = [dict objectForKey:@"sub"];
    NSDictionary *valueDict = arr[indexPath.row];
    
    UILabel *lb= [[UILabel alloc] init];
    lb.text = [valueDict objectForKey:@"name"];
    lb.frame = CGRectMake(10, 10, 100, 24);
    [cell.contentView addSubview:lb];
    UIButton *temp = [UIButton buttonWithType:UIButtonTypeCustom];
    temp.frame = CGRectMake(KSCREEN_WIDTH-30, 10, 24, 24);
    [temp setImage:[UIImage imageNamed:@"home_btn_next"] forState:0];
    [cell.contentView addSubview:temp];
    
    UIView *bgV = [[UIView alloc] init];
    bgV.frame = CGRectMake(0, 42, KSCREEN_WIDTH, 160);
    [cell.contentView addSubview:bgV];
    NSArray *servicesArr = valueDict[@"service"];
    if (servicesArr.count>2) {
        [self gridWithCellWidth:(KSCREEN_WIDTH-32)/3 cellHeight:50 numPerRow:3 totalNum:servicesArr.count viewPadding:10 viewPaddingCell:6 superView:bgV dataSource:servicesArr];

    }else{
        [self gridWithCellWidth:(KSCREEN_WIDTH-32)/2 cellHeight:50 numPerRow:2 totalNum:servicesArr.count viewPadding:10 viewPaddingCell:6 superView:bgV dataSource:servicesArr];

    }
       return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)save:(UIButton *)sender{
 
    
}
- (void)gridWithCellWidth:(CGFloat)cellWidth
               cellHeight:(CGFloat)cellHeight
                numPerRow:(NSInteger)numPerRow
                 totalNum:(NSInteger)totalNum
              viewPadding:(CGFloat)viewPadding
          viewPaddingCell:(CGFloat)viewPaddingCell
                superView:(UIView *)superView
               dataSource:(NSArray *)data

{
    
    __block UIButton *lastView = nil;// 创建一个空view 代表上一个view
    __block UIButton *lastRowView;// 创建一个空view 代表上一行view
    
    __block NSInteger lastRowNo = 0;//上一行的行号
    NSMutableArray *cells = [[NSMutableArray alloc] init];
    
    
    for (int i = 0; i < totalNum; i++) {
        NSDictionary *dict = data[i];
        UIButton *aLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        [Tools configCornerOfView:aLabel with:3];
        [aLabel setTitleColor:[UIColor blackColor] forState:0];
        [aLabel addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
        [aLabel setTitle:dict[@"name"] forState:0];
        aLabel.tag = i;
        aLabel.titleLabel.textAlignment = NSTextAlignmentCenter;
        [superView addSubview:aLabel];
        aLabel.backgroundColor = RGB(211, 217, 222);
        [cells addObject:aLabel];
    }
    
    // 循环创建view
    for (int i = 0; i < cells.count; i++)
    {
        
        UIButton *lb = cells[i];
        
        
        BOOL isFirstRow = [self isFirstRowWithIndex:i numOfRow:numPerRow];
        BOOL isFirstCol = [self isFirstColumnWithIndex:i numOfRow:numPerRow];
        
        BOOL isLastCol = [self isLastColumnWithIndex:i numOfRow:numPerRow totalNum:totalNum];
        BOOL isLastRow = [self isLastRowWithIndex:i numOfRow:numPerRow totalNum:totalNum];
        
        NSInteger curRowNo = i/numPerRow;
        if (curRowNo != lastRowNo)
        {//如果当前行与上一个view行不等，说明换行了
            lastRowView = lastView;
            lastRowNo = curRowNo;
        }
        
        // 添加约束
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(cellWidth));
            make.height.equalTo(@(cellHeight));
            
            if (isFirstRow)
            {
                make.top.equalTo(superView.mas_top).with.offset(viewPadding);
            }
            else
            {
                if (lastRowView)
                {
                    make.top.equalTo(lastRowView.mas_bottom).with.offset(viewPaddingCell);
                }
            }
            
            if (isFirstCol)
            {
                make.left.equalTo(superView.mas_left).with.offset(viewPadding);
            }
            else
            {
                if (lastView)
                {
                    make.left.equalTo(lastView.mas_right).with.offset(viewPaddingCell);
                }
            }
            
            if (isFirstRow && isLastCol)
            {
                make.right.equalTo(superView.mas_right).with.offset(-viewPadding);
            }
            
//            if (isLastRow && isFirstCol)
//            {
//                make.bottom.equalTo(superView.mas_bottom).with.offset(-viewPadding);
//            }
            
        }];
        
        
        
        // 每次循环结束 此次的View为下次约束的基准
        lastView = lb;
    }
}
- (BOOL)isFirstRowWithIndex:(NSInteger)index numOfRow:(NSInteger)numOfRow
{
    if (numOfRow != 0)
    {
        return index/numOfRow == 0;
    }
    return NO;
}
- (BOOL)isFirstColumnWithIndex:(NSInteger)index numOfRow:(NSInteger)numOfRow
{
    if (numOfRow != 0)
    {
        return index%numOfRow == 0;
    }
    return NO;
}
- (BOOL)isLastRowWithIndex:(NSInteger)index numOfRow:(NSInteger)numOfRow totalNum:(NSInteger)totalNum
{
    NSInteger totalRow = ceil(totalNum/((CGFloat)numOfRow));//总行数
    
    if (numOfRow != 0)
    {
        return index/numOfRow == totalRow - 1;
    }
    return NO;
}
- (BOOL)isLastColumnWithIndex:(NSInteger)index numOfRow:(NSInteger)numOfRow totalNum:(NSInteger)totalNum
{
    if (numOfRow != 0)
    {
        if (totalNum < numOfRow)
        {//总数小于每行最大个数时，如果index是最后一个，那么也是最后一列
            return index == totalNum-1;
        }
        return index%numOfRow == numOfRow - 1;
    }
    return NO;
}
-(void)select:(UIButton *)sender{
    UITableViewCell *cell = (UITableViewCell*)[[[sender superview]superview] superview];
    NSIndexPath *indexPath = [self.myTableView indexPathForCell:cell];
    NSMutableDictionary *valueD = [NSMutableDictionary dictionary];
    
    NSDictionary *dict = self.dataSource[indexPath.section];
    NSArray *arr = [dict objectForKey:@"sub"];
    NSDictionary *valueDict = arr[indexPath.row];
    
    [valueD setObject:dict[@"short"] forKey:@"short"];
    
    NSArray *servicesArr = valueDict[@"service"];
    NSDictionary *valueDict1 = servicesArr[sender.tag];
    
     [valueD setObject:valueDict1[@"name"] forKey:@"name"];
    [valueD setObject:valueDict1[@"price"] forKey:@"price"];
    if (_resultBlock) {
        _resultBlock(valueD);
        [self.navigationController popViewControllerAnimated:YES];
    }

}
-(void)featchData{
    [DTNetManger serviceGetCategoryList:^(NSError *error, id response) {
        if (response && [response isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray*)response;
                self.dataSource = [[NSMutableArray alloc] init];
                [self.dataSource removeAllObjects];
                if (arr.count>0) {
                    [self.dataSource addObjectsFromArray:arr];
                    [_myTableView reloadData];
                }else{
                    [MBProgressHUD showError:@"暂无数据" toView:self.view];
                }
                [self.myTableView.mj_header endRefreshing];
        }else{
            if ([response  isKindOfClass:[NSString class]]) {
                [MBProgressHUD showError:(NSString *)response toView:self.view];
                [self.myTableView.mj_header endRefreshing];
                [self.myTableView.mj_footer endRefreshing];
            }
        }
        
    }];
}
@end
