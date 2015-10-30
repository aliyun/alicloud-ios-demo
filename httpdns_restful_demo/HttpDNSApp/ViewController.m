//
//  ViewController.m
//  HttpDNSApp
//
//  Created by nanpo.yhl on 15/10/30.
//  Copyright © 2015年 com.aliyun.mobile. All rights reserved.
//

#import "ViewController.h"


#import "NetworkManager.h"
#import "HttpDNSLog.h"
#import "HttpDNS.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [HttpDNSLog turnOnDebug];
    
    NSURL* url = [NSURL URLWithString:@"http://www.taobao.com/"];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSString* ip = [[HttpDNS instance] getIpByHost:url.host];
    if (ip) {
        NSString* newUrl = [NSString stringWithFormat:@"%@://%@%@",url.scheme,ip,url.path];
        request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:newUrl]];
        [request setValue:url.host forHTTPHeaderField:@"host"];
    }
    
    NSHTTPURLResponse* response;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
   
    NSLog(@"response %@",response);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
