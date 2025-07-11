#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 代理WebView控制器
 * 用于展示网页内容，支持HTTPDNS代理和系统网络
 */
@interface ProxyWebViewController : UIViewController

- (instancetype)initWithURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END 
