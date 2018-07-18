//
//  NMYHttpResponse.h
//  NMYFoundation
//
//  Created by mayue on 2018/4/19.
//

#import <Foundation/Foundation.h>

@class NMYDataResponse<ObjectType>;
@interface NMYHttpResponse<ObjectType> : NSObject

/**
 *  此属性为响应的success部分,此属性最关键,因为它指示了此次请求是成功还是失败
 */
@property (nonatomic, readonly, getter=isSuccess) BOOL success;

@property (nonatomic, readonly, getter=isHttpSuccess) BOOL httpSuccess;

@property (nonatomic, readonly) NSHTTPURLResponse *urlResponse;

@property (nonatomic, readonly) NSDictionary *allHeaderFeilds;

/**
 *  httpcode 大部分情况应该是200
 */
@property (nonatomic, readonly) NSInteger httpCode;

/**
 *  如果失败，这个属性指出具体错误, 可能为nil
 */
@property (nonatomic, readonly) NSError *error;

@property (nonatomic, readonly) NSInteger code;

@property (nonatomic, readonly) NSString *msg;

/**
 *
 *  返回的 json 转换的数据对象
 */
@property (nonatomic, readonly) NMYDataResponse<ObjectType> *dataResponse;

/*
 *
 *  dataResponse.data   便利函数
 */
@property (nonatomic, readonly) ObjectType data;

/**
 *  此属性为响应的原始json内容,此内容也可能为nil,因为服务器可能是502错误,或者返回了非json的内容
 */
@property (nonatomic, readonly) NSDictionary *jsonObject;

/**
 *  此属性指明获取这个response对应的网络请求的url，用于有些情况下需要根据response对象判断请求源是什么
 */
@property (nonatomic, readonly) NSString *url;


- (instancetype)initWithURLResponse:(NSURLResponse *)response error:(NSError *)error;
- (instancetype)initWithURLResponse:(NSURLResponse *)urlResponse receivedData:(NSData *)receivedData;

@end
