//
//  NHCUserHeathApi.m
//  Project
//
//  Created by 朱宗汉 on 16/4/6.
//  Copyright © 2016年 com.xxx. All rights reserved.
//

#import "NHCUserHeathApi.h"

@implementation NHCUserHeathApi

- (NSString *)requestUrl
{
    return @"User/addHealthCard.do";
}
- (id)requestArgument
{
    NSDictionary *dict = [readUserInfo getReadDic];
    NSDictionary *head = @{@"UUID":dict[@"UserInf"][@"uuid"],
                           @"platForm":[readUserInfo GetPlatForm],
                           @"token":[HCAccountMgr manager].loginInfo.Token};
    NSDictionary *para = @{@"height":_height,
                           @"weight":_weight,
                           @"bloodType":_bloodType,
                           @"allergic":_allergic,
                           @"cureCondition":_cureCondition,
                           @"cureNote":_cureNote
                           };
    NSDictionary *body = @{@"Para":para,
                           @"Head":head};
    return body;
}
- (id)formatResponseObject:(id)responseObject
{
    return responseObject;
}
@end


