//
//  LZLPersonalViewController.m
//  UserExperienceDemo
//
//  Created by liuzhilong on 15/4/1.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import "LZLPersonalViewController.h"
#import "LZLPersonalData.h"

@interface LZLPersonalViewController ()

@property NSMutableArray *personalDataItems;

@end

@implementation LZLPersonalViewController

-(void)viewDidAppear:(BOOL)animated {
    self.personalDataItems = [[NSMutableArray alloc] init];
    [self loadInitialData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.persionalDataTableView.delegate = self;
    self.persionalDataTableView.dataSource = self;
    
    self.personalDataItems = [[NSMutableArray alloc] init];
    [self loadInitialData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark 初始化一些个人数据，类似DeviceID之类的东西
- (void)loadInitialData {
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    LZLPersonalData *deviceid = [[LZLPersonalData alloc] init];
    deviceid.itemName = @"Device ID";
    deviceid.itemValue =  [CloudPushSDK getDeviceId];
    
    LZLPersonalData *sdkversion = [[LZLPersonalData alloc] init];
    sdkversion.itemName = @"CloudPush SDK Version";
    sdkversion.itemValue = [CloudPushSDK getVersion];
    
    LZLPersonalData *bingAccount = [[LZLPersonalData alloc] init];
    bingAccount.itemName = @"当前绑定账号";
    bingAccount.itemValue = [userDefaultes stringForKey:@"bindAccount"]==nil?@"当前设备未绑定任何账号":[userDefaultes stringForKey:@"bindAccount"];
    
    LZLPersonalData *connectUS = [[LZLPersonalData alloc] init];
    connectUS.itemName = @"联系我们";
    connectUS.itemValue = @"Demo App相关问题\n 请在阿里旺旺或旺信中搜索淘宝旺旺群：\n 1360183878";
    
    [[self personalDataItems] addObject:connectUS];
    [[self personalDataItems] addObject:deviceid];
    [[self personalDataItems] addObject:sdkversion];
    [[self personalDataItems] addObject:bingAccount];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.personalDataItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"personalDataCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    LZLPersonalData *tableview = [self.personalDataItems objectAtIndex:indexPath.row];
    cell.textLabel.text = tableview.itemName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    LZLPersonalData *tappedItem = [self.personalDataItems objectAtIndex:indexPath.row];
    [MsgToolBox showAlert:tappedItem.itemName content:tappedItem.itemValue];
}

@end
