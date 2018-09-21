//
//  LocalURLCache.m
//  WebViewEventIntercept
//
//  Created by siasun on 2018/9/21.
//  Copyright © 2018年 siasun. All rights reserved.
//

#import "LocalURLCache.h"
#import "NSString+Addition.h"
@implementation LocalURLCache

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request{
    NSString *urlStringMD5 = [request.URL.absoluteString md5];
    NSString *filePath = [[self getDocumentPath] stringByAppendingPathComponent:urlStringMD5];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData *fileData = [[NSData alloc] initWithContentsOfFile:filePath];
        NSString *memiType = @"text/html";
        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:[request URL] MIMEType:memiType
            expectedContentLength:[fileData length] textEncodingName:nil];
        NSCachedURLResponse *cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:fileData];
        return cachedResponse;
    }else{
        return [super cachedResponseForRequest:request];
    }
}

- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request{
    NSString *urlStringMD5 = [request.URL.absoluteString md5];
    NSString *filePath = [[self getDocumentPath] stringByAppendingPathComponent:urlStringMD5];
    [cachedResponse.data writeToFile:filePath atomically:YES];
}

- (NSString *)getDocumentPath
{
    NSString *document =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    return document;
}
@end
