//
//  NMYHTTPResponseSerializer.m
//  NMYFoundation
//
//  Created by mayue on 2018/4/19.
//

#import "NMYHTTPResponseSerializer.h"
#import "NMYHttpResponse.h"

@implementation NMYHTTPResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error {
    
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        
        if (httpResponse.statusCode >= 400 && httpResponse.statusCode < 500) {
            if (error) {
                *error = [NSError errorWithDomain:@"" code:httpResponse.statusCode userInfo:@{@"message" : [NSString stringWithFormat:@"response statusCode %d", (int) httpResponse.statusCode, nil]}];
            }
            return [[NMYHttpResponse alloc] initWithURLResponse:response error:(error ? *error : nil)];
        }
    }
    
    NMYHttpResponse *smfHttpResponse = [[NMYHttpResponse alloc] initWithURLResponse:response receivedData:data];
    return smfHttpResponse;
}

@end
