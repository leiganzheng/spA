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
           callBack(nil,[(NSDictionary*)response objectForKey:@"msg"]);
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

//获取员工佣金
+(void)staffGetCommission:(callBack)callBack{
    [Tools configOrignNetWork];
    [HYBNetworking postWithUrl:kDTGetCommissionUrl refreshCache:YES params:nil success:^(id response) {
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
//获取员工银行卡
+(void)staffGetCreditCard:(callBack)callBack{
    [Tools configOrignNetWork];
    [HYBNetworking postWithUrl:kDTGetStaffCreditCardUrl refreshCache:YES params:nil success:^(id response) {
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
//设置员工银行卡
+(void)staffSetCreditCardWith:(NSString*)bank
                  credit_card:(NSString*)credit_card
                     callBack:(callBack)callBack{
    [Tools configOrignNetWork];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         bank,@"bank",
                         credit_card,@"credit_card",
                         nil];
    [HYBNetworking postWithUrl:kDTStaffSetCreditCardUrl refreshCache:YES params:dic success:^(id response) {
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
//获取客户数量业绩统计
+(void)orderSumWith:(NSString*)date
           callBack:(callBack)callBack{
    [Tools configOrignNetWork];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         date,@"date",
                         nil];
    [HYBNetworking postWithUrl:kDTOrderSumUrl refreshCache:YES params:dic success:^(id response) {
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
+(void)orderGetStaffPageWith:(NSString *)page
                        size:(NSString *)size
                        date:(NSString*)date
                    callBack:(callBack)callBack{
    [Tools configOrignNetWork];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         page,@"page",
                         size,@"size",
                         date,@"date",
                         nil];
    [HYBNetworking postWithUrl:kDTOrderGetStaffPagUrl refreshCache:YES params:dic success:^(id response) {
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
//获取服务单明细
+(void)orderGetDetail:(callBack)callBack{
    [Tools configOrignNetWork];
    [HYBNetworking postWithUrl:kDTOrderGetDetailUrl refreshCache:YES params:nil success:^(id response) {
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
//获取服务分类列表
+(void)serviceGetCategoryList:(callBack)callBack{
    [Tools configOrignNetWork];
    [HYBNetworking postWithUrl:kDTServiceGetCategoryListUrl refreshCache:YES params:nil success:^(id response) {
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
//车牌识别
+(void)customerOcrWith:(NSString*)plate_license_base64  //车牌照片base64
              callBack:(callBack)callBack{
    [Tools configOrignNetWork];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         plate_license_base64,@"plate_license_base64",
                         nil];
    [HYBNetworking postWithUrl:kDTCustomerOcrUrl refreshCache:YES params:dic success:^(id response) {
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
//获取客户信息
+(void)customerGetWith:(NSString*)plate_license  //车牌号
              callBack:(callBack)callBack{
    [Tools configOrignNetWork];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         plate_license,@"plate_license",
                         nil];
    [HYBNetworking postWithUrl:kDTCustomerGetUrl refreshCache:YES params:dic success:^(id response) {
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

//补录客户资料
+(void)customerAddWith:(NSDictionary*)info
              callBack:(callBack)callBack{
    [Tools configOrignNetWork];

    [HYBNetworking postWithUrl:kDTCustomerAddUrl refreshCache:YES params:info success:^(id response) {
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
//获取佣金记录
+(void)staffMoneyGetPageWith:(NSString *)page
                        size:(NSString *)size
                    callBack:(callBack)callBack{
    [Tools configOrignNetWork];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         page,@"page",
                         size,@"size",
                         nil];
    [HYBNetworking postWithUrl:kDTStaffMoneyGetPageUrl refreshCache:YES params:dic success:^(id response) {
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
//获取提现记录
+(void)staffWithdrawGetPageWith:(NSString *)page
                           size:(NSString *)size
                       callBack:(callBack)callBack{
    [Tools configOrignNetWork];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         page,@"page",
                         size,@"size",
                         nil];
    [HYBNetworking postWithUrl:kDTStaffWithdrawGetPageUrl refreshCache:YES params:dic success:^(id response) {
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
//申请结算
+(void)staffWithdrawApply:(NSString*)money  //float	金额
                 callBack:(callBack)callBack{
    
    [Tools configOrignNetWork];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         money,@"money",
                         nil];
    [HYBNetworking postWithUrl:kDTStaffWithdrawApplyUrl refreshCache:YES params:dic success:^(id response) {
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
//获取商品信息
+(void)goodGetWith:(NSString *)barcode //条码
              type:(NSString *)type //商品类型（1->供应商供货，2->商家自购）
          callBack:(callBack)callBack{
    [Tools configOrignNetWork];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         barcode,@"barcode",
                         type,@"type",
                         nil];
    [HYBNetworking postWithUrl:kDTGoodUrl refreshCache:YES params:dic success:^(id response) {
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
@end
