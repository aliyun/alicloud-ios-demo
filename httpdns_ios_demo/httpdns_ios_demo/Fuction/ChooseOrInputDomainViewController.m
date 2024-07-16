//
//  ChooseOrInputHostViewController.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/12.
//

#import "ChooseOrInputDomainViewController.h"
#import "DomainTableViewCell.h"

@interface ChooseOrInputDomainViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *domainTextField;
@property (weak, nonatomic) IBOutlet UITableView *domainsList;

@property(nonatomic, copy)NSArray *inputHistory;
@property(nonatomic, copy)NSArray *domains;
@property(nonatomic, strong)NSMutableArray *search_InputHistory;
@property(nonatomic, strong)NSMutableArray *search_Domains;

@end

@implementation ChooseOrInputDomainViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.domains = [HTTPDNSDemoUtils domains];
    self.inputHistory = [HTTPDNSDemoUtils inputDomainsHistory];
    self.search_InputHistory = self.inputHistory.mutableCopy;
    self.search_Domains = self.domains.mutableCopy;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.domainsList.delegate = self;
    self.domainsList.dataSource = self;
    self.domainTextField.delegate = self;

    // 设置 sectionHeaderTopPadding 为零 (iOS 15 及以上)
    if (@available(iOS 15.0, *)) {
        self.domainsList.sectionHeaderTopPadding = 0;
    }
}

#pragma mark - action

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cleanAllInputHistory {
    [self.search_InputHistory removeAllObjects];
    [self.domainsList reloadData];
    [HTTPDNSDemoUtils inputCacheRemoveAll];
}

- (void)domainFinished {
    if ([self.delegate respondsToSelector:@selector(domainResult:)]) {
        [self.delegate domainResult:self.domainTextField.text];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - TableView Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = 0;
    if (self.search_Domains.count > 0) {
        count++;
    }
    if (self.search_InputHistory.count > 0) {
        count++;
    }

    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    if (section == 0 && self.search_InputHistory.count > 0) {
        count = self.search_InputHistory.count;
    } else {
        count = self.search_Domains.count;
    }

    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 36;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(16, 0, tableView.frame.size.width, 36)];

    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 36)];
    titleLabel.font = [UIFont systemFontOfSize:16 weight:500];
    titleLabel.textColor = [UIColor colorWithHexString:@"#1F2024"];
    [headerView addSubview:titleLabel];

    if (section == 0 && self.search_InputHistory.count > 0) {
        titleLabel.text = @"输入历史";

        UIButton *cleanButton = [[UIButton alloc]initWithFrame:CGRectMake(headerView.frame.size.width - 70, 0, 70, 36)];
        [cleanButton setTitle:@"清空全部" forState:UIControlStateNormal];
        [cleanButton setTitleColor:[UIColor colorWithHexString:@"#B6C1D3"] forState:UIControlStateNormal];
        cleanButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [cleanButton addTarget:self action:@selector(cleanAllInputHistory) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:cleanButton];
    } else {
        titleLabel.text = @"控制台域名列表";
    }

    if (section == 1) {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#E6EBF3"];
        [headerView addSubview:line];
    }

    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DomainTableViewCell *domainCell = [DomainTableViewCell domainCellWithTableView:tableView];

    __weak typeof(self) weakSelf = self;
    domainCell.deleteHandle = ^(NSString * _Nullable domain) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf.search_InputHistory[indexPath.row] == domain) {
            [strongSelf.search_InputHistory removeObjectAtIndex:indexPath.row];
            [strongSelf.domainsList reloadData];
            [HTTPDNSDemoUtils inputCacheRemove:domain];
        }
    };

    NSString *domain;
    DomainTableViewCellType cellType;
    if (indexPath.section == 0 && self.search_InputHistory.count > 0) {
        domain = self.search_InputHistory[indexPath.row];
        cellType = DomainInputHistoryTableViewCell;
    } else {
        domain = self.search_Domains[indexPath.row];
        cellType = DomainServerListTableViewCell;
    }
    [domainCell setDomain:domain type:cellType];

    return domainCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DomainTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *selectedDomain = [cell selectedDomain];

    self.domainTextField.text = selectedDomain;
    [self domainFinished];
}

#pragma mark - textField Delegate

- (IBAction)textFieldValueChanged:(UITextField *)textField {
    if ([textField.text isEqualToString:@""] || textField.text == nil) {
        self.search_Domains = self.domains.mutableCopy;
        self.search_InputHistory = self.inputHistory.mutableCopy;
        [self.domainsList reloadData];
        return;
    }

    [self.search_Domains removeAllObjects];
    [self.search_InputHistory removeAllObjects];
    for (NSString *domain in self.domains) {
        if ([domain containsString:textField.text]) {
            [self.search_Domains addObject:domain];
        }
    }

    for (NSString *inputDomain in self.inputHistory) {
        if ([inputDomain containsString:textField.text]) {
            [self.search_InputHistory addObject:inputDomain];
        }
    }
    [self.domainsList reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (![HTTPDNSDemoTools isValidString:textField.text]) {
        return YES;
    }

    if (self.search_Domains.count == 0 && self.search_InputHistory.count == 0) {
        [HTTPDNSDemoUtils inputCacheAdd:textField.text];
    }

    [self domainFinished];
    return YES;
}

@end
