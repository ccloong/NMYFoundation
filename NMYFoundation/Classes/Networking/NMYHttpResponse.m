//
//  NMYHttpResponse.m
//  NMYFoundation
//
//  Created by mayue on 2018/4/19.
//

#import "NMYHttpResponse.h"
#import "NMYDataResponse.h"
#import "NMYJsonUtils.h"

@interface NMYHttpResponse ()

@property (nonatomic, copy) NSData *receivedData;

@end

@implementation NMYHttpResponse

- (instancetype)initWithURLResponse:(NSHTTPURLResponse *)response error:(NSError *)error {
    
    if (self = [super init]) {
        
        _urlResponse = response;
        _error = error;
        [self initProperties];
    }
    return self;
}

- (instancetype)initWithURLResponse:(NSHTTPURLResponse *)urlResponse receivedData:(NSData *)receivedData {
    if (self = [super init]) {
        _urlResponse = urlResponse;
        self.receivedData = receivedData;
        [self decodeData];
        [self initProperties];
    }
    return self;
}

-(void)initProperties{
    
    _httpCode = self.urlResponse ? self.urlResponse.statusCode : NSIntegerMin;
    _httpSuccess = (_httpCode == 200);
    _code = self.dataResponse ? self.dataResponse.code : NSIntegerMin;
    _success = (self.dataResponse && !self.dataResponse.code && _httpSuccess);
    _url = [[self.urlResponse.URL absoluteString] copy];
    _msg = [self.dataResponse.msg copy];
    
}

- (void)decodeData {
    if (_receivedData.length) {
        id jsonObj = [NSJSONSerialization JSONObjectWithData:_receivedData options:NSJSONReadingMutableContainers error:nil];
        _jsonObject = [NMYJsonUtils dictionaryFromObject:jsonObj];
        _dataResponse = [NMYJsonUtils modelWithClass:[NMYDataResponse class] fromJsonObject:self.jsonObject];
        _allHeaderFeilds = [_urlResponse.allHeaderFields copy];
    }
}

- (id)data {
    return self.dataResponse.data;
}


@end
