//
//  NMYJsonUtils.m
//  NMYFoundation
//
//  Created by mayue on 2018/4/18.
//

#import <YYModel/YYModel.h>
#import "NMYJsonUtils.h"


@implementation NMYJsonUtils

+ (id)modelWithClass:(Class)clazz fromJsonObject:(id)jsonObject {
    
    if (!clazz || !jsonObject) return nil;
    
    id model = [clazz yy_modelWithJSON:jsonObject];
    
    return model;
}

+ (NSArray *)modelArrayWithClass:(Class)clazz fromJsonObject:(id)json {
    
    return [NSArray yy_modelArrayWithClass:clazz json:json];
}

+ (NSDictionary *)dictionaryFromObject:(id)obj {
    NSDictionary *dict = nil;
    if ([obj isKindOfClass:[NSDictionary class]]) {
        dict = obj;
    }
    else if ([obj isKindOfClass:[NSString class]]) {
        id ret = [self jsonObjectWithString:obj];
        if ([ret isKindOfClass:[NSDictionary class]]) {
            dict = ret;
        }
    }
    return dict;
}

+ (id)jsonObjectWithString:(NSString *)string {
    if (!string || string.length <= 0) return nil;
    NSError *error;
    
    id jsonObject = [self jsonObjectWithString:string error:&error];
    
    if (error) {
        return nil;
    }
    return jsonObject;
}

+ (id)jsonObjectWithString:(NSString *)string error:(NSError **)error {
    if (!string || string.length <= 0) return nil;
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    if (data == nil) {
        return nil;
    }
    
    id responseData = [NSJSONSerialization JSONObjectWithData:data
                                                      options:NSJSONReadingMutableContainers
                                                        error:error];
    return responseData;
}

@end
