//
//  CarInfoDetailViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/6/15.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "CarInfoDetailViewController.h"
#import "CarInfoDetailTableViewCell.h"
#import "CarInfoDetailLongTableViewCell.h"

@interface CarInfoDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *profile;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (nonatomic, strong) UITableView    *myTableView;
@property (weak, nonatomic) IBOutlet UIImageView *vipimg;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (nonatomic, strong) UILabel *price;

@end

static NSString *const kDTMyCellIdentifier = @"myCellIdentifier";
static NSString *const kDTMyCellIdentifierLong = @"myCellIdentifier1";
@implementation CarInfoDetailViewController
- (UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 182, KSCREEN_WIDTH, KSCREEN_HEIGHT-80) style:UITableViewStylePlain];
//        _myTableView.rowHeight = 44;
        _myTableView.delegate   = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = [UIColor clearColor];
        _myTableView.separatorColor = RGB(211, 217, 222);
        _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self featchData];
            
        }];
        [_myTableView registerNib:[UINib nibWithNibName:@"CarInfoDetailTableViewCell" bundle:nil] forCellReuseIdentifier:kDTMyCellIdentifier];
        [_myTableView registerNib:[UINib nibWithNibName:@"CarInfoDetailLongTableViewCell" bundle:nil] forCellReuseIdentifier:kDTMyCellIdentifierLong];
    }
    return _myTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.myTableView];
    self.title = @"订单详情";
    [self setLeftBackNavItem];
    self.bgView.image = [[UIImage imageNamed:@"Rectangle"] stretchableImageWithLeftCapWidth:1 topCapHeight:70];
    [self featchData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self featchData];
}
#pragma mark - tableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [tableView tableViewDisplayWitMsg:@"暂无数据" ifNecessaryForRowCount:self.dataSource.count];
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataSource[indexPath.row];
    if (dict.allValues.count>2) {
        return 44;
    }else{
        return 90;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 76;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,KSCREEN_WIDTH,76)];
    v.backgroundColor = [UIColor clearColor];
    
    UIImageView *img = [[UIImageView alloc] init];
    img.frame = CGRectMake(0,0,KSCREEN_WIDTH,76);
    img.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_Consumption list"]];
    [v addSubview:img];

    self.price = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, KSCREEN_WIDTH, 40)];
    self.price.textAlignment = NSTextAlignmentCenter;
    self.price.textColor = RGB(220, 107, 107);
    NSInteger num = 0;
    for (NSDictionary *dict in self.dataSource) {
        num = num + [[dict objectForKey:@"price"] integerValue];
    }
    self.price.text = [NSString stringWithFormat:@"共消费：%li",(long)num];
    [v addSubview:self.price];
    
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.dataSource[indexPath.row];
    if (dict.allValues.count>2) {
        CarInfoDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTMyCellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.name.text = dict[@"name"];
        cell.price.textColor = RGB(220, 107, 107);
        cell.price.text = [NSString stringWithFormat:@"¥%@",dict[@"price"]];
        return cell;
    }else{
        CarInfoDetailLongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTMyCellIdentifierLong];
        cell.backgroundColor = [UIColor whiteColor];
        cell.name.text = dict[@"name"];
        cell.price.textColor = RGB(220, 107, 107);
        cell.price.text = [NSString stringWithFormat:@"¥%@",dict[@"price"]];
        [cell.logo sd_setImageWithURL:[NSURL URLWithString:dict[@"picture"]] placeholderImage:[UIImage imageNamed:@""]];
        return cell;

    }

   
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    RecordTableViewCell *myCell = (RecordTableViewCell *)cell;
    //    NSDictionary *dict = self.dataSource[indexPath.row];
    //    myCell.name.text = [dict objectForKey:@"name"];
    //    myCell.time.text = [dict objectForKey:@"create_time"];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark -- private method

-(void)featchData{//粤S777ML
//    self.customID = @"1";
    [DTNetManger orderGetDetailWithID:self.customID callBack:^(NSError *error, id response) {
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)response;
             NSDictionary *dictOther = [dict objectForKey:@"customer"];
            self.name.text = [dictOther objectForKey:@"name"];
            self.phone.text = [dictOther objectForKey:@"phone"];
            
            self.price.text = [NSString stringWithFormat:@"共消费：%@",[dict objectForKey:@"price"]];
            NSString *state = [NSString stringWithFormat:@"%@",[dictOther objectForKey:@"status"]];
            NSString *str = @"label_Non-VIP";
            if ([state isEqualToString:@"1"]) {
                str = @"label_VIP";
            }
            self.vipimg.image = [UIImage imageNamed:str];
            
            self.dataSource = [NSMutableArray array];
           
            [self.dataSource addObjectsFromArray:[dict objectForKey:@"good"]];
            [self.dataSource addObjectsFromArray:[dict objectForKey:@"service"]];
            [self.myTableView reloadData];
        }else{
            if ([response isKindOfClass:[NSString class]]) {
                [MBProgressHUD showError:(NSString*)response toView:self.view];
            }
        }
        [self.myTableView.mj_header endRefreshing];
    }];
}




@end
