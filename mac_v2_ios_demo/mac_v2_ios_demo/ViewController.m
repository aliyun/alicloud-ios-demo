//
//  ViewController.m
//  mac_v2_ios_demo
//
//  Created by junmo on 2017/8/30.
//  Copyright © 2017年 junmo. All rights reserved.
//

#import "ViewController.h"

#import <AlicloudMAC/AlicloudMAC.h>

static NSString *testAppKey = @"******";
static NSString *testAppSecret = @"******";
static NSArray *tableViewGroupNames;
static NSArray *tableViewCellTitleInSection;
static NSURLSession *_session;

typedef void (^CompletionHandler)(BOOL res, NSHTTPURLResponse *response, NSError *error);

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextView *logText;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTextFiled];
    [self initTableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* 移动加速SDK初始化 */
- (void)macSDKInit {
    /* 打开Log */
    [[AlicloudMACService sharedInstance] setLogEnabled:YES];
    [[AlicloudMACService sharedInstance] initWithAppKey:testAppKey appSecret:testAppSecret callback:^(BOOL res, NSError *error) {
        if (res) {
            [self showLog:@"MAC SDK init success."];
        } else {
            [self showLog:[NSString stringWithFormat:@"MAC SDK init failed, error: %@", error]];
        }
    }];
}

/* 移动加速SDK停止 */
- (void)macSDKStop {
    [[AlicloudMACService sharedInstance] stop:^(BOOL res, NSError *error) {
        if (res) {
            [self showLog:@"MAC SDK stop success."];
        } else {
            [self showLog:[NSString stringWithFormat:@"MAC SDK stop failed, error: %@", error]];
        }
    }];
}

/* 移动加速SDK重启 */
- (void)macSDKRestart {
    [[AlicloudMACService sharedInstance] restart:^(BOOL res, NSError *error) {
        if (res) {
            [self showLog:@"MAC SDK restart success."];
        } else {
            [self showLog:[NSString stringWithFormat:@"MAC SDK restart failed, error: %@", error]];
        }
    }];
}

#pragma mark 发网络请求
- (void)sendNetworkRequest:(NSString *)urlStr completionHandler:(CompletionHandler)completionHandler {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.protocolClasses = @[ [MACURLProtocol class] ];
        _session = [NSURLSession sessionWithConfiguration:configuration];
    });
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            [self showLog:[NSString stringWithFormat:@"Error: %@", error]];
            completionHandler(NO, (NSHTTPURLResponse *)response, error);
            return;
        }
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        [self showLog:[NSString stringWithFormat:@"Response code: %lu", (unsigned long)httpResponse.statusCode]];
        [self showLog:[NSString stringWithFormat:@"Content: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]]];
        completionHandler(YES, (NSHTTPURLResponse *)response, nil);
    }];
    [task resume];
}

+ (void)initialize {
    
    tableViewGroupNames = @[
                            @"移动加速SDK",
                            @"网络请求"
                            ];
    
    tableViewCellTitleInSection = @[
                                    @[ @"加速初始化", @"加速停止", @"加速重启", @"打开Log" ],
                                    @[ @"发送网络请求" ]
                                    ];
}

- (void)initTextFiled {
    self.logText = [[UITextView alloc] initWithFrame:CGRectMake(10, 30, self.view.frame.size.width - 20, 350)];
    [self.logText.layer setBorderWidth:1];
    self.logText.userInteractionEnabled = NO;
    [self.view addSubview:self.logText];
}

- (void)initTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 400, self.view.frame.size.width, self.view.frame.size.height - 400) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)showLog:(NSString *)text {
    NSLog(@"%@", text);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.logText.text = [self.logText.text stringByAppendingString:text];
        self.logText.text = [self.logText.text stringByAppendingString:@"\n"];
    });
}

#pragma mark TableView 数据源设置

/* Section Num */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return tableViewGroupNames.count;
}

/* Cell Num Each Section */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[tableViewCellTitleInSection objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = [NSString stringWithFormat:@"cellId-%ld-%ld", (long)indexPath.section, (long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    cell.textLabel.text = [self cellTitleForIndexPath:indexPath];
    return cell;
}

#pragma mark TableView 代理设置

/* Section Header Title */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return tableViewGroupNames[section];
}

/* Click Cell */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellTitle = [self cellTitleForIndexPath:indexPath];
    if ([cellTitle isEqualToString:@"加速初始化"]) {
        [self macSDKInit];
    } else if ([cellTitle isEqualToString:@"加速停止"]) {
        [self macSDKStop];
    } else if ([cellTitle isEqualToString:@"加速重启"]) {
        [self macSDKRestart];
    } else if ([cellTitle isEqualToString:@"发送网络请求"]) {
        [self sendNetworkRequest:@"https://********" completionHandler:^(BOOL res, NSHTTPURLResponse *response, NSError *error) {}];
    } else if ([cellTitle isEqualToString:@"打开Log"]) {
        [[AlicloudMACService sharedInstance] setLogEnabled:YES];
    }
}

- (NSString *)cellTitleForIndexPath:(NSIndexPath *)indexPath {
    return [[tableViewCellTitleInSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

@end
