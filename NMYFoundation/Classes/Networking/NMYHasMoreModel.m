//
//  NMYHasMoreModel.m
//  NMYFoundation
//
//  Created by mayue on 2018/4/19.
//

#import <YYModel/YYModel.h>
#import "NMYHasMoreModel.h"

@implementation NMYHasMoreModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    
    return @{
             @"hasMore" : @"has_more",
             @"lastRequestId" : @"req_id",
             };
}

@end
