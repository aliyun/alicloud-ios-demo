//
//  InformationViewController.m
//  mpush_ios_demo
//
//  Created by Miracle on 2024/10/31.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import "InformationViewController.h"
#import "InformationTableViewCell.h"
#import <CloudPushSDK/CloudPushSDK.h>
#import "CustomToastUtil.h"
#import "InformationCCPTableViewCell.h"

@interface InformationViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *informationTableView;

@property (nonatomic, strong)NSMutableArray *informationArray;

@end

@implementation InformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.informationTableView.delegate = self;
    self.informationTableView.dataSource = self;

    UINib *nib = [UINib nibWithNibName:@"InformationTableViewCell" bundle:nil];
    [self.informationTableView registerNib:nib forCellReuseIdentifier:@"InformationTableViewCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.informationTableView addTopRoundedCornersWithRadius:20];
    [self setupInformationData];
}

- (void)setupInformationData {
    [self.informationArray removeAllObjects];
    
    // 联系我们
    NSDictionary *contactUs = @{@"联系我们":@"搜索钉钉客户支持群：30959784"};
    [self.informationArray addObject:contactUs];

    // DeviceID
    NSDictionary *deviceID = @{@"DeviceID":[CloudPushSDK getDeviceId] ?: @"-"};
    [self.informationArray addObject:deviceID];

    //deviceID 时间戳
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *deviceIDTStr = [userDef objectForKey:@"al_mp_devicedId_timerInterval"];
    NSString *deviceIDTDateStr = @"-";
    if ([deviceIDTStr floatValue] > 0) {
        NSDate *deviceIDTDate = [NSDate dateWithTimeIntervalSince1970:[deviceIDTStr floatValue]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        deviceIDTDateStr = [dateFormatter stringFromDate:deviceIDTDate];
    }
    NSDictionary *deviceIDTime = @{@"DeviceID存储日期":deviceIDTDateStr};
    [self.informationArray addObject:deviceIDTime];

    // deviceToken
    NSDictionary *deviceToken = @{@"DeviceToken":[CloudPushSDK getApnsDeviceToken] ?: @"-"};
    [self.informationArray addObject:deviceToken];

    // 推送SDK版本号
    NSDictionary *SDKVersion = @{@"推送SDK版本号":[CloudPushSDK getVersion] ?: @"-"};
    [self.informationArray addObject:SDKVersion];

    // 当前绑定账号
    NSString *bindAccountString = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:DEVICE_BINDACCOUNT] ?: @"未绑定账号" ;
    NSDictionary *bindAccount = @{@"当前绑定账号":bindAccountString};
    [self.informationArray addObject:bindAccount];

    // 刷新list
    [self.informationTableView reloadData];
}

#pragma mark - lazy load

- (NSMutableArray *)informationArray {
    if (!_informationArray) {
        _informationArray = [NSMutableArray array];
    }
    return _informationArray;
}

#pragma mark - UITableView delegate & dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.informationArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InformationTableViewCell *informationCell = [tableView dequeueReusableCellWithIdentifier:@"InformationTableViewCell"];
    NSDictionary *data = self.informationArray[indexPath.row];
    [informationCell setTitle:data.allKeys.firstObject detail:data.allValues.firstObject];
    if ([data.allKeys.firstObject isEqualToString:@"DeviceID"] || [data.allKeys.firstObject isEqualToString:@"DeviceToken"]) {
        [informationCell showCopyButton];
    } else {
        [informationCell hiddenCopyButton];
    }
    return informationCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 28)];
    footer.backgroundColor = UIColor.whiteColor;

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 20, tableView.frame.size.width, 8)];
    line.backgroundColor = [UIColor colorWithHexString:@"#F2F3F7"];
    [footer addSubview:line];

    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 28;
}

@end
