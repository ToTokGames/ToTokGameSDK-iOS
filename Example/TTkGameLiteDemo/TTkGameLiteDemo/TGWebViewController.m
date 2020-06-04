//
//  TTGCWebViewController.m
//  TTkGameSDK
//
//  Created by Balalaika on 2020/3/5.
//  Copyright © 2020 GMCT. All rights reserved.
//

#import "TGWebViewController.h"
#import <WebKit/WebKit.h>
#import "Header.h"

#define kTTGCBundleName @"TTkGame"


@interface TGWebViewController () <WKNavigationDelegate>

@property (nonatomic, strong) CALayer *progressLayer;
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation TGWebViewController

- (UIModalPresentationStyle)modalPresentationStyle{
    return UIModalPresentationFullScreen;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self navigation];
    [self makeWebView];
}

- (void)navigation {
    UIView *nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Nav_StatusBar_Height)];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = self.navTitle;
    [titleLabel sizeToFit];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.center = CGPointMake(SCREEN_WIDTH/2.0, StatusBar_Height + 22);
    [nav addSubview:titleLabel];
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(0, StatusBar_Height, 44, 44)];
    UIImage *icon = [UIImage imageWithContentsOfFile:[[self TTkGameBundle] pathForResource:@"nav_back@3x" ofType:@"png"]];
    [back setImage:icon forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [nav addSubview:back];
    [self.view addSubview:nav];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

//TTGCBundle
- (NSBundle *)TTkGameBundle {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:kTTGCBundleName ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    return bundle;
}

- (void)makeWebView {
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
    configuration.preferences.minimumFontSize = 10;//设置最小字体
    configuration.preferences.javaScriptEnabled = YES;//是否可以使用JavaScript
    configuration.preferences.javaScriptCanOpenWindowsAutomatically = NO;//JS是否可以自动打开页面
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, Nav_StatusBar_Height, SCREEN_WIDTH, SCREEN_HEIGHT-KBottomSpace_Height-Nav_StatusBar_Height) configuration:configuration];
    [self.view addSubview:self.webView];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    // 进度条
    UIView * progress = [[UIView alloc] initWithFrame:CGRectMake(0, Nav_StatusBar_Height, SCREEN_WIDTH, 2)];
    progress.backgroundColor = [UIColor clearColor];
    [self.view addSubview:progress];
    
    // 隐式动画
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 0, 2);
    layer.backgroundColor = [UIColor blueColor].CGColor;
    [progress.layer addSublayer:layer];
    self.progressLayer = layer;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        NSLog(@"change == %@",change);
        self.progressLayer.opacity = 1;
        self.progressLayer.frame = CGRectMake(0, 0, self.view.bounds.size.width * [change[NSKeyValueChangeNewKey] floatValue], 3);
        if ([change[NSKeyValueChangeNewKey] floatValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressLayer.opacity = 0;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressLayer.frame = CGRectMake(0, 0, 0, 3);
            });
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
       
- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
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
