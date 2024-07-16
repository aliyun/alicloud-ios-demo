//
//  DomainTableViewCell.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/15.
//

#import "DomainTableViewCell.h"

@interface DomainTableViewCell()

@property(nonatomic, strong)UILabel *domainTitleLabel;
@property(nonatomic, strong)UIButton *removeDomainButton;

@end

@implementation DomainTableViewCell

+ (instancetype)domainCellWithTableView:(UITableView *)tableView {
    static NSString *const reuseIdentifier = @"DomainTableViewCell";
    DomainTableViewCell *domainCell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!domainCell) {
        domainCell = [[DomainTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return domainCell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    [self.contentView addSubview:self.domainTitleLabel];
    [self.contentView addSubview:self.removeDomainButton];

    [NSLayoutConstraint activateConstraints:@[
        [self.domainTitleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [self.domainTitleLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
        [self.domainTitleLabel.heightAnchor constraintEqualToConstant:20],
        [self.domainTitleLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-40],

        [self.removeDomainButton.widthAnchor constraintEqualToConstant:10],
        [self.removeDomainButton.heightAnchor constraintEqualToConstant:10],
        [self.removeDomainButton.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
        [self.removeDomainButton.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10]
    ]];
}

- (void)setDomain:(NSString *)domain type:(DomainTableViewCellType)cellType {
    self.domainTitleLabel.text = domain;
    [self.removeDomainButton setHidden:(cellType == DomainServerListTableViewCell)];
}

- (NSString *)selectedDomain {
    return self.domainTitleLabel.text;
}

- (void)removeDomain {
    self.deleteHandle(self.domainTitleLabel.text);
}

#pragma mark - lazy load

- (UILabel *)domainTitleLabel {
    if (!_domainTitleLabel) {
        _domainTitleLabel = [[UILabel alloc]init];
        _domainTitleLabel.font = [UIFont systemFontOfSize:16];
        _domainTitleLabel.textColor = [UIColor colorWithHexString:@"#384153"];
        _domainTitleLabel.textAlignment = NSTextAlignmentLeft;
        _domainTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _domainTitleLabel;
}

- (UIButton *)removeDomainButton {
    if (!_removeDomainButton) {
        _removeDomainButton = [[UIButton alloc]init];
        [_removeDomainButton setBackgroundImage:[UIImage imageNamed:@"Close"] forState:UIControlStateNormal];
        [_removeDomainButton addTarget:self action:@selector(removeDomain) forControlEvents:UIControlEventTouchUpInside];
        _removeDomainButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _removeDomainButton;
}

@end
