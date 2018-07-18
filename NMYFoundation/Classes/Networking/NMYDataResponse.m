//
//  NMYDataResponse.m
//  NMYFoundation
//
//  Created by mayue on 2018/4/19.
//

#import <YYModel/YYModel.h>
#import "NMYDataResponse.h"

@implementation NMYDataResponse

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    
    return @{
             @"requestId" : @"req_id",
             @"code" : @"ret",
             };
}

@end
