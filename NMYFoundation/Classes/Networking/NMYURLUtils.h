//
//  NMYURLUtils.h
//  NMYFoundation
//
//  Created by mayue on 2018/4/19.
//

#import <Foundation/Foundation.h>

@interface NMYURLUtils : NSObject

/**
 *  @brief 便利函数，用于将URL字符串的参数进行urldecode解码并转成字典
 *  @param url url string
 *  @return 转换完成的参数的字典
 */
+ (NSDictionary *)dictionaryFromQueryStringInUrl:(NSString *)url;

+ (NSString *)urlWithBaseUrl:(NSString *) baseUrl
                      params:(NSDictionary<NSString *, NSString *> *)params;

@end
