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

@property (nonatomic, strong) UISwitch *ccpSwitch;

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

- (void)ccpSwitchChanged:(UISwitch *)sender {
    sender.thumbTintColor = [UIColor colorWithHexString:@"424FF7"];
    if (!sender.on) {
        sender.thumbTintColor = [UIColor colorWithHexString:@"BABCC2"];
    }

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:sender.on forKey:CCPSWITCHSTATE];
    [defaults synchronize];

    NSString *message;
    if (sender.on) {
        message = @"开启自有通道成功，重启生效";
    } else {
        message = @"关闭自有通道成功，重启生效";
    }

    [CustomToastUtil showToastWithMessage:message isSuccess:YES];
}

#pragma mark - lazy load

- (NSMutableArray *)informationArray {
    if (!_informationArray) {
        _informationArray = [NSMutableArray array];
    }
    return _informationArray;
}

- (UISwitch *)ccpSwitch {
    if (!_ccpSwitch) {
        _ccpSwitch = [[UISwitch alloc] init];
        _ccpSwitch.onTintColor = [UIColor colorWithHexString:@"#E9E9E9"];
        BOOL switchIsOn = [[NSUserDefaults standardUserDefaults] boolForKey:CCPSWITCHSTATE];
        _ccpSwitch.on = switchIsOn;
        _ccpSwitch.thumbTintColor = [UIColor colorWithHexString:@"424FF7"];
        if (!switchIsOn) {
            _ccpSwitch.thumbTintColor = [UIColor colorWithHexString:@"BABCC2"];
        }
        [_ccpSwitch addTarget:self action:@selector(ccpSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _ccpSwitch;
}

#pragma mark - UITableView delegate & dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.informationArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
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

    InformationCCPTableViewCell *cell = [[InformationCCPTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CCPSWITCHCELL"];
    cell.accessoryView = self.ccpSwitch;

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 28)];
        footer.backgroundColor = UIColor.whiteColor;

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 20, tableView.frame.size.width, 8)];
        line.backgroundColor = [UIColor colorWithHexString:@"#F2F3F7"];
        [footer addSubview:line];

        return footer;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 0.01;
    }
    return 28;
}

@end
