//
//  HLRequest.h
//
//  Created by Hervé HEURTAULT DE LAMMERVILLE on 22/02/14.
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
/**
 *  Trigerred when the request responded
 *
 *  @param data    Data returned by the remote server
 *  @param request Original request
 */
- (void)requestDidReturnData :(id)data withInitialRequest :(HLRequest *)request;

/**
 *  Trigerred when the request connection failed
 *
 *  @param error   Error raised by the connection attempt
 *  @param request Original request
 */
- (void)requestConnectionDidFailWithError :(NSError *)error andInitialRequest :(HLRequest *)request;
@end

@interface HLRequest : NSObject <NSURLConnectionDelegate>
{
    id <HLRequestDelegate> _delegate;
}

/**
 *  Parameters associated with the current request instance
 */
@property (nonatomic, strong) NSDictionary *paramsDictionary;

/**
 *  Request type according to the enum provided above
 */
@property (nonatomic, assign) HLRequestType requestType;

/**
 *  Execute request and handle result with the delegate
 *
 *  @param requestDelegate Delegate called to handle request result
 */
- (void)executeRequestWithDelegate :(id<HLRequestDelegate>)requestDelegate;

/**
 *  Execute request and handle result with a completion handler
 *
 *  @param completionHandler Completion handler called to handle request result
 */
- (void)executeRequestWithCompletion :(HLRequestCompletionHandler)completionHandler;

/**
 *  Cancel request. Good practice is to call it before deallocated a controller.
 */
- (void)cancel;

@end
