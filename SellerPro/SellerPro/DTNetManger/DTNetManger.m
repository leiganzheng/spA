//
//  DTNetManger.m
//  DouTu
//
//  Created by yuepengfei on 17/3/14.
//  Copyright © 2017年 fly. All rights reserved.
//

#import "DTNetManger.h"

@implementation DTNetManger

+ (void)requestFailedCallBack:(callBack)callBack
{
    if (callBack) {
        NSError *error = [[self class] errorWithCode:0 description:nil];
        callBack(error,nil);
    }
}
+ (NSError *)errorWithCode:(int)code description:(NSString *)description
{
    NSString *msg = description ? description : @"";
    NSDictionary *infoDic = [NSDictionary dictionaryWithObject:msg forKey:NSLocalizedDescriptionKey];
    NSError *error = [NSError errorWithDomain:@"BizYixinErrorDomain" code:code userInfo:infoDic];
    return error;
}
//登录
+(void)loginWith:(NSString *)iphone PW:(NSString*)passWord callBack:(callBack)callBack{
    [Tools configOrignNetWork];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         iphone,@"phone",
                         passWord,@"password",
                         nil];
    [HYBNetworking postWithUrl:kDTLoginUrl refreshCache:YES params:dic success:^(id response) {
       NSString *code = [(NSDictionary*)response objectForKey:@"code"];
       if (code.integerValue == 0) {
           if (callBack) {
               NSDictionary *dic = [(NSDictionary*)response objectForKey:@"data"];
               callBack(nil,dic);
           }
       }else{
           [DTNetManger requestFailedCallBack:callBack];
       }
    } fail:^(NSError *error) {
        [DTNetManger requestFailedCallBack:callBack];
    }];
}
//获取验证码
+(void)verifyCodeWith:(NSString *)phone callBack:(callBack)callBack{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         phone,@"phone",
                         nil];
    [HYBNetworking postWithUrl:kDVerifyCodeUrl refreshCache:YES params:dic success:^(id response) {
        NSString *code = [(NSDictionary*)response objectForKey:@"code"];
        if (code.integerValue == 0) {
            if (callBack) {
                callBack(nil,response);
            }
        }else{
            callBack(nil,response);
        }
    } fail:^(NSError *error) {
        [DTNetManger requestFailedCallBack:callBack];
    }];

}
//校验验证码
+(void)checkVerifyCodeWith:(NSString *)phone code:(NSString *)verifyCode callBack:(callBack)callBack{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         phone,@"phone",
                         verifyCode,@"verify_code",
                         nil];
    [HYBNetworking postWithUrl:kDTCheckVerifyCodeUrl refreshCache:YES params:dic success:^(id response) {
        NSString *code = [(NSDictionary*)response objectForKey:@"code"];
        if (code.integerValue == 0) {
            if (callBack) {
                callBack(nil,response);
            }
        }else{
            [DTNetManger requestFailedCallBack:callBack];
        }
    } fail:^(NSError *error) {
        [DTNetManger requestFailedCallBack:callBack];
    }];

}
////修改密码
+(void)modifyPassWordWith:(NSString *)phone PW:(NSString *)passWord code:(NSString *)verifyCode callBack:(callBack)callBack{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         phone,@"phone",
                         passWord,@"password",
                         verifyCode,@"verify_code",
                         nil];
    [HYBNetworking postWithUrl:kDTMpasswordUrl refreshCache:YES params:dic success:^(id response) {
        NSString *code = [(NSDictionary*)response objectForKey:@"code"];
        if (code.integerValue == 0) {
            if (callBack) {
                callBack(nil,response);
            }
        }else{
            [DTNetManger requestFailedCallBack:callBack];
        }
    } fail:^(NSError *error) {
        [DTNetManger requestFailedCallBack:callBack];
    }];

}
//获取服务单分页
+(void)orderPageWith:(NSString *)page size:(NSString *)size date:(NSString *)date callBack:(callBack)callBack{
    [Tools configOrignNetWork];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         page,@"page",
                         size,@"size",
                         date,@"date",
                         nil];
    [HYBNetworking postWithUrl:kDTGetPageUrl refreshCache:YES params:dic success:^(id response) {
        NSString *code = [(NSDictionary*)response objectForKey:@"code"];
        if (code.integerValue == 0) {
            if (callBack) {
                NSArray *arr = [(NSDictionary*)response objectForKey:@"data"];
                callBack(nil,arr);
            }
        }else{
            if (code.integerValue == 401) {
                callBack(nil,[NSArray array]);
            }else{
                callBack(nil,[(NSDictionary*)response objectForKey:@"msg"]);
            };
        }
    } fail:^(NSError *error) {
        [DTNetManger requestFailedCallBack:callBack];
    }];

}
//获取员工业绩分页
+(void)orderStaffPageWith:(NSString *)page size:(NSString *)size date:(NSString *)date callBack:(callBack)callBack{
    [Tools configOrignNetWork];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         page,@"page",
                         size,@"size",
                         date,@"date",
                         nil];
    [HYBNetworking postWithUrl:kDTGetStaffPageUrl refreshCache:YES params:dic success:^(id response) {
        NSString *code = [(NSDictionary*)response objectForKey:@"code"];
        if (code.integerValue == 0) {
            if (callBack) {
                NSArray *arr = [(NSDictionary*)response objectForKey:@"data"];
                callBack(nil,arr);
            }
        }else{
            if (code.integerValue == 401) {
                callBack(nil,[NSArray array]);
            }else{
             callBack(nil,[(NSDictionary*)response objectForKey:@"msg"]);
            }
        }
    } fail:^(NSError *error) {
        [DTNetManger requestFailedCallBack:callBack];
    }];

}
//获取服务项目业绩分页
+(void)orderServicePageWith:(NSString *)page
                       size:(NSString *)size
                       date:(NSString*)date
                   callBack:(callBack)callBack{
    [Tools configOrignNetWork];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         page,@"page",
                         size,@"size",
                         date,@"date",
                         nil];
    [HYBNetworking postWithUrl:kDTGetServicePageUrl refreshCache:YES params:dic success:^(id response) {
        NSString *code = [(NSDictionary*)response objectForKey:@"code"];
        if (code.integerValue == 0) {
            if (callBack) {
                NSArray *arr = [(NSDictionary*)response objectForKey:@"data"];
                callBack(nil,arr);
            }
        }else{
            if (code.integerValue == 401) {
                callBack(nil,[NSArray array]);
            }else{
                callBack(nil,[(NSDictionary*)response objectForKey:@"msg"]);
            }
        }
    } fail:^(NSError *error) {
        [DTNetManger requestFailedCallBack:callBack];
    }];

}
//获取工种列表
+(void)workStypeListWithCallBack:(callBack)callBack{
    [Tools configOrignNetWork];
    [HYBNetworking postWithUrl:kDTGetListUrl refreshCache:YES params:nil success:^(id response) {
        NSString *code = [(NSDictionary*)response objectForKey:@"code"];
        if (code.integerValue == 0) {
            if (callBack) {
                NSArray *arr = [(NSDictionary*)response objectForKey:@"data"];
                callBack(nil,arr);
            }
        }else{
           callBack(nil,[(NSDictionary*)response objectForKey:@"msg"]);
        }
    } fail:^(NSError *error) {
        [DTNetManger requestFailedCallBack:callBack];
    }];

}
//获取工种注册地址
+(void)getUrlOfWorkTypeWith:(NSString *)typeId
                   callBack:(callBack)callBack{
    [Tools configOrignNetWork];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         typeId,@"work_type_id",
                         nil];
    [HYBNetworking postWithUrl:kDTGetUrlUrl refreshCache:YES params:dic success:^(id response) {
        NSString *code = [(NSDictionary*)response objectForKey:@"code"];
        if (code.integerValue == 0) {
            if (callBack) {
                NSDictionary *arr = [(NSDictionary*)response objectForKey:@"data"];
                callBack(nil,arr);
            }
        }else{
            [DTNetManger requestFailedCallBack:callBack];
        }
    } fail:^(NSError *error) {
        [DTNetManger requestFailedCallBack:callBack];
    }];

    
}
//获取工种资料
+(void)getUrlOfWorkInfoWith:(NSString *)typeId
                   callBack:(callBack)callBack{
    [Tools configOrignNetWork];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         typeId,@"work_type_id",
                         nil];
    [HYBNetworking postWithUrl:kDTGetInfoUrl refreshCache:YES params:dic success:^(id response) {
        NSString *code = [(NSDictionary*)response objectForKey:@"code"];
        if (code.integerValue == 0) {
            if (callBack) {
                NSArray *arr = [(NSDictionary*)response objectForKey:@"data"];
                callBack(nil,arr);
            }
        }else{
            [DTNetManger requestFailedCallBack:callBack];
        }
    } fail:^(NSError *error) {
        [DTNetManger requestFailedCallBack:callBack];
    }];

}
//添加/修改工种
+(void)addWorkTypeWith:(NSString *)typeId
                  name:(NSString*)name
              callBack:(callBack)callBack{
    [Tools configOrignNetWork];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         name,@"name",
                         typeId,@"work_type_id",
                         nil];
    [HYBNetworking postWithUrl:kDTsaveUrl refreshCache:YES params:dic success:^(id response) {
        NSString *code = [(NSDictionary*)response objectForKey:@"code"];
        if (code.integerValue == 0) {
            if (callBack) {
//                NSDictionary *arr = [(NSDictionary*)response objectForKey:@"data"];
                callBack(nil,response);
            }
        }else{
            [DTNetManger requestFailedCallBack:callBack];
        }
    } fail:^(NSError *error) {
        [DTNetManger requestFailedCallBack:callBack];
    }];

}
//删除工种
+(void)delWorkTypeWith:(NSString *)typeId
              callBack:(callBack)callBack{
    [Tools configOrignNetWork];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         typeId,@"work_type_id",
                         nil];
    [HYBNetworking postWithUrl:kDTdelUrl refreshCache:YES params:dic success:^(id response) {
        NSString *code = [(NSDictionary*)response objectForKey:@"code"];
        if (code.integerValue == 0) {
            if (callBack) {
                
                callBack(nil,response);
            }
        }else{
            [DTNetManger requestFailedCallBack:callBack];
        }
    } fail:^(NSError *error) {
        [DTNetManger requestFailedCallBack:callBack];
    }];

}
//获取服务分类列表
+(void)seviceListWithCallBack:(callBack)callBack{
    [Tools configOrignNetWork];
    [HYBNetworking postWithUrl:kDTgetCategoryListUrl refreshCache:YES params:nil success:^(id response) {
        NSString *code = [(NSDictionary*)response objectForKey:@"code"];
        if (code.integerValue == 0) {
            if (callBack) {
                NSArray *arr = [(NSDictionary*)response objectForKey:@"data"];
                callBack(nil,arr);
            }
        }else{
            [DTNetManger requestFailedCallBack:callBack];
        }
    } fail:^(NSError *error) {
        [DTNetManger requestFailedCallBack:callBack];
    }];

}
//获取服务项目资料
+(void)getServiceInfoWith:(NSString*)typeId
                 callBack:(callBack)callBack{
    [Tools configOrignNetWork];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         typeId,@"work_type_id",
                         nil];
    [HYBNetworking postWithUrl:kDTGetSInfoUrlUrl refreshCache:YES params:dic success:^(id response) {
        NSString *code = [(NSDictionary*)response objectForKey:@"code"];
        if (code.integerValue == 0) {
            if (callBack) {
                NSDictionary *dict = [(NSDictionary*)response objectForKey:@"data"];
                callBack(nil,dict);
            }
        }else{
             callBack(nil,[(NSDictionary*)response objectForKey:@"msg"]);
        }
    } fail:^(NSError *error) {
        [DTNetManger requestFailedCallBack:callBack];
    }];

}
//添加/修改服务项目
+(void)addServiceWith:(NSString*)service_id
           categoryId:(NSString*)categoryId
                 name:(NSString*)name
                price:(NSString*)price
             callBack:(callBack)callBack{
    [Tools configOrignNetWork];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         name,@"name",
                         price,@"price",
                          categoryId,@"category_id",
                         service_id,@"service_id",
                         nil];
    [HYBNetworking postWithUrl:kDTSsaveUrl refreshCache:YES params:dic success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",[(NSDictionary*)response objectForKey:@"code"]];
        if (callBack) {
            callBack(nil,code);
        }
    } fail:^(NSError *error) {
        [DTNetManger requestFailedCallBack:callBack];
    }];

    
}
//删除服务项目
+(void)delServiceTypeWith:(NSString*)serviceId
                 callBack:(callBack)callBack{
    [Tools configOrignNetWork];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         serviceId,@"service_id",
                         nil];
    [HYBNetworking postWithUrl:kDTSdelUrl refreshCache:YES params:dic success:^(id response) {
        NSString *code = [(NSDictionary*)response objectForKey:@"code"];
        if (code.integerValue == 0) {
            if (callBack) {
                
                callBack(nil,nil);
            }
        }else{
            callBack(nil,[(NSDictionary*)response objectForKey:@"msg"]);
            
        }
    } fail:^(NSError *error) {
        [DTNetManger requestFailedCallBack:callBack];
    }];

}
//获取员工分页
+(void)StaffPageWith:(NSString*)page
                size:(NSString*)size
            callBack:(callBack)callBack{
    [Tools configOrignNetWork];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         page,@"page",
                         size,@"size",
                         nil];
    [HYBNetworking postWithUrl:kDTStaffgetPageUrl refreshCache:YES params:dic success:^(id response) {
        NSString *code = [(NSDictionary*)response objectForKey:@"code"];
        if (code.integerValue == 0) {
            if (callBack) {
                NSArray *arr = [(NSDictionary*)response objectForKey:@"data"];
                callBack(nil,arr);
            }
        }else{
            callBack(nil,[(NSDictionary*)response objectForKey:@"msg"]);
        }
    } fail:^(NSError *error) {
        [DTNetManger requestFailedCallBack:callBack];
    }];

}
//获取员工资料
+(void)getStaffInfoWith:(NSString*)staffId
               callBack:(callBack)callBack{
    [Tools configOrignNetWork];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         staffId,@"staff_id",
                         nil];
    [HYBNetworking postWithUrl:kDTStaffGetInfoUrl refreshCache:YES params:dic success:^(id response) {
        NSString *code = [(NSDictionary*)response objectForKey:@"code"];
        if (code.integerValue == 0) {
            if (callBack) {
                NSArray *arr = [(NSDictionary*)response objectForKey:@"data"];
                callBack(nil,arr);
            }
        }else{
           callBack(nil,[(NSDictionary*)response objectForKey:@"msg"]);
        }
    } fail:^(NSError *error) {
        [DTNetManger requestFailedCallBack:callBack];
    }];

}
//修改员工
+(void)addStaffWith:(NSString*)staff_id
       work_type_id:(NSString*)work_type_id
               name:(NSString*)name
        is_disabled:(NSString*)is_disabled //状态(0->在职，1->离职)
           callBack:(callBack)callBack{
    [Tools configOrignNetWork];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         staff_id,@"staff_id",
                         work_type_id,@"work_type_id",
                         name,@"name",
                         is_disabled,@"is_disabled",
                         nil];
    [HYBNetworking postWithUrl:kDTStaffsaveUrl refreshCache:YES params:dic success:^(id response) {
        NSString *code = [(NSDictionary*)response objectForKey:@"code"];
        if (code.integerValue == 0) {
            if (callBack) {
                callBack(nil,nil);
            }
        }else{
            [DTNetManger requestFailedCallBack:callBack];
        }
    } fail:^(NSError *error) {
        [DTNetManger requestFailedCallBack:callBack];
    }];
}
//删除员工
+(void)delStaffInfoWith:(NSString*)staffId
               callBack:(callBack)callBack{
    [Tools configOrignNetWork];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         staffId,@"staff_id",
                         nil];
    [HYBNetworking postWithUrl:kDTStaffdelUrl refreshCache:YES params:dic success:^(id response) {
        NSString *code = [(NSDictionary*)response objectForKey:@"code"];
        if (code.integerValue == 0) {
            if (callBack) {
               
                callBack(nil,nil);
            }
        }else{
            [DTNetManger requestFailedCallBack:callBack];
        }
    } fail:^(NSError *error) {
        [DTNetManger requestFailedCallBack:callBack];
    }];
}
@end
