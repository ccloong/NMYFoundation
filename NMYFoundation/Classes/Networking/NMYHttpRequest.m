//
//  NMYHttpRequest.m
//  AFNetworking
//
//  Created by mayue on 2018/7/18.
//

#import "NMYHttpRequest.h"

@implementation NMYHttpRequest

- (instancetype)init {
    
    if (self = [self initWithUrl:nil httpMethod:NMYHttpMethodUndefined bodyParam:nil]) {
        
    }
    return self;
}

- (instancetype)initWithUrl:(NSString *)urlString
                 httpMethod:(NMYHttpMethod)httpMethod
                  bodyParam:(NSDictionary *)bodyParam {
    
    if (self = [super init]) {
        
        _urlString = [urlString copy];
        _httpMethod = httpMethod;
        _bodyParam = [bodyParam copy];
        
    }
    
    return self;
}

@end
