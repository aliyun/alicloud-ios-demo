//
//  UTTPKItem.h
//  miniUTSDK
//
//  Created by 宋军 on 15/5/19.
//  Copyright (c) 2015年 ___SONGJUN___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UTTPKItem : NSObject

/*透传key
 */
@property NSString * key;
/*透传方式,有两种:
 *就近:@"nearby"
 *就远:@"far"
 */
@property NSString * type;
/*获取透传key对应的value，有四种来源方式：
 *从url获取:${url|keyx}
 *从updatePageProperties获取:${ut|keyx}
 *先从updatePageProperties获取,然后从url获取:${keyx}
 *静态值:valuex
 */
@property NSString * fetchRule;

@end
