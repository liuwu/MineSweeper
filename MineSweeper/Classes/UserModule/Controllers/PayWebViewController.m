//
//  PayWebViewController.m
//  MineSweeper
//
//  Created by liuwu on 2018/10/24.
//  Copyright © 2018年 liuwu. All rights reserved.
//

#import "PayWebViewController.h"
#import <AlipaySDK/AlipaySDK.h>

@interface PayWebViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NSString *webUrl;

@end

@implementation PayWebViewController

- (instancetype)initWithUrl:(NSString *)urlStr {
    self.webUrl = urlStr;
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.webView.delegate = nil;
}

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    webView.delegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).mas_offset(self.qmui_navigationBarMaxYInViewCoordinator);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(self.view);
    }];
    
    // 加载已经配置的url
//    NSString* webUrl = [[NSUserDefaults standardUserDefaults]objectForKey:@"alipayweburl"];
    if (_webUrl.length > 0) {
        [self loadWithUrlStr:_webUrl];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

#pragma mark -
#pragma mark   ============== webview相关 回调及加载 ==============
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //新版本的H5拦截支付对老版本的获取订单串和订单支付接口进行合并，推荐使用该接口
    __weak PayWebViewController* wself = self;
    BOOL isIntercepted = [[AlipaySDK defaultService] payInterceptorWithUrl:[request.URL absoluteString] fromScheme:@"AlipayPayMineSweeper" callback:^(NSDictionary *result) {
        // 处理支付结果
        NSLog(@"%@", result);
        // isProcessUrlPay 代表 支付宝已经处理该URL
        if ([result[@"isProcessUrlPay"] boolValue]) {
            dispatch_async_on_main_queue(^{
                NSInteger resultCode = [result[@"resultCode"] integerValue];
                [self showSuccess:resultCode];
            });
            // returnUrl 代表 第三方App需要跳转的成功页URL
//            NSString* urlStr = result[@"returnUrl"];
//            [wself loadWithUrlStr:urlStr];
        }
    }];
    
    if (isIntercepted) {
        return NO;
    }
    return YES;
}

- (void)showSuccess:(NSInteger)resultCode {
    //    9000——订单支付成功8000——正在处理中4000——订单支付失败5000——重复请求6001——用户中途取消6002——网络连接出错
    if (resultCode == 9000) {
        [WLHUDView showSuccessHUD:@"充值成功"];
    } else {
        [WLHUDView showErrorHUD:@"充值失败，请重试"];
    }
}

- (void)loadWithUrlStr:(NSString*)urlStr
{
    if (urlStr.length > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURLRequest *webRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                        cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                    timeoutInterval:30];
            [self.webView loadRequest:webRequest];
        });
    }
}

@end
