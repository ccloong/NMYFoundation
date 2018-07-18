//
//  NMYURLUtils.m
//  NMYFoundation
//
//  Created by mayue on 2018/4/19.
//

#import "NMYURLUtils.h"

@implementation NMYURLUtils

+ (NSDictionary *)dictionaryFromQueryStringInUrl:(NSString *)url {
    
    if (!url.length)
        return nil;
    
    NSURL *urlPath = [NSURL URLWithString:url];
    NSString *query = urlPath.query;
    if (!query.length)
        return nil;
    
    return [self dictionaryFromQueryString:query];
}

+ (NSDictionary *)dictionaryFromQueryString:(NSString *)query {
    
    NSArray *params = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString *each in params) {
        NSArray *kv = [each componentsSeparatedByString:@"="];
        
        if ([kv count] == 2) {
            if (kv[0] && kv[1]) {
                NSString *value = [self urlDecode:kv[1]];
                if (value) {
                    [dict setObject:value forKey:kv[0]];
                }
            }
        } else if ([kv count] == 1) {
            [dict setObject:@"" forKey:kv[0]];
        }
    }
    return dict;
}

+ (NSString *)urlWithBaseUrl:(NSString *) baseUrl
                      params:(NSDictionary<NSString *, NSString *> *)params {
    
    if (!baseUrl.length) {
        return nil;
    }
    
    NSURL *baseNsUrl = [NSURL URLWithString:baseUrl];
    if (!baseNsUrl) {
        NSLog(@"*** ERROR: the baseUrl is not a URL format String or wasn't encoded!!! ***");
        return nil;
    }
    
    NSMutableDictionary *parameters = [params mutableCopy];
    
    if (!parameters) {
        parameters = [NSMutableDictionary dictionary];
    }
    
    NSDictionary *baseQueryDic = [self dictionaryFromQueryString:baseNsUrl.query];
    
    if (baseQueryDic.count) {
        [parameters addEntriesFromDictionary:baseQueryDic];
    }
    
    NSString *path = baseNsUrl.path;
    
    if (![path hasSuffix:@"/"]) {
        
        path = [NSString stringWithFormat:@"%@/", path];
        
    }
    
    NSURL *dstUrl = [self buildURL:baseNsUrl.scheme
                              host:baseNsUrl.host
                              port:baseNsUrl.port
                              path:path
                             query:[self queryStringFromDictionary:parameters]
                          fragment:baseNsUrl.fragment];
    
    return [dstUrl.absoluteString copy];

}

+ (NSString *)urlDecode:(NSString *)string {
    if (!string) {
        return nil;
    }
    return [string stringByRemovingPercentEncoding];
}

+ (NSURL *)buildURL:(NSString *)scheme
               host:(NSString *)host
               port:(NSNumber *)port
               path:(NSString *)path
              query:(NSString *)query
           fragment:(NSString *)fragment {
    
    if (port) {
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@:%ld%@%@%@", scheme.length ? scheme : @"http", host, (long)[port integerValue], path, query.length ? [@"?" stringByAppendingString:query] : @"", fragment.length ? [@"#" stringByAppendingString:fragment] : @"", nil]];
    } else {
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@%@%@%@", scheme.length ? scheme : @"http", host, path, query.length ? [@"?" stringByAppendingString:query] : @"", fragment.length ? [@"#" stringByAppendingString:fragment] : @"", nil]];
    }
}

+ (NSString *)queryStringFromDictionary:(NSDictionary<NSString* ,NSString* > *)dictionary {
    
    if (!dictionary.count) {
        return nil;
    }
    NSArray *query;
    if ([dictionary count] > 0) {
        NSMutableArray *params = [NSMutableArray array];
        for (NSString *key in dictionary.allKeys) {
            NSString *value = dictionary[key];
            
            if (![value isKindOfClass:[NSString class]]) {
                value = [value description];
            }
            
            [params addObject:[NSString stringWithFormat:@"%@=%@", key, [self urlEncode:value]]];
            
        }
        query = [params sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            return [obj1 compare:obj2];
        }];
    }
    return [query componentsJoinedByString:@"&"];
}

+ (NSString* )urlEncode:(NSString *)string {
    if (!string) {
        return nil;
    }
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\|\n\t\r ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *result = [string stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return result;
}

@end
