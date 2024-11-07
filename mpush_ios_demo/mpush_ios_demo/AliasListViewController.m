//
//  AliasListViewController.m
//  mpush_ios_demo
//
//  Created by Miracle on 2024/10/30.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import "AliasListViewController.h"
#import "SettingTag.h"

@interface AliasListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *aliasListTableView;

@end

@implementation AliasListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.aliasListTableView.delegate = self;
    self.aliasListTableView.dataSource = self;
}

- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView delegate & dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.aliasArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AliasListCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AliasListCell"];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#4B4D52"];
    }
    cell.textLabel.text = self.aliasArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.chooseHandle) {
        self.chooseHandle(self.aliasArray[indexPath.row]);
    }
    [self goBack:nil];
}

@end
