//
//  NMYHttpManager.m
//  NMYFoundation
//
//  Created by mayue on 2018/4/18.
//

#import <AFNetworking/AFNetworking.h>
#import "NMYHttpManager.h"
#import "NMYHttpResponse.h"
#import "NMYDataResponse.h"
#import "NMYURLUtils.h"
#import "NMYJsonUtils.h"
#import "NMYNetworkingDefines.h"
#import "NMYHasMoreModel.h"
#import "NMYHTTPResponseSerializer.h"

@interface NMYHttpManager ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) Class dataModelClass;
@property (nonatomic, assign) BOOL isHasMoreModel;

@end

@implementation NMYHttpManager

- (instancetype)init {
    
    if (self = [self initWithDataModelClass:nil isHasMoreModel:NO]) {
        
    }
    
    return self;
}


- (instancetype)initWithDataModelClass:(Class)dataModelClass
                        isHasMoreModel:(BOOL)isHasMoreModel {
    
    if (self = [super init]) {
        
        self.manager = [AFHTTPSessionManager manager];
        self.manager.responseSerializer = [NMYHTTPResponseSerializer serializer];
        self.manager.requestSerializer.timeoutInterval = 10;
        self.manager.completionQueue = dispatch_queue_create("com.NMYFoundation.networking.httpManagerCompletionQueue", DISPATCH_QUEUE_CONCURRENT);
        self.manager.operationQueue.maxConcurrentOperationCount = 1; // AFNetworking默认为1
        self.dataModelClass = dataModelClass;
        self.isHasMoreModel = isHasMoreModel;
        
    }
    
    return self;
}

- (void)requestWithUrl:(NSString *)urlString
           httpHeaders:(NSDictionary<NSString *, NSString *> *)headerParams
                method:(NMYHttpMethod)method
              bodyData:(NSData *)bodyData
      multipartDataKey:(NSString *)dataKey
              callback:(void(^)(NMYHttpResponse* response))callback {
    
    if (!urlString.length) {
        NSError *error = [NSError errorWithDomain:@"url nil error" code:0 userInfo:nil];
        callback([[NMYHttpResponse alloc] initWithURLResponse:nil error:error]);
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[NMYURLUtils dictionaryFromQueryStringInUrl:urlString]];
    
    NSMutableURLRequest *request = nil;
    NSURLSessionDataTask *task = nil;
    
    if (method == NMYHttpGET) {
        
        request = [self.manager.requestSerializer requestWithMethod:@"GET"
                                                          URLString:urlString
                                                         parameters:nil
                                                              error:nil];
        
    } else if (method == NMYHttpPOST){
        
        if (bodyData && !dataKey) {
            
            if (![self.manager.requestSerializer.HTTPRequestHeaders valueForKey:@"Content-Type"]) {
                
                [self.manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            }
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:bodyData options:NSJSONReadingMutableLeaves error:nil];
            
            request = [self.manager.requestSerializer requestWithMethod:@"POST" URLString:urlString parameters:dic error:nil];
            
        } else {
            
            request = [self.manager.requestSerializer multipartFormRequestWithMethod:@"POST"
                                                                           URLString:urlString
                                                                          parameters:params
                                                           constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                                                               
                                                               if (dataKey && bodyData) {
                                                                   
                                                                   [formData appendPartWithFormData:bodyData name:dataKey];
                                                                   
                                                               }
                                                               
                                                           }
                                                                               error:nil];
        }
        
    } else {
        
#ifdef DEBUG
        [NSException raise:@"The Http method neithor POST nor GET" format:@"You should make the method GET or POST"];
#endif
        if (callback) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = [NSError errorWithDomain:@"The Http method neithor POST nor GET" code:-1 userInfo:nil];
                
                callback([[NMYHttpResponse alloc]initWithURLResponse:nil error:error]);
            });
        }
    }
    
    void(^completionBlock)(NSURLResponse * _Nonnull , id  _Nullable , NSError * _Nullable ) =^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (responseObject) {
            
            [self setModelValueToResponse:&responseObject];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (callback) {
                
                if (responseObject) {
                    
                    callback(responseObject);
                    
                } else {
                    
                    callback([[NMYHttpResponse alloc] initWithURLResponse:response error:error]);
                    
                }
            }
        });
        
    };
    
    if (method == NMYHttpGET) {
        
        task = [self.manager dataTaskWithRequest:request
                                  uploadProgress:^(NSProgress * _Nonnull uploadProgress) {}
                                downloadProgress:^(NSProgress * _Nonnull downloadProgress) {}
                               completionHandler:completionBlock];
        
    } else {
        
        if (dataKey) {
            
            task = [self.manager uploadTaskWithStreamedRequest:request
                                                      progress:^(NSProgress * _Nonnull uploadProgress) {}
                                             completionHandler:completionBlock];
            
        } else {
            
            task = [self.manager uploadTaskWithRequest:request
                                              fromData:bodyData
                                              progress:^(NSProgress * _Nonnull uploadProgress) {}
                                     completionHandler:completionBlock];
        }
        
    }
    
    [task resume];
    
}

- (void)setModelValueToResponse:(NMYHttpResponse * __autoreleasing*)tmpResponse {
    
    id data = (*tmpResponse).dataResponse.data;
    
    if (self.dataModelClass) {
        
        if ([data isKindOfClass:[NSArray class]] || [data isKindOfClass:[NSDictionary class]]) {
            
            if (self.isHasMoreModel) {
                
                NMYHasMoreModel *tmpData = [NMYJsonUtils modelWithClass:[NMYHasMoreModel class] fromJsonObject:(*tmpResponse).jsonObject];
                tmpData.jsonObject = data;
                
                NSMutableArray *array = [NSMutableArray array];
                
                for (id obj in tmpData.data) {
                    
                    id tmpObj = [NMYJsonUtils modelWithClass:self.dataModelClass fromJsonObject:obj];
                    
                    if (tmpObj) {
                        
                        [array addObject:tmpObj];
                    }
                }
                
                tmpData.data = array;
                
                (*tmpResponse).dataResponse.data = tmpData;
                
            } else {
                
                (*tmpResponse).dataResponse.data = [NMYJsonUtils modelWithClass:self.dataModelClass
                                                                  fromJsonObject:data];
            }
            
        } else {
            
            if (!data || [data isKindOfClass:[NSNull class]]) {
                
                (*tmpResponse).dataResponse.data = nil;
                
                NSLog(@"the data value is nil！！！！");
                
            } else {
                
                NSLog(@"error!!!: the response data is not available format!!! \n %@", [data description]);
                
            }
        }
        
    } else {
        
        if ([data isKindOfClass:[NSDictionary class]]){
            
            if (self.isHasMoreModel) {
                
                NMYHasMoreModel *tmpData = [NMYJsonUtils modelWithClass:[NMYHasMoreModel class] fromJsonObject:data];
                tmpData.jsonObject = data;
                (*tmpResponse).dataResponse.data = tmpData;
            }
        }
    }
}

@end
