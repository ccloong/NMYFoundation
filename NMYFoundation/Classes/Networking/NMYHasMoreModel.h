//
//  NMYHasMoreModel.h
//  NMYFoundation
//
//  Created by mayue on 2018/4/19.
//

#import <Foundation/Foundation.h>

@protocol YYModel;

@interface NMYHasMoreModel<ObjectType> : NSObject <YYModel>

@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, strong) NSArray<ObjectType> *data;
@property (nonatomic, copy) NSString *lastRequestId;
@property (nonatomic, copy) NSArray *jsonObject;


@end
