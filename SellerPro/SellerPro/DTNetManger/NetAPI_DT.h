//
//  NetAPI_DT.h
//  DouTu
//
//  Created by yuepengfei on 17/3/14.
//  Copyright © 2017年 fly. All rights reserved.
//

#ifndef NetAPI_DT_h
#define NetAPI_DT_h

#define kDTBaseHostUrl               @"http://120.77.149.156:92"
//login
#define kDTLoginUrl                  @"Merchant/login"
#define kDVerifyCodeUrl              @"Merchant/verifyCode"
#define kDTCheckVerifyCodeUrl        @"Merchant/checkVerifyCode"
#define kDTMpasswordUrl              @"Merchant/password"
//order
#define kDTGetPageUrl                @"Order/getPage"
#define kDTGetStaffPageUrl           @"Order/getStaffPage"
#define kDTGetServicePageUrl         @"Order/getServicePage"
//WorkType
#define kDTGetListUrl                @"WorkType/getList"
#define kDTGetUrlUrl                 @"WorkType/getUrl"
#define kDTGetInfoUrl                @"WorkType/get"
#define kDTsaveUrl                   @"WorkType/save"
#define kDTdelUrl                    @"WorkType/del"
//Service
#define kDTgetCategoryListUrl        @"Service/getCategoryList"
#define kDTGetSInfoUrlUrl            @"Service/get"
#define kDTSsaveUrl                  @"Service/save"
#define kDTSdelUrl                   @"Service/del"
//Staff
#define kDTStaffgetPageUrl           @"Staff/getPage"
#define kDTStaffGetInfoUrl           @"Staff/get"
#define kDTStaffsaveUrl              @"Staff/save"
#define kDTStaffdelUrl               @"Staff/del"

#endif /* NetAPI_DT_h */
