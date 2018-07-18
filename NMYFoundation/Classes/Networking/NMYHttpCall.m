//
//  NMYHttpCall.m
//  NMYFoundation
//
//  Created by mayue on 2018/4/18.
//

#import "NMYHttpCall.h"
#import "NMYNetworkingDefines.h"
#import "NMYHttpManager.h"
#import "NMYHttpRequest.h"
#import "NMYHttpResponse.h"

@interface NMYHttpCall ()

@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, assign) NMYHttpMethod method;
@property (nonatomic, copy) NSData *data;
@property (nonatomic, strong) NSString *dataKey;
@property (nonatomic, assign) BOOL isHasMoreModel;
@property (nonatomic, strong) NMYHttpManager *httpManager;

@end

@implementation NMYHttpCall

- (instancetype)init {
    
    if (self = [super init]) {
        
    }
    
    return self;
}


-(instancetype)initWithFullUrl:(NSString *)urlString
                        method:(NMYHttpMethod)method
                          data:(NSData *)data
                       dataKey:(NSString *)dataKey
                         clazz:(Class)dataModelClass
                isHasMoreModel:(BOOL)isHasMoreModel {
    
    if (self = [self init]) {
        self.isHasMoreModel = isHasMoreModel;
        self.httpManager = [[NMYHttpManager alloc] initWithDataModelClass:dataModelClass
                                                           isHasMoreModel:isHasMoreModel];
        self.urlString = urlString;
        self.method = method;
        self.data = data;
        self.dataKey = dataKey;
    }
    return self;
}

+ (instancetype)createHttpCallWith:(NMYHttpRequest *)request
                    dataModelClass:(Class)dataModelClass
                    isHasMoreModel:(BOOL)isHasMoreModel {
    
    NSData *data = nil;
    
    if (request.bodyParam) {
        data = [NSJSONSerialization dataWithJSONObject:request.bodyParam
                                               options:NSJSONWritingPrettyPrinted
                                                 error:nil];
    }
    
    return [[self alloc] initWithFullUrl:request.urlString
                                  method:request.httpMethod
                                    data:data
                                 dataKey:nil
                                   clazz:dataModelClass
                          isHasMoreModel:isHasMoreModel];
    
}

- (void)requestWithCallback:(void (^)(NMYHttpCall *, NMYHttpResponse *))callback {
    
    [self.httpManager requestWithUrl:self.urlString
                         httpHeaders:nil
                              method:self.method
                            bodyData:self.data
                    multipartDataKey:self.dataKey
                            callback:^(NMYHttpResponse *response) {
                                
                        if (callback) {
                            callback(self, response);
                        }
                            }];
}

@end
