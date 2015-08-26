//
//  RowItem.m
//  QL_Demo
//
//  Created by Xu Lian on 2015-08-25.
//  Copyright (c) 2015 QLD_Laoyue. All rights reserved.
//

#import "RowItem.h"

@interface RowItem()
{
    NSURLConnection *conn;
    NSMutableData *imagedata;
}
@end

@implementation RowItem

- (void)cancelDownload;
{
    NSLog(@"cancelDownload");
    [conn cancel];
    conn = nil;
    imagedata = nil;
    self.gotImage = NO;
    self.downloading = NO;
}

- (void)startDownload;
{
    if (conn != nil) {
        NSLog(@"conn is not nil");
        return;
    }

    self.downloading = YES;
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:self.remoteURL cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:15.0];
    [request setTimeoutInterval:30];

    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    //NSLog(@"ido_connection=%@", ido_connection);
    NSAssert(conn != nil, @"NSURLConnection alloc failed");
    [conn start];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    ///NSLog(@"didReceiveResponse=%@", response);
    imagedata = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [imagedata appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:_remoteURL.lastPathComponent];
    BOOL saveOK = [imagedata writeToFile:path atomically:YES];
    if (saveOK) {
        self.localURL = [NSURL fileURLWithPath:path];
        self.gotImage = YES;
        NSLog(@"localURL=%@", self.localURL);
    }
    else{
        self.gotImage = NO;
    }
    conn = nil;
    imagedata = nil;
    self.downloading = NO;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _error = [error copy];
    self.gotImage = NO;
    conn = nil;
    imagedata = nil;
    self.downloading = NO;
    NSLog(@"didFailWithError %@", _error);
}

- (NSString *)previewItemTitle
{
    return _remoteURL.lastPathComponent;
}

- (NSURL *)previewItemURL;
{
    NSLog(@"return previewItemURL %@", self.localURL);
    return self.localURL;
}

@end
