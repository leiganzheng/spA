//
//  NetAPI_DT.h
//  DouTu
//
//  Created by yuepengfei on 17/3/14.
//  Copyright © 2017年 fly. All rights reserved.
//

#ifndef NetAPI_DT_h
#define NetAPI_DT_h

#define kDTBaseHostUrl               @"http://120.77.149.156:91"
//login
#define kDTLoginUrl                  @"Staff/login"
#define kDVerifyCodeUrl              @"Staff/verifyCode"
#define kDTCheckVerifyCodeUrl        @"Staff/checkVerifyCode"
#define kDTMpasswordUrl              @"Staff/password"
//
#define kDTGetCommissionUrl                @"Staff/getCommission"
#define kDTGetStaffCreditCardUrl           @"Staff/getCreditCard"
#define kDTStaffSetCreditCardUrl         @"Staff/setCreditCard"
//order
#define kDTOrderSumUrl                @"Order/sum"
#define kDTOrderGetStaffPagUrl                 @"Order/getStaffPage"
#define kDTOrderGetDetailUrl                @"Order/getDetail"
#define kDTServiceGetCategoryListUrl                   @"Service/getCategoryList"
//Customer
#define kDTCustomerOcrUrl        @"Customer/ocr"
#define kDTCustomerGetUrl            @"Customer/get"
#define kDTCustomerAddUrl                  @"Customer/add"

//StaffMoney/StaffWithdraw
#define kDTStaffMoneyGetPageUrl           @"StaffMoney/getPage"
#define kDTStaffWithdrawGetPageUrl           @"StaffWithdraw/getPage"
#define kDTStaffWithdrawApplyUrl              @"StaffWithdraw/apply"
#define kDTGoodUrl               @"Good/get"

#endif /* NetAPI_DT_h */
