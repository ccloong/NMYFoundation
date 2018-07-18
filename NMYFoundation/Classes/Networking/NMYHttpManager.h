//
//  NMYHttpManager.h
//  NMYFoundation
//
//  Created by mayue on 2018/4/18.
//

#import <Foundation/Foundation.h>
#import "NMYNetworkingDefines.h"

@class NMYHttpResponse;
@interface NMYHttpManager : NSObject

- (instancetype)initWithDataModelClass:(Class)dataModelClass
                        isHasMoreModel:(BOOL)isHasMoreModel NS_DESIGNATED_INITIALIZER;

- (void)requestWithUrl:(NSString *)urlString
           httpHeaders:(NSDictionary<NSString *, NSString *> *)headerParams
                method:(NMYHttpMethod)method
              bodyData:(NSData *)bodyData
      multipartDataKey:(NSString *)dataKey
              callback:(void(^)(NMYHttpResponse *response))callback;


@end
