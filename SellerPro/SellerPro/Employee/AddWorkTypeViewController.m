//
//  AddWorkTypeViewController.m
//  SellerPro
//
//  Created by leiganzheng on 2017/5/10.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "AddWorkTypeViewController.h"

@interface AddWorkTypeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UITableView    *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@end


static NSString *const kDTMyCellIdentifier = @"myCellIdentifier";
@implementation AddWorkTypeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftBackNavItem];
    _saveBtn.frame = CGRectMake(0, KSCREEN_HEIGHT-108, KSCREEN_WIDTH, 44);
    _dataSource = @[@"权限一",@"权限二",@"权限三",@"权限四"];
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 110, KSCREEN_WIDTH-20, 200) style:UITableViewStylePlain];
    _myTableView.rowHeight = 50;
    _myTableView.delegate   = self;
    _myTableView.dataSource = self;
    _myTableView.backgroundColor = [UIColor whiteColor];
    _myTableView.separatorColor = DT_Base_LineColor;
    [_myTableView registerClass:[MGSwipeTableCell class] forCellReuseIdentifier:kDTMyCellIdentifier];
    [Tools configCornerOfView:_myTableView with:3];
    [self.view addSubview:_myTableView];
    self.title = @"添加工种";
    if (!self.isAdd) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"staffmanagement_btn_deleted"] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, 44, 44);
        [btn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        if (self.nameStr) {
            _name.text = self.nameStr;
               self.title = @"修改工种";
        }
    }else{
        self.workType = @"";
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
   
}
- (void)tap{
    [_name resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGSwipeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kDTMyCellIdentifier];
//    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH-12, 300)];
    
        UIImageView *redV = [[UIImageView alloc] init];
        redV.frame = CGRectMake(0, 0, 22, 22);
        redV.image = [UIImage imageNamed:@"staffmanagement_btn_option_seleted"];
        [Tools configCornerOfView:redV with:3];
        cell.accessoryView = redV;
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGSwipeTableCell *myCell = (MGSwipeTableCell *)cell;
    myCell.textLabel.text = self.dataSource[indexPath.row];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (IBAction)save:(id)sender {
    if (self.name.text.length ==0 ) {
        [MBProgressHUD showError:@"输入内容" toView:self.view];
        return;
    }
    [DTNetManger addWorkTypeWith:self.workType name:self.name.text callBack:^(NSError *error, id response) {
        if (response) {
            [MBProgressHUD showError:@"提交成功" toView:self.view];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:error.description toView:self.view];
        }

    }];
}
-(void)delete:(id)sender{
    [DTNetManger delWorkTypeWith:self.workType callBack:^(NSError *error, id response) {
        if (response) {
            [MBProgressHUD showError:@"删除成功" toView:self.view];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:error.description toView:self.view];
        }
    }];
}


@end
