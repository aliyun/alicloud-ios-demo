//
//  ConfigsHistoryView.m
//  mpush_ios_demo
//
//  Created by Miracle on 2025/5/13.
//  Copyright © 2025 alibaba. All rights reserved.
//

#import "ConfigsHistoryView.h"

@implementation ConfigsHistoryView {
    UITableView *_tableView;
    NSArray<NSDictionary *> *_data;
}

+ (void)showHistoryList:(SelectionCallback)callBack {
    NSArray *configs = [CommonTools userDefaultGet:kConfigsHistory];
    if (configs && configs.count > 0) {
        ConfigsHistoryView * configsListView = [[ConfigsHistoryView alloc] initWithData:configs];
        [configsListView show];
        configsListView.selectionCallback = callBack;
    } else {
        [MsgToolBox showAlert:@"提示" content:@"暂无历史记录"];
    }
}

// 初始化方法
- (instancetype)initWithData:(NSArray<NSDictionary *> *)data {
    // 设置弹框的大小，居中显示
    CGRect frame = CGRectMake(40, 100, [UIScreen mainScreen].bounds.size.width - 80, [UIScreen mainScreen].bounds.size.height / 2);
    self = [super initWithFrame:frame];
    if (self) {
        _data = data;
        self.layer.cornerRadius = 10.0;
        self.backgroundColor = [UIColor whiteColor];
        [self setupTableView];
    }
    return self;
}

- (void)show {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *backgroundView = [[UIView alloc] initWithFrame:keyWindow.bounds];
    backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [backgroundView addSubview:self];
    [keyWindow addSubview:backgroundView];
}

// 设置TableView
- (void)setupTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero]; // 去除多余的分割线
    [self addSubview:_tableView];
}

#pragma mark - UITableView delegate&dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CustomCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.textLabel.numberOfLines = 0; // 允许多行显示
    }
    NSDictionary *rowData = _data[indexPath.row];
    NSString *appKey = rowData[@"appKey"];
    NSString *secretKey = rowData[@"secretKey"];
    NSNumber *envNumber = rowData[@"env"];
    NSString *env = @"生产";
    if ([envNumber integerValue] == 1) {
        env = @"预发";
    }

    cell.textLabel.text = [NSString stringWithFormat:@"appKey: %@\nsecretKey: %@\n环境: %@", appKey, secretKey, env];
    cell.textLabel.font = [UIFont systemFontOfSize:16];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *rowData = _data[indexPath.row];
    if (self.selectionCallback) {
        self.selectionCallback(rowData); // 回调选中的数据字典
    }

    // 移除视图
    [[self superview] removeFromSuperview];
    [self removeFromSuperview];
}

@end
