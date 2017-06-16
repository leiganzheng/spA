//
//  DTNetManger.h
//  DouTu
//
//  Created by yuepengfei on 17/3/14.
//  Copyright © 2017年 fly. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DTBaseModel;

typedef void(^callBack)(NSError *error, id response);
typedef void(^detailCallBack) (NSError *error, NSArray *response, DTBaseModel *detailModel);

@interface DTNetManger : NSObject
//@property(nonatomic,strong) NSString* token;
//@property(nonatomic,strong) NSString* rtoken;
//登录
+(void)loginWith:(NSString*)iphone
            PW:(NSString*)passWord
            callBack:(callBack)callBack;
//获取验证码
+(void)verifyCodeWith:(NSString*)phone
             callBack:(callBack)callBack;
//校验验证码
+(void)checkVerifyCodeWith:(NSString*)phone
                      code:(NSString*)verifyCode
                  callBack:(callBack)callBack;
//修改密码
+(void)modifyPassWordWith:(NSString*)phone
                        PW:(NSString*)passWord
                      code:(NSString*)verifyCode
                  callBack:(callBack)callBack;
//获取员工佣金
+(void)staffGetCommission:(callBack)callBack;
//获取员工银行卡
+(void)staffGetCreditCard:(callBack)callBack;
//设置员工银行卡
+(void)staffSetCreditCardWith:(NSString*)bank
                  credit_card:(NSString*)credit_card
                     callBack:(callBack)callBack;
//获取客户数量业绩统计
+(void)orderSumWith:(NSString*)date
                     callBack:(callBack)callBack;
//获取员工业绩分页
+(void)orderGetStaffPageWith:(NSString *)page
                       size:(NSString *)size
                       date:(NSString*)date
                 callBack:(callBack)callBack;
//获取服务单明细
+(void)orderGetDetailWithID:(NSString *)customID callBack:(callBack)callBack;
//获取服务分类列表
+(void)serviceGetCategoryList:(callBack)callBack;
//车牌识别
+(void)customerOcrWith:(NSString*)plate_license_base64  //车牌照片base64
           callBack:(callBack)callBack;
//获取客户信息
+(void)customerGetWith:(NSString*)plate_license  //车牌号
              callBack:(callBack)callBack;

/*name	否	string	姓名
phone	是	string	手机号
car_type	是	string	车辆类型
car_band	否	string	车辆品牌
car_model	否	string	车辆型号
plate_license	是	string	车牌号
engine_number	否	string	发动机号
frame_number	否	string	车架号
buy_time	否	string	注册日期
drive_license	否	string	行驶证图片base64
yearly_inspection_location	否	string	年检地点
yearly_inspection_end_time	否	string	年检到期时间
insurance_company	否	string	保险公司
insurance_end_time	否	string	保险到期时间*/
//补录客户资料
+(void)customerAddWith:(NSDictionary*)info
              callBack:(callBack)callBack;
//获取佣金记录
+(void)staffMoneyGetPageWith:(NSString *)page
                        size:(NSString *)size
                    callBack:(callBack)callBack;
//获取提现记录
+(void)staffWithdrawGetPageWith:(NSString *)page
                        size:(NSString *)size
                    callBack:(callBack)callBack;
//申请结算
+(void)staffWithdrawApply:(NSString*)money  //float	金额
              callBack:(callBack)callBack;
//获取商品信息
+(void)goodGetWith:(NSString *)barcode //条码
                        type:(NSString *)type //商品类型（1->供应商供货，2->商家自购）
                    callBack:(callBack)callBack;
@end
