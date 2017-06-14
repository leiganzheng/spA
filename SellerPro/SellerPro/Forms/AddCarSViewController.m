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
@property (nonatomic, strong) NSArray *iconSource;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, assign) NSInteger page;
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
        _myTableView.rowHeight = 200;
        _myTableView.delegate   = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = [UIColor clearColor];
        _myTableView.separatorColor = [UIColor clearColor];
        _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self featchData];
            
        }];
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kDTMyCellIdentifier];
    }
    return _myTableView;
}
- (NSArray *)iconSource
{
    if (!_iconSource) {
        _iconSource = @[@"home_icon_form",@"home_btn_staff",@"home_btn_servement",@"home_btn_password_setting"];
    }
    return _iconSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人业绩";
    
    [self.view addSubview:self.myTableView];
    [self setLeftBackNavItem];
    self.page = 1;
    self.date =[NSString stringWithFormat:@"%@-%@", [Tools nowDateofYear] , [Tools nowDateofMonth]];
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
    return 40+(servicesArr.count/3) * (60 +6);
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
    v.backgroundColor = [UIColor lightGrayColor];
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn setTitle:[dict objectForKey:@"name"] forState:UIControlStateNormal];
    _btn.frame = CGRectMake(0, 10, 60, 24);
    [_btn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:_btn];
    
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTMyCellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
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
    [self gridWithCellWidth:(KSCREEN_WIDTH-32)/3 cellHeight:60 numPerRow:3 totalNum:servicesArr.count viewPadding:10 viewPaddingCell:6 superView:bgV dataSource:servicesArr];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *myCell = (UITableViewCell *)cell;

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
        [aLabel setTitle:dict[@"name"] forState:0];
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
-(void)subCell:(UIView*)v{
    // 创建一个装载九宫格的容器
    UIView *containerView = [[UIView alloc] init];
    [v addSubview:containerView];
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.layer.borderWidth = 1;
    containerView.layer.borderColor = [UIColor grayColor].CGColor;
    // 给该容器添加布局代码
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(40);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(160);
    }];
    // 为该容器添加宫格View
    for (int i = 0; i < 6; i++) {
        UIButton *temp = [UIButton buttonWithType:UIButtonTypeCustom];
//        temp.frame = CGRectMake(4, 45, containerView.bounds.size.width/3-8, 60);
        temp.backgroundColor = [UIColor lightGrayColor];
        [containerView addSubview:temp];
    }
    // 执行九宫格布局
//    [containerView.subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:4 leadSpacing:4 tailSpacing:4];
    [containerView.subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:4 leadSpacing:4 tailSpacing:4];
//    [containerView.subviews mas_distributeSudokuViewsWithFixedItemWidth:0 fixedItemHeight:0 fixedLineSpacing:10 fixedInteritemSpacing:20 warpCount:3 topSpacing:10 bottomSpacing:10 leadSpacing:10 tailSpacing:10];
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
