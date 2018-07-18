//
//  NMYJsonUtils.h
//  NMYFoundation
//
//  Created by mayue on 2018/4/18.
//

#import <Foundation/Foundation.h>

@interface NMYJsonUtils : NSObject

/*!  * @brief 将Json对象(NSDictionary, NSString, NSData)安全转换为class指定对象，如果不可转或class为空，返回nil */
+ (id)modelWithClass:(Class)clazz fromJsonObject:(id)jsonObject;

/*!  * @brief 将Json对象(NSArray, NSData, NSString)安全转换为class指定对象数组，如果不可转或class为空，返回nil */
+ (NSArray *)modelArrayWithClass:(Class)clazz fromJsonObject:(id)json;

+ (NSDictionary *)dictionaryFromObject:(id)obj;

@end
