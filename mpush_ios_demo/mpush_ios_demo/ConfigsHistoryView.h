//
//  ConfigsHistoryView.h
//  mpush_ios_demo
//
//  Created by Miracle on 2025/5/13.
//  Copyright © 2025 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 定义一个回调Block类型
typedef void(^SelectionCallback)(NSDictionary *configs);

@interface ConfigsHistoryView : UIView<UITableViewDelegate, UITableViewDataSource>

// 回调属性
@property (nonatomic, copy) SelectionCallback selectionCallback;

+ (void)showHistoryList:(SelectionCallback)callBack;

@end

NS_ASSUME_NONNULL_END
