//
//  EYRequestModel.m
//  eiyt
//
//  Created by Hervé HEURTAULT DE LAMMERVILLE on 22/02/14.
//  Copyright (c) 2014 PLIC. All rights reserved.
//

#import "HLRequest.h"

@interface HLRequest ()
{
    NSMutableData *responseData;
}

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, assign) IBOutlet id<HLRequestDelegate> delegate;
@property (nonatomic, copy) HLRequestCompletionHandler completionHandler;

@end

@implementation HLRequest

@synthesize delegate;

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
    
    //SET OPTIONAL HEADER FIELDS
    //[mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //CHANGE BEHAVIOR ACCORDING TO YOUR WEBSERVICE
    if (self.requestType == HLRequestTypeSample)
    {
        mutableRequest.HTTPMethod = @"GET";
        mutableRequest.URL = [NSURL URLWithString:@"http://getphotowizz.com/beta/misc/sample-json-1.json"];
    }
    
    //YOU MAY CHANGE THE POST DATA FORMATTING ACCORDING TO WHAT THE SERVER EXPECTS
    if ([mutableRequest.HTTPMethod isEqualToString:@"POST"])
    {
        NSError *error;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:_paramsDictionary options:kNilOptions error:&error];
        mutableRequest.HTTPBody = jsonData;
    }
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:mutableRequest delegate:self];
    [connection start];
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
    if (!delegate)
        self.completionHandler(responseData, nil);
    else
        [delegate requestDidReturnData:responseData withInitialRequest:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (!delegate)
        self.completionHandler(nil, error);
    else
        [delegate requestConnectionDidFailWithError:error andInitialRequest:self];
}

@end
