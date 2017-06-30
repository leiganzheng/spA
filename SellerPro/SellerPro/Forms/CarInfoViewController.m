//
//  CarInfoViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/5/30.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "CarInfoViewController.h"
#import "ServiceViewController.h"
#import "RecordTableViewCell.h"
#import "LoadCarInfoViewController.h"

@interface CarInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *profile;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *baoxian;
@property (weak, nonatomic) IBOutlet UILabel *weizhang;
@property (weak, nonatomic) IBOutlet UILabel *nianjian;
@property (nonatomic, strong) UITableView    *myTableView;
@property (weak, nonatomic) IBOutlet UIImageView *vipimg;
@property (nonatomic, strong) NSArray *dataSource;
@property (weak, nonatomic) IBOutlet UIImageView *bgview;
@property (nonatomic, assign) BOOL isUpdate;
@end

static NSString *const kDTMyCellIdentifier = @"myCellIdentifier";
@implementation CarInfoViewController
- (UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 241, KSCREEN_WIDTH, KSCREEN_HEIGHT-80) style:UITableViewStylePlain];
        _myTableView.rowHeight = 50;
        _myTableView.delegate   = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = [UIColor clearColor];
        _myTableView.separatorColor = [UIColor clearColor];
        _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self featchData];
            
        }];
        [_myTableView registerNib:[UINib nibWithNibName:@"RecordTableViewCell" bundle:nil] forCellReuseIdentifier:kDTMyCellIdentifier];
    }
    return _myTableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.myTableView];
    self.title = @"车辆概况";
    [self setLeftBackNavItem];
    self.isUpdate = NO;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, KSCREEN_HEIGHT-108, KSCREEN_WIDTH, 44);
    [btn setTitle:@"录入服务内容" forState:UIControlStateNormal];
    btn.backgroundColor = RGB(17, 157, 255);
    [btn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    self.bgview.image = [[UIImage imageNamed:@"Rectangle"] stretchableImageWithLeftCapWidth:1 topCapHeight:70];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateInfo)];
//    [self.profile addGestureRecognizer:tap];
//    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 0, self.profile.bounds.size.width, self.profile.bounds.size.height);
    btn1.backgroundColor = [UIColor clearColor];
    [btn1 addTarget:self action:@selector(updateInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.profile addSubview:btn1];
    
//    [self featchData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self featchData];
}
#pragma mark - tableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [tableView tableViewDisplayWitMsg:@"该车主暂无消费记录" ifNecessaryForRowCount:self.dataSource.count];
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTMyCellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ((self.dataSource.count - 1)==indexPath.row) {
        cell.lastlIne.hidden = YES;
    }else{
        cell.lastlIne.hidden = NO;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordTableViewCell *myCell = (RecordTableViewCell *)cell;
    NSDictionary *dict = self.dataSource[indexPath.row];
    myCell.name.text = [dict objectForKey:@"name"];
    myCell.time.text = [dict objectForKey:@"create_time"];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark -- private method
-(void)updateInfo{
    if (self.isUpdate) {
        UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
        LoadCarInfoViewController *cvc = [board instantiateViewControllerWithIdentifier:@"LoadCarInfoViewController"];
        cvc.licenseImage= self.licenseImage;
        cvc.plate_license = self.plate_license;
        cvc.vc = self.vc;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:cvc];
        [self presentViewController:nav animated:YES completion:nil];
    }
}
-(void)featchData{//粤S777ML
    [DTNetManger customerGetWith:self.plate_license callBack:^(NSError *error, id response) {
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
                if ([(NSString*)response isEqualToString:@"401"]) {
                     [MBProgressHUD showError:@"暂无数据" toView:self.view];
                     self.isUpdate = YES;
                }else{
                    [MBProgressHUD showError:(NSString*)response toView:self.view];
                    self.isUpdate = NO;
                }
            }
        }
        [self.myTableView.mj_header endRefreshing];
    }];
}

- (void)save:(id)sender {
    ServiceViewController *vc = [[ServiceViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
