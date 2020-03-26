//
//  ViewController.m
//  devops-ios-demo
//
//  Created by 魏晓堃 on 2019/12/11.
//  Copyright © 2019 魏晓堃. All rights reserved.
//

#import "ViewController.h"
#import "EMASDevOpsInfo.h"
 

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSDictionary *desDictionary;
@property (copy, nonatomic) NSArray *allDesKeys;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.allDesKeys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_id" forIndexPath:indexPath];
    NSDictionary *devOpsInfo = [[EMASDevOpsInfo shareInstance] converToParmaters];
    NSDictionary *desDictionary = self.desDictionary;
    NSString *key = self.allDesKeys[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@：%@", desDictionary[key], devOpsInfo[key]];
    return cell;
}

- (NSDictionary *)desDictionary {
    if (!_desDictionary) {
        _desDictionary = @{
//                                    @"ip" : @"客户端IP地址",
//                                     @"proxyIp" : @"代理服务器地址",
//                                     @"ttid" : @"渠道号",
                                     @"identifier" : @"唯一标志",
//                                     @"utdid" : @"UTDID",
                                     @"brand" : @"品牌",
                                     @"model" : @"机型",
                                     @"os" : @"系统名",
                                     @"osVersion" : @"系统版本",
//                                     @"apiLevel" : @"OS API级别（Android 特有）",
                                     @"appVersion" : @"应用版本",
//                                     @"arch" : @"客户端架构参数",
//                                     @"netStatus" : @"网络状态",
//                                     @"locale" : @"语言选项",
//                                     @"md5Sum" : @"当前包MD5值"
                                     
        };

    }
    return _desDictionary;
}

- (NSArray *)allDesKeys {
    if (!_allDesKeys) {
        _allDesKeys = [self.desDictionary allKeys];
    }
    return _allDesKeys;
}

@end
