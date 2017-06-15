//
//  CarInfoDetailViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/6/15.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "CarInfoDetailViewController.h"
#import "RecordTableViewCell.h"

@interface CarInfoDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *profile;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *baoxian;
@property (weak, nonatomic) IBOutlet UILabel *weizhang;
@property (weak, nonatomic) IBOutlet UILabel *nianjian;
@property (nonatomic, strong) UITableView    *myTableView;
@property (weak, nonatomic) IBOutlet UIImageView *vipimg;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *iconSource;

@end

static NSString *const kDTMyCellIdentifier = @"myCellIdentifier";
@implementation CarInfoDetailViewController
- (UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 241, KSCREEN_WIDTH, KSCREEN_HEIGHT-80) style:UITableViewStylePlain];
        _myTableView.rowHeight = 44;
        _myTableView.delegate   = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = [UIColor clearColor];
        _myTableView.separatorColor = [UIColor clearColor];
        _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self featchData];
            
        }];
        [_myTableView registerNib:[UINib nibWithNibName:@"CarInfoDetailTableViewCell" bundle:nil] forCellReuseIdentifier:kDTMyCellIdentifier];
    }
    return _myTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.myTableView];
    self.title = @"订单详情";
    [self setLeftBackNavItem];
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
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 80;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,KSCREEN_WIDTH,80)];
    v.backgroundColor = [UIColor lightGrayColor];
    
    UIImageView *img = [[UIImageView alloc] init];
    img.frame = CGRectMake(0,0,KSCREEN_WIDTH,140);
    img.image = [UIImage imageNamed:@"staffmanagement_img_bg"];
    [v addSubview:img];

    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, KSCREEN_WIDTH, 40)];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.textColor = [UIColor whiteColor];
    [v addSubview:lb];
    
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTMyCellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordTableViewCell *myCell = (RecordTableViewCell *)cell;
    //    NSDictionary *dict = self.dataSource[indexPath.row];
    //    myCell.name.text = [dict objectForKey:@"name"];
    //    myCell.time.text = [dict objectForKey:@"create_time"];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark -- private method

-(void)featchData{//粤S777ML
    [DTNetManger customerGetWith:@"" callBack:^(NSError *error, id response) {
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)response;
            self.name.text = [dict objectForKey:@"name"];
            self.phone.text = [dict objectForKey:@"phone"];
            self.baoxian.text = [dict objectForKey:@"insurance_end_time"];
            self.nianjian.text = [dict objectForKey:@"yearly_inspection_end_time"];
            self.dataSource = [dict objectForKey:@"records"];
            self.weizhang.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"count_illegal"]];
            NSString *state = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
            NSString *str = @"label_Non-VIP";
            if ([state isEqualToString:@"1"]) {
                str = @"label_VIP";
            }
            self.vipimg.image = [UIImage imageNamed:str];
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
