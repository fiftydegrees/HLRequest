//
//  HLRequest.m
//
//  Created by Hervé HEURTAULT DE LAMMERVILLE on 22/02/14.
//

#import "HLRequest.h"

@interface HLRequest ()
{
    NSMutableData *responseData;
}

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *method;
@property (nonatomic, assign) IBOutlet id<HLRequestDelegate> delegate;
@property (nonatomic, copy) HLRequestCompletionHandler completionHandler;

@property (nonatomic, strong) NSURL *kBaseURL;

@property (nonatomic, strong) NSURLConnection *connection;

@end

@implementation HLRequest

@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self)
    {
        /**
         *  Add your own base URL (you can switch between targets, from development to production environment)
         */
        self.kBaseURL = [NSURL URLWithString:@"http://getphotowizz.com/"];
    }
    return self;
}

- (void)executeRequestWithDelegate :(id<HLRequestDelegate>)requestDelegate
{
    delegate = requestDelegate;
    [self executeRequest];
}

- (void)executeRequestWithCompletion :(HLRequestCompletionHandler)completionHandler
{
    self.completionHandler = completionHandler;
    [self executeRequest];
}

- (void)executeRequest
{
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] init];
    
    /**
     *  Optionally set header fields
     *  [mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
     */
    
    /**
     *  Change this condition according to your own implementation
     */
    if (self.requestType == HLRequestTypeSample)
    {
        mutableRequest.HTTPMethod = @"GET";
        mutableRequest.URL = [NSURL URLWithString:@"beta/misc/sample-json-1.json" relativeToURL:self.kBaseURL];
    }
    
    /**
     *  Change the way your parameters are embedded into the request
     */
    if (self.paramsDictionary &&
        self.paramsDictionary.allKeys.count  > 0)
    {
        if ([mutableRequest.HTTPMethod isEqualToString:@"GET"])
        {
            mutableRequest.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", mutableRequest.URL.absoluteString, [self getFormattedParamsFromDictionary:self.paramsDictionary]]];
        }
        if ([mutableRequest.HTTPMethod isEqualToString:@"POST"])
        {
            NSError *error;
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:_paramsDictionary options:kNilOptions error:&error];
            mutableRequest.HTTPBody = jsonData;
        }
    }
    
    self.connection = [[NSURLConnection alloc] initWithRequest:mutableRequest delegate:self];
    [self.connection start];
}

- (void)cancel
{
    [self.connection cancel];
    self.connection = nil;
}

#pragma mark - Helper

- (NSString *)getFormattedParamsFromDictionary :(NSDictionary *)dictionary
{
    NSMutableString *parameterString = [NSMutableString new];
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [parameterString appendFormat:@"%@=%@&", key, obj];
    }];
    
    return [parameterString substringToIndex:[parameterString length] - 1];
}

#pragma mark -
#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (!self.connection)
        return;
    
    if (!delegate)
        self.completionHandler(responseData, nil);
    else if ([delegate respondsToSelector:@selector(requestDidReturnData:withInitialRequest:)])
        [delegate requestDidReturnData:responseData withInitialRequest:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (!self.connection)
        return;
    
    if (!delegate)
        self.completionHandler(nil, error);
    else if ([delegate respondsToSelector:@selector(requestConnectionDidFailWithError:andInitialRequest:)])
        [delegate requestConnectionDidFailWithError:error andInitialRequest:self];
}

@end
