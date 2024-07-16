//
//  DomainTableViewCell.h
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/15.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DomainServerListTableViewCell,
    DomainInputHistoryTableViewCell
} DomainTableViewCellType;

typedef void(^DeleteHandle)(NSString * _Nullable domain);

NS_ASSUME_NONNULL_BEGIN

@interface DomainTableViewCell : UITableViewCell

@property(nonatomic, copy)DeleteHandle deleteHandle;

+ (instancetype)domainCellWithTableView:(UITableView *)tableView;

- (void)setDomain:(NSString *)domain type:(DomainTableViewCellType)cellType;

- (NSString *)selectedDomain;


@end

NS_ASSUME_NONNULL_END
