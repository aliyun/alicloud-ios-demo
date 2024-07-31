//
//  SettingViewController.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/25.
//

#import "SettingViewController.h"
#import "SettingSwitchTableViewCell.h"
#import "SettingInfoModel.h"
#import "SettingTableViewCell.h"
#import "SettingAdvancedTableViewCell.h"
#import "SettingDomainListViewController.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *settingTableView;
@property(nonatomic, copy)NSArray<SettingInfoModel *> *infoArray;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.infoArray = [HTTPDNSDemoUtils settingInfo];

    self.settingTableView.delegate = self;
    self.settingTableView.dataSource = self;
}

#pragma mark - UITableView delegate & dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    switch (section) {
        case 0:
            count = self.infoArray.count + 2;
            break;
        case 1:
            count = 2;
            break;
        default:
            count = 3;
            break;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [UIView new];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    titleLabel.font = [UIFont systemFontOfSize:28 weight:500];
    titleLabel.textColor = [UIColor colorWithHexString:@"#3D3D3D"];
    if (section == 0) {
        titleLabel.text = @"通用";
        [header addSubview:titleLabel];
    } else if (section == 1) {
        titleLabel.text = @"高级配置";
        [header addSubview:titleLabel];
    }

    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 通用设置
    if (indexPath.section == 0) {
        if (indexPath.row == self.infoArray.count) {
            SettingTableViewCell *cell = [[SettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SETTINGTABLEVIEWCELL"];
            NSString *region = [HTTPDNSDemoUtils settingInfo:settingInfoRegionKey];
            NSString *locationString = [self regionToLoaction:region];
            [cell setCellTitle:@"Region" description:@"设置Region" cellType:RegionCell detailValue:locationString];
            cell.valueChangedHandle = ^(NSString * _Nonnull value) {
                [HTTPDNSDemoUtils settingInfoChanged:settingRegionKey value:value];
            };
            return cell;
        } else if (indexPath.row == self.infoArray.count + 1) {
            SettingTableViewCell *cell = [[SettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SETTINGTABLEVIEWCELL"];
            NSString *value = [HTTPDNSDemoUtils settingInfo:settingInfoTimeoutKey];
            if (![HTTPDNSDemoTools isValidString:value]) {
                value = @"3000";
            }
            [cell setCellTitle:@"超时时间" description:@"设置解析超时时间" cellType:TimeOutCell detailValue:value];
            cell.valueChangedHandle = ^(NSString * _Nonnull value) {
                [HTTPDNSDemoUtils settingInfoChanged:settingTimeoutKey value:value];
            };
            return cell;
        }

        SettingSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SWITCHCELL"];
        if (!cell) {
            cell = [[SettingSwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SWITCHCELL"];
        }
        SettingInfoModel *infoModel = self.infoArray[indexPath.row];
        [cell setTitle:infoModel.title description:infoModel.descripte isOn:infoModel.switchIsOn];

        __weak typeof(self) weakSelf = self;
        cell.switchChangedhandle = ^(BOOL isOn) {
            __strong typeof(self) strongSelf = weakSelf;
            SettingInfoModel *model = strongSelf.infoArray[indexPath.row];
            [HTTPDNSDemoUtils settingInfoChanged:model.cacheKey value:@(isOn)];
        };

        return cell;
    // 高级配置
    }else if (indexPath.section == 1) {
        SettingAdvancedTableViewCell *advancedSettingCell = [[SettingAdvancedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ADVANCEDSETTINGCELL"];
        if (indexPath.row == 0) {
            [advancedSettingCell setTitle:@"预解析域名列表" description:@"配置需要预解析的域名列表"];
        } else {
            [advancedSettingCell setTitle:@"清空指定域名缓存" description:@"配置需要清空缓存的域名列表"];
        }

        return advancedSettingCell;
    // 其他设置项
    } else {

    }

    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        SettingDomainListViewController *domainListViewController = [HTTPDNSDemoTools storyBoardInstantiateViewController:@"SettingDomainListViewController"];
        domainListViewController.listType = indexPath.row == 0 ? PreResolveDomainList : CleanCacheDomainList;
        [self.navigationController showViewController:domainListViewController sender:nil];
    }
}

- (NSString *)regionToLoaction:(NSString *)region {
    if ([region isEqualToString:@"cn"]) {
        return @"中国大陆";
    } else if ([region isEqualToString:@"hk"]) {
        return @"香港";
    } else if ([region isEqualToString:@"sg"]) {
        return @"新加坡";
    } else if ([region isEqualToString:@"de"]) {
        return @"德国";
    } else if ([region isEqualToString:@"us"]) {
        return @"美国";
    } else {
        return @"中国大陆";
    }
}

@end
