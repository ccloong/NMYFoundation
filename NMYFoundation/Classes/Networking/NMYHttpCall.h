//
//  NMYHttpCall.h
//  NMYFoundation
//
//  Created by mayue on 2018/4/18.
//

#import <Foundation/Foundation.h>
#import "NMYNetworkingDefines.h"

@class NMYHttpResponse<ObjectType>;
@interface NMYHttpCall<ObjectType> : NSObject

+ (instancetype)createHttpCallWithUrl:(NSString *)urlString
                               method:(NMYHttpMethod)httpMethod
                           bodyParams:(NSDictionary *)bodyParams
                    dataModelClass:(Class)dataModelClass
                    isHasMoreModel:(BOOL)isHasMoreModel;

- (void)requestWithCallback:(void (^)(NMYHttpCall<ObjectType> *httpCall, NMYHttpResponse<ObjectType> *response))callback;

@end
