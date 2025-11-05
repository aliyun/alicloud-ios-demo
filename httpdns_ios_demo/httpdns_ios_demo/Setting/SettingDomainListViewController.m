//
//  SettingDomainListViewController.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/30.
//

#import "SettingDomainListViewController.h"
#import "SettingDomainListTableViewCell.h"
#import "AddDomainAlertView.h"
#import <AlicloudHTTPDNS/AlicloudHttpDNS.h>
#import "UIView+Toast.h"

@interface SettingDomainListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *listDescription;
@property (weak, nonatomic) IBOutlet UITableView *domainList;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property(nonatomic, strong)NSMutableArray *domainsArray;
@property(nonatomic, strong)NSMutableArray *selectedArray;

@end

@implementation SettingDomainListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.domainsArray removeAllObjects];
    NSArray *domains = [HTTPDNSDemoUtils domains];
    [self.domainsArray addObjectsFromArray:domains];
    NSArray *addArray;

    if (self.listType == PreResolveDomainList) {
        self.navigationItem.title = @"预解析域名列表";
        addArray = [HTTPDNSDemoUtils settingDomainListFor:settingPreResolveListKey];
    } else {
        self.navigationItem.title = @"清空指定域名缓存";
        [self.confirmButton setTitle:@"清空缓存" forState:UIControlStateNormal];
        self.listDescription.text = @"调用接口会清除本地缓存。下一次请求时，服务端将重新向权威服务器发出请求，以获取域名最新的解析IP地址。";
        addArray = [HTTPDNSDemoUtils settingDomainListFor:settingCleanHostDomainKey];
    }
    if (addArray.count > 0) {
        [self.domainsArray addObjectsFromArray:addArray];
    }

    [self.domainList reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Navigation_Add"] style:UIBarButtonItemStyleDone target:self action:@selector(addDomain)];
    self.navigationItem.rightBarButtonItem = addButton;

    self.navigationController.navigationBarHidden = NO;

    self.domainList.delegate = self;
    self.domainList.dataSource = self;
}

- (void)addDomain {
    NSString *title = @"添加预解析域名";
    if (self.listType == CleanCacheDomainList) {
        title = @"添加需要清空缓存的域名";
    }
    __weak typeof(self) weakSelf = self;
    [AddDomainAlertView alertWithTitle:title handle:^(NSString * _Nonnull domain) {
        __strong typeof(self) strongSelf = weakSelf;
        if ([strongSelf.domainsArray containsObject:domain]) {
            return;
        }
        [strongSelf.domainsArray addObject:domain];
        [strongSelf.domainList reloadData];

        NSString *cacheKey = settingPreResolveListKey;
        if (self.listType == CleanCacheDomainList) {
            cacheKey = settingCleanHostDomainKey;
        }
        [HTTPDNSDemoUtils settingDomainListAdd:domain forKey:cacheKey];
    }];
}

- (IBAction)confirmClick:(id)sender {
    if (self.selectedArray.count <= 0) {
        return;
    }

    HttpDnsService *httpdns = [HttpDnsService sharedInstance];
    if (self.listType == PreResolveDomainList) {
        [httpdns setPreResolveHosts:self.selectedArray.copy queryIPType:AlicloudHttpDNS_IPTypeV64];
        [self.view showToastWithMessage:@"预解析成功" duration:1.5];
    } else {
        [httpdns cleanHostCache:self.selectedArray.copy];
        [self.view showToastWithMessage:@"缓存已清空" duration:1.5];
    }
}

#pragma mark - tableView delegate & dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.domainsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 24;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingDomainListTableViewCell *domainCell = [tableView dequeueReusableCellWithIdentifier:@"DOMAINLISTCELL"];
    if (!domainCell) {
        domainCell = [[SettingDomainListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DOMAINLISTCELL"];
    }

    NSString *domain = self.domainsArray[indexPath.section];
    BOOL isSelected = NO;
    if ([self.selectedArray containsObject:domain]) {
        isSelected = YES;
    }
    [domainCell setDomain:domain isSelected:isSelected];
    domainCell.selecetedHandle = ^(BOOL isSelected) {
        if (isSelected) {
            [self.selectedArray addObject:self.domainsArray[indexPath.section]];
        } else {
            [self.selectedArray removeObject:self.domainsArray[indexPath.section]];
        }
    };

    return domainCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingDomainListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell checkBoxClick];
}

#pragma mark - lazy load

- (NSMutableArray *)domainsArray {
    if (!_domainsArray) {
        _domainsArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _domainsArray;
}

- (NSMutableArray *)selectedArray {
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _selectedArray;
}

@end
