//
//  ViewController.m
//  WebViewEventIntercept
//
//  Created by siasun on 2017/10/12.
//  Copyright © 2017年 siasun. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>


@interface ViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) JSContext *context;
@property (nonatomic, strong) UIView *popView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.60.2/webViewEvent/event.html"]];
    self.webView.delegate = self;
    [self.webView loadRequest:request];
    
    [self setupJsContent];
}

- (void)setupJsContent
{
    self.context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    self.context[@"alert"] = ^(NSString *str)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view addSubview:self.popView];
            
            [UIView animateWithDuration:2 animations:^{
                [self.popView setTransform:CGAffineTransformMakeRotation(M_PI)];
                self.popView.frame = CGRectMake(150, 200, 200, 200);
            } completion:^(BOOL finished) {
                self.popView.frame = CGRectMake(0, 0, 0, 0);
                [self.popView removeFromSuperview];
            }];
        });
    };
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [request.mainDocumentURL.relativePath isEqualToString:@""];
    [request.URL.scheme isEqualToString:@""];
    
    return YES;
}

- (UIView *)popView
{
    if (!_popView) {
        _popView = [[UIView alloc] init];;
        _popView.frame = CGRectMake(0, 0, 0, 0);
        _popView.backgroundColor = [UIColor yellowColor];
    }
    return _popView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
