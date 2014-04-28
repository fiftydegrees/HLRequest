//
//  EYRequestModel.h
//  eiyt
//
//  Created by Hervé HEURTAULT DE LAMMERVILLE on 22/02/14.
//  Copyright (c) 2014 PLIC. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    HLRequestTypeSample = 1
};
typedef NSUInteger HLRequestType;

@class HLRequest;

typedef void (^HLRequestCompletionHandler)(NSData *data, NSError *error);

@protocol HLRequestDelegate <NSObject>
@optional
- (void)requestDidReturnData :(id)data withInitialRequest :(HLRequest *)request;
- (void)requestConnectionDidFailWithError :(NSError *)error andInitialRequest :(HLRequest *)request;
@end

@interface HLRequest : NSObject <NSURLConnectionDelegate>
{
    id <HLRequestDelegate> _delegate;
}

@property (nonatomic, strong) NSDictionary *paramsDictionary;
@property (nonatomic, assign) HLRequestType requestType;

- (void)executeRequestWithDelegate :(id<HLRequestDelegate>)requestDelegate;
- (void)executeRequestWithCompletion :(HLRequestCompletionHandler)completionHandler;
- (void)cancel;

@end
