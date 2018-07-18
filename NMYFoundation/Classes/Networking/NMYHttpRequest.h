//
//  NMYHttpRequest.h
//  AFNetworking
//
//  Created by mayue on 2018/7/18.
//

#import <Foundation/Foundation.h>
#import "NMYNetworkingDefines.h"

@interface NMYHttpRequest : NSObject

@property (nonatomic, readonly) NSString *urlString;
@property (nonatomic, readonly) NMYHttpMethod httpMethod;
@property (nonatomic, readonly) NSDictionary<NSString *, NSString *> *bodyParam;

- (instancetype)initWithUrl:(NSString *)urlString
                 httpMethod:(NMYHttpMethod)httpMethod
                  bodyParam:(NSDictionary<NSString *, NSString *> *)bodyParam;


@end
