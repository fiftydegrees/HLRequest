# HLRequest

HLRequest provides an easy-to-use way of sending requests and handling returned data, with either delegate or completion handler.

## Installation

_**If your project doesn't use ARC**: you must add the `-fobjc-arc` compiler flag to `HLRequest.m` in Target Settings > Build Phases > Compile Sources._

* Drag the `./HLRequest` folder into your project.
* Import `HLRequest.h` in your view controller.

If you feel easy with Git, create a submodule into own project.

## Usage

### Configuration

In `HLRequest.h`, add your own request types to `HLRequestType` enum and handle these cases in `executeRequest()`.

### Usage

Create a new instance of HLRequest and set `requestType` and `method` (GET, POST, etc.) properties. You can then choose to use delegate or completion handler with these methods.

#### Delegate

```
- (void)executeRequestWithDelegate:(id<HLRequestDelegate>)requestDelegate;

//HLRequestDelegate
- (void)requestDidReturnData :(id)data withInitialRequest :(HLRequest *)request;
- (void)requestConnectionDidFailWithError :(NSError *)error andInitialRequest :(HLRequest *)request;
```

#### Completion Handler

```
- (void)executeRequestWithCompletion :(HLRequestCompletionHandler)completionHandler;

//With completionHandler type
typedef void (^HLRequestCompletionHandler)(NSData *data, NSError *error);
```

#### Cancel a request

Simply use `cancel()` method on your HLRequest instance.

```
[myRequest cancel];
```

#### Parameters formatting

Default is, GET parameters are appended to the request URL, and POST parameters are Json-encoded and enclosed in the request body.

### Configuration

You can add HTTP header fields or change POST parameters formatting directly into `executeRequest()` method, in `HLRequest.m`.

You may also change `kBaseURL` value in the `init()` method according to your own server.

## Credits

HLRequest was developed by [Hervé Heurtault de Lammerville](http://www.hervedroit.com). If you have any feature suggestion or bug report, please help out by creating [an issue](https://github.com/fiftydegrees/HLRequest/issues/new) on GitHub. If you're using HLRequest in your project, please let me know.