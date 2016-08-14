//
//  ViewController.m
//  08-掌握-NSURLSession-上传
//
//  Created by xiaomage on 15/7/15.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//
#define XMGBoundary @"520it"
#define XMGEncode(string) [string dataUsingEncoding:NSUTF8StringEncoding]
#define XMGNewLine [@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]

#import "ViewController.h"

@interface ViewController () 
/** session */
@property (nonatomic, strong) NSURLSession *session;
@end

@implementation ViewController

- (NSURLSession *)session
{
    if (!_session) {
        NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration defaultSessionConfiguration];
        cfg.timeoutIntervalForRequest = 10;
        // 是否允许使用蜂窝网络（手机自带网络）
        cfg.allowsCellularAccess = YES;
        _session = [NSURLSession sessionWithConfiguration:cfg];
    }
    return _session;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://120.25.226.186:32812/upload"]];
    request.HTTPMethod = @"POST";
    
    // 设置请求头(告诉服务器,这是一个文件上传的请求)
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", XMGBoundary] forHTTPHeaderField:@"Content-Type"];
    
    // 设置请求体
    NSMutableData *body = [NSMutableData data];
    
    // 文件参数
    // 分割线
    [body appendData:XMGEncode(@"--")];
    [body appendData:XMGEncode(XMGBoundary)];
    [body appendData:XMGNewLine];
    
    // 文件参数名
    [body appendData:XMGEncode([NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"test.png\""])];
    [body appendData:XMGNewLine];
    
    // 文件的类型
    [body appendData:XMGEncode([NSString stringWithFormat:@"Content-Type: image/png"])];
    [body appendData:XMGNewLine];
    
    // 文件数据
    [body appendData:XMGNewLine];
    [body appendData:[NSData dataWithContentsOfFile:@"/Users/xiaomage/Desktop/test.png"]];
    [body appendData:XMGNewLine];
    
    // 结束标记
    /*
     --分割线--\r\n
     */
    [body appendData:XMGEncode(@"--")];
    [body appendData:XMGEncode(XMGBoundary)];
    [body appendData:XMGEncode(@"--")];
    [body appendData:XMGNewLine];
    
    [[self.session uploadTaskWithRequest:request fromData:body completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"-------%@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
    }] resume];
}

@end
