//
//  WebViewController.m
//  WebViewEventIntercept
//
//  Created by siasun on 2018/9/21.
//  Copyright © 2018年 siasun. All rights reserved.
//

#import "WebViewController.h"
#import "LocalURLCache.h"
#import <WebKit/WebKit.h>
@interface WebViewController ()<WKUIDelegate,WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (nonatomic, strong) NSURLRequest *request;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loadURL = @"https://www.baidu.com";
    
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    
    //转换为NSURL类型
    NSURL *url = [NSURL URLWithString:self.loadURL];
    //WK用于正常加载
    self.request =  [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10];
    
//    [self.webView loadRequest:self.request];
    
    [self loadCache];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
//    [self cache];
}

- (void)cache
{
    NSURL *url = [NSURL URLWithString:self.loadURL];
    
    //得到NSData 数据
    NSData *dataContent = [NSData dataWithContentsOfURL:url];
    
    //NSURLCache 实例化
    LocalURLCache *cache = [[LocalURLCache alloc] init];
    
    //得到相应
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:url MIMEType:@"text/html" expectedContentLength:dataContent.length textEncodingName:@"UTF-8"];
    
    //得到CacheURLResponse
    NSCachedURLResponse *cacheResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:dataContent];
    
    //进行存储
    [cache storeCachedResponse:cacheResponse forRequest:self.request];

}

- (void)loadCache
{
    LocalURLCache *cache = [[LocalURLCache alloc] init];
    NSCachedURLResponse *current = [cache cachedResponseForRequest:self.request];
    if (current.data) {
        [self.webView loadData:current.data MIMEType:@"text/html" characterEncodingName:@"UTF-8" baseURL:self.request.URL];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
