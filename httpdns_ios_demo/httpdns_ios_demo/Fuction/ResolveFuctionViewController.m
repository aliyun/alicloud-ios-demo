//
//  ResolveFuctionViewController.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/12.
//

#import "ResolveFuctionViewController.h"
#import "ResolveTypeButton.h"
#import "ChooseOrInputDomainViewController.h"
#import <AlicloudHTTPDNS/AlicloudHttpDNS.h>
#import "TipsAlertView.h"

@interface ResolveFuctionViewController ()<ChooseOrInputDomainDelegate>

@property (weak, nonatomic) IBOutlet UITextField *domainTextField;
@property (weak, nonatomic) IBOutlet ResolveTypeButton *syncResolveButton;
@property (weak, nonatomic) IBOutlet ResolveTypeButton *asyncResolveButton;
@property (weak, nonatomic) IBOutlet ResolveTypeButton *syncNonBlockingResolveButton;
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;

@property(nonatomic, assign)ResolveType resolveType;
@property(nonatomic, strong)NSDate *startDate;
@property(nonatomic, strong)NSDate *endDate;

@end

@implementation ResolveFuctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.resultTextView.textContainerInset = UIEdgeInsetsMake(12, 20, 12, 20);
}

- (void)resolveHost:(NSString *)host type:(ResolveType)resolveType {
    self.domainTextField.text = host;

    switch (resolveType) {
        case ResolveTypeSync:
            [self syncButton:self.syncResolveButton];
            break;
        case ResolveTypeAsync:
            [self asyncButton:self.asyncResolveButton];
            break;
        case ResolveTypeSyncNoBlocking:
            [self syncNoBlockingButton:self.syncNonBlockingResolveButton];
            break;
        default:
            break;
    }

    [self resolveAvailableIp:host];
}

- (void)resolveAvailableIp:(NSString *)host {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        HttpDnsService *httpDnsService = [HttpDnsService sharedInstance];
        HttpdnsResult *result;
        HttpdnsRequest *request = [[HttpdnsRequest alloc] init];

        // 设置host
        request.host = host;

        // 设置超时时间
        NSString *timeOut = [HTTPDNSDemoUtils settingInfo:settingInfoTimeoutKey];
        if (![HTTPDNSDemoTools isValidString:timeOut]) {
            timeOut = @"2000";
        }
        double timeOut_ms = [timeOut doubleValue];
        double timeOut_s = timeOut_ms / 1000.0;
        request.resolveTimeoutInSecond = timeOut_s;

        self.startDate = [NSDate date];
        switch (self.resolveType) {
            case ResolveTypeSync:
                result = [httpDnsService resolveHostSync:request];
                break;
            case ResolveTypeSyncNoBlocking:
                result = [httpDnsService resolveHostSyncNonBlocking:request];
                break;
            case ResolveTypeAsync:
            {
                __weak typeof(self) weakSelf = self;
                [httpDnsService resolveHostAsync:request completionHandler:^(HttpdnsResult *result) {
                    __strong typeof(self) strongSelf = weakSelf;
                    [strongSelf processingResolveData:result];
                }];
            }
                return;
            default:
                break;
        }

        [self processingResolveData:result];
    });
}

- (void)processingResolveData:(HttpdnsResult *)result {
    self.endDate = [NSDate date];

    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableAttributedString *resolveResult = [[NSMutableAttributedString alloc]initWithString:@"该域名返回解析结果为空。\n\n可能原因\n1.该域名不在“域名列表”中。请将该域名添加到阿里云控制台HTTPDNS的“域名列表”\n\n2.该域名返回解析结果为空。"];
        [resolveResult addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#98A4BA"] range:NSMakeRange(0, resolveResult.length)];

        if (result.hasIpv4Address || result.hasIpv6Address) {
            NSMutableString *resultStr = [[NSMutableString alloc]init];

            NSTimeInterval timeInterval = [self.endDate timeIntervalSinceDate:self.startDate];
            double milliseconds = timeInterval * 1000;
            [resultStr appendFormat:@"%@(%.0fms)\nTTL: %.0fs\n\n",self.domainTextField.text,milliseconds,result.ttl];

            if (result.hasIpv4Address) {
                [resultStr appendString:@"IPV4\n"];
                NSString *ipv4s = [result.ips componentsJoinedByString:@","];
                [resultStr appendFormat:@"%@\n\n\n",ipv4s];
            }

            if (result.hasIpv6Address) {
                [resultStr appendString:@"IPV6\n"];
                NSString *ipv6s = [result.ipv6s componentsJoinedByString:@","];
                [resultStr appendFormat:@"%@\n\n",ipv6s];
            }

            resolveResult = [[NSMutableAttributedString alloc]initWithString:resultStr];
            [resolveResult addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#3D3D3D"] range:NSMakeRange(0, resolveResult.length)];

            NSRange ipv4Range = [resultStr rangeOfString:@"IPV4"];
            if (ipv4Range.location != NSNotFound) {
                [resolveResult addAttribute:NSForegroundColorAttributeName
                                      value:[UIColor colorWithHexString:@"#1B58F4"]
                                      range:ipv4Range];
            }

            NSRange ipv6Range = [resultStr rangeOfString:@"IPV6"];
            if (ipv6Range.location != NSNotFound) {
                [resolveResult addAttribute:NSForegroundColorAttributeName
                                      value:[UIColor colorWithHexString:@"#1B58F4"]
                                      range:ipv6Range];
            }
        }

        self.resultTextView.attributedText = resolveResult;
    });
}

#pragma mark - action

- (IBAction)syncButton:(id)sender {
    [self.syncResolveButton setSelected:YES];
    [self.asyncResolveButton setSelected:NO];
    [self.syncNonBlockingResolveButton setSelected:NO];

    self.resolveType = ResolveTypeSync;
}

- (IBAction)asyncButton:(id)sender {
    [self.asyncResolveButton setSelected:YES];
    [self.syncResolveButton setSelected:NO];
    [self.syncNonBlockingResolveButton setSelected:NO];

    self.resolveType = ResolveTypeAsync;
}

- (IBAction)syncNoBlockingButton:(id)sender {
    [self.syncNonBlockingResolveButton setSelected:YES];
    [self.asyncResolveButton setSelected:NO];
    [self.syncResolveButton setSelected:NO];

    self.resolveType = ResolveTypeSyncNoBlocking;
}

- (IBAction)chooseOrInputHost:(id)sender {
    ChooseOrInputDomainViewController *domainViewController = [HTTPDNSDemoTools storyBoardInstantiateViewController:@"ChooseOrInputDomainViewController"];
    domainViewController.delegate = self;
    [self.navigationController showViewController:domainViewController sender:nil];
}

- (IBAction)resolveAgain:(id)sender {
    [self resolveAvailableIp:self.domainTextField.text];
}

- (IBAction)preResolve:(id)sender {
    [[HttpDnsService sharedInstance] setPreResolveHosts:@[self.domainTextField.text] queryIPType:AlicloudHttpDNS_IPTypeV64];
}

- (IBAction)cleanDomainCache:(id)sender {
    [[HttpDnsService sharedInstance] cleanHostCache:@[self.domainTextField.text]];
}

#pragma mark - ChooseOrInputDomainDelegate

- (void)domainResult:(NSString *)domain isInput:(BOOL)isInput {
    if (isInput) {
        [TipsAlertView alertShow:@"域名解析提醒" message:[NSString stringWithFormat:@"在解析开始前，请将下方域名添加到阿里云控制台HTTPDNS的“域名列表”；否则无法返回解析结果。\n\n%@\n\n若已添加，则忽略此消息",domain] domain:domain];
    }
    
    self.domainTextField.text = domain;
}

@end
