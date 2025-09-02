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
#import "SDKStatusManager.h"
#import "AppDelegate.h"

@interface InformationViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *informationTableView;

@property (nonatomic, strong) NSMutableArray *informationArray;

@end

@implementation InformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.informationTableView.delegate = self;
    self.informationTableView.dataSource = self;

    UINib *nib = [UINib nibWithNibName:@"InformationTableViewCell" bundle:nil];
    [self.informationTableView registerNib:nib forCellReuseIdentifier:@"InformationTableViewCell"];

    UIView *roundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.informationTableView.frame.size.width, 20)];
    roundView.backgroundColor = [UIColor whiteColor];
    [roundView addTopRoundedCornersWithRadius:20];
    self.informationTableView.tableHeaderView = roundView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupInformationData];
}

- (void)setupInformationData {
    [self.informationArray removeAllObjects];
    
    // 联系我们
    NSDictionary *contactUs = @{@"联系我们":@"搜索钉钉客户支持群：30959784"};
    [self.informationArray addObject:contactUs];

    NSString *deviceIDString;
    NSString *deviceIDTimeString;
    NSString *deviceTokenString;
    NSString *bindAccountString;

    BOOL SDKStatus = [SDKStatusManager getSDKInitStatus];

    // 如果SDK没有初始化成功，头部展示失败，并且不再获取deviceID、DeviceID存储日期、DeviceToken、当前绑定账号
    if (!SDKStatus) {
        NSDictionary *SDKStatus = @{@"SDK注册状态":@"注册失败"};
        [self.informationArray addObject:SDKStatus];

        deviceIDString = @"-";
        deviceIDTimeString = @"-";
        deviceTokenString = @"-";
        bindAccountString = @"-";
    } else {
        // DeviceID
        deviceIDString = [CloudPushSDK getDeviceId] ?: @"-";

        //deviceID 时间戳
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSString *deviceIDTStr = [userDef objectForKey:@"al_mp_devicedId_timerInterval"];
        deviceIDTimeString = @"-";
        if ([deviceIDTStr floatValue] > 0) {
            NSDate *deviceIDTDate = [NSDate dateWithTimeIntervalSince1970:[deviceIDTStr floatValue]];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            deviceIDTimeString = [dateFormatter stringFromDate:deviceIDTDate];
        }

        // deviceToken
        deviceTokenString = [CloudPushSDK getApnsDeviceToken] ?: @"-";

        // 当前绑定账号
        bindAccountString = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:DEVICE_BINDACCOUNT] ?: @"未绑定账号" ;
    }

    // DeviceID
    NSDictionary *deviceID = @{@"DeviceID":deviceIDString};
    [self.informationArray addObject:deviceID];

    //deviceID 时间戳
    NSDictionary *deviceIDTime = @{@"DeviceID存储日期":deviceIDTimeString};
    [self.informationArray addObject:deviceIDTime];

    // deviceToken
    NSDictionary *deviceToken = @{@"DeviceToken":deviceTokenString};
    [self.informationArray addObject:deviceToken];

    // 推送SDK版本号
    NSDictionary *SDKVersion = @{@"推送SDK版本号":[CloudPushSDK getVersion] ?: @"-"};
    [self.informationArray addObject:SDKVersion];

    // 当前绑定账号
    NSDictionary *bindAccount = @{@"当前绑定账号":bindAccountString};
    [self.informationArray addObject:bindAccount];

    if ([CommonTools getConfigViewVisible]) {
        // 当前配置的AppKey
        NSString *appKeyTips;
        if ([CommonTools stringIsEmpty:testAppKey]) {
            appKeyTips = @"未配置AppKey";
        } else {
            appKeyTips = testAppKey;
        }
        NSString *appKeyString = (NSString *)[CommonTools userDefaultGet:kAppKey] ?: appKeyTips;
        NSDictionary *appKey = @{@"AppKey":appKeyString};
        [self.informationArray addObject:appKey];

        // SDK当前环境
        NSNumber *envIndexNumber = [CommonTools userDefaultGet:kSDKEnv];
        NSString *envString = @"生产";
        if ([envIndexNumber integerValue] == 1) {
            envString = @"预发";
        }
        NSDictionary *env = @{@"SDK环境":envString};
        [self.informationArray addObject:env];
    }

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
    NSLog(@"cell-number: %lu", (unsigned long)self.informationArray.count);
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

// - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//     UIView *roundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.informationTableView.frame.size.width, 20)];
//     roundView.backgroundColor = [UIColor whiteColor];
//     [roundView addTopRoundedCornersWithRadius:20];
//     return roundView;
// }
// 
// - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//     return 20;
// }

@end
