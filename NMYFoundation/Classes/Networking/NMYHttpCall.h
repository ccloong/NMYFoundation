//
//  NMYHttpCall.h
//  NMYFoundation
//
//  Created by mayue on 2018/4/18.
//

#import <Foundation/Foundation.h>

@class NMYHttpResponse<ObjectType>;
@class NMYHttpRequest;
@interface NMYHttpCall<ObjectType> : NSObject

+ (instancetype)createHttpCallWith:(NMYHttpRequest *)request
                    dataModelClass:(Class)dataModelClass
                    isHasMoreModel:(BOOL)isHasMoreModel;

- (void)requestWithCallback:(void (^)(NMYHttpCall<ObjectType> *httpCall, NMYHttpResponse<ObjectType> *response))callback;

@end
