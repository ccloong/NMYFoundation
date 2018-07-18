//
//  NMYDataResponse.h
//  NMYFoundation
//
//  Created by mayue on 2018/4/19.
//

#import <Foundation/Foundation.h>

@protocol YYModel;

@interface NMYDataResponse<ObjectType> : NSObject <YYModel>

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *requestId;
@property (nonatomic, strong) ObjectType data;

@end
