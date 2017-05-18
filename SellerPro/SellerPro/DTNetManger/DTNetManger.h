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

//获取服务单分页
+(void)orderPageWith:(NSString *)page
                       size:(NSString *)size
                       date:(NSString*)date
                 callBack:(callBack)callBack;
//获取员工业绩分页
+(void)orderStaffPageWith:(NSString *)page
                     size:(NSString *)size
                     date:(NSString*)date
                 callBack:(callBack)callBack;
//获取服务项目业绩分页
+(void)orderServicePageWith:(NSString *)page
                     size:(NSString *)size
                     date:(NSString*)date
                 callBack:(callBack)callBack;
//获取工种列表
+(void)workStypeListWithCallBack:(callBack)callBack;
//获取工种注册地址
+(void)getUrlOfWorkTypeWith:(NSString *)typeId
                    callBack:(callBack)callBack;
//获取工种资料
+(void)getUrlOfWorkInfoWith:(NSString *)typeId
                    callBack:(callBack)callBack;
//添加/修改工种
+(void)addWorkTypeWith:(NSString *)typeId
                      name:(NSString*)name
                  callBack:(callBack)callBack;
//删除工种
+(void)delWorkTypeWith:(NSString *)typeId
                    callBack:(callBack)callBack;
//获取服务分类列表
+(void)seviceListWithCallBack:(callBack)callBack;
//获取服务项目资料
+(void)getServiceInfoWith:(NSString*)typeId
                   callBack:(callBack)callBack;
//添加/修改服务项目
+(void)addServiceWith:(NSString*)service_id
                 categoryId:(NSString*)categoryId
                 name:(NSString*)name
                  price:(NSString*)price
              callBack:(callBack)callBack;
//删除服务项目
+(void)delServiceTypeWith:(NSString*)serviceId
              callBack:(callBack)callBack;
//获取员工分页
+(void)StaffPageWith:(NSString*)page
                       size:(NSString*)size
                   callBack:(callBack)callBack;
//获取员工资料
+(void)getStaffInfoWith:(NSString*)staffId
                 callBack:(callBack)callBack;
//修改员工
+(void)addStaffWith:(NSString*)staff_id
       work_type_id:(NSString*)work_type_id
               name:(NSString*)name
        is_disabled:(NSString*)is_disabled //状态(0->在职，1->离职)
             callBack:(callBack)callBack;
//删除员工
+(void)delStaffInfoWith:(NSString*)staffId
               callBack:(callBack)callBack;
@end
