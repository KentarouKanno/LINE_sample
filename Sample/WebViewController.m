//
//  WebViewController.m
//  Sample
//
//  Created by 波切 賢一 on 12/06/28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// WebViewでリクエストが読み込まれた時に呼ばれるイベント
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    if ([request.URL.scheme isEqualToString:@"line"]) {
        
        BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"line://"]];
       
        if ( canOpen ) {
           
            //installed
           // NSString *text = @"http://apple.co.jp";
        
            NSString *item = @"エンコーディング文字列";
            NSString *urlEncodeString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( NULL, (CFStringRef)item, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 ));
            
            NSString *text = @"文字列文字列 | 文字列 http://aaaaaaaaa.co.jp/12345678";
            
            
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"line://msg/text/%@", [text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
            
        } else {
            
            //Not Install
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"LINEがインストールされていない為この機能は使用できません。" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            // App StoreのLINEのページを開く
         //   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/jp/app/line/id443904275?ls=1&mt=8"]];
            
            return NO;
        }
        return YES;
    }
    
    
    // schemeがnativeの場合は、処理をフックしてNative処理を呼び出す
    if ([ request.URL.scheme isEqualToString:@"native" ]) {
        
        // <a href="native://closeWebView">WEBViewを閉じる</a>
        // <a href="native://showSystemInfo">システム情報を取得</a>
        
        // フック処理
        [ self invokeNativeMethod: request ];
        
        // WebViewの読み込みは中断する。
        return NO;
    }
    // 通常のschemeの場合は、フックせずそのまま処理を続ける
    else {
        return YES;
    }
}

// Native処理を呼び出す
-(void)invokeNativeMethod: (NSURLRequest *)request
{
    // native://closeWebViewが指定された場合
    if ([request.URL.host isEqualToString:@"closeWebView"]) {
        [ self closeWebView ];
    }
    // native://showSystemInfoが指定された場合
    else if ([request.URL.host isEqualToString:@"showSystemInfo"]) {
        [ self showSystemInfo ];
    }
}

// WebViewを閉じる
-(void)closeWebView
{
    [ self.presentingViewController dismissModalViewControllerAnimated: YES ];
}

// システムの情報をWebView内に表示する。
-(void)showSystemInfo
{
    // システム情報を取得する
    UIDevice *device = [ UIDevice currentDevice];
    NSString *systemInfo = [ NSString stringWithFormat:@"name=%@, version=%@",
                            device.systemName, 
                            device.systemVersion ];
    
    // 呼び出しスクリプトを作成
    NSString *script = [ NSString stringWithFormat:@"$('#placeholder').text('%@')", systemInfo ];
    
    NSLog(@"script=%@", script);
    // スクリプトを呼び出して、WebViewに変更を反映する
    [ self.webView stringByEvaluatingJavaScriptFromString: script ];
}

@end
