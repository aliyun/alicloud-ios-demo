//
//  ViewController.m
//  mac_ios_demo
//
//  Created by nanpo.yhl on 15/10/9.
//  Copyright (c) 2015年 com.aliyun.mobile. All rights reserved.
//

#import <AlicloudMobileAcceleration/ALBBMAC.h>
#import <libkern/OSAtomic.h>
#import "ViewController.h"
#import "Constants.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startNative;
@property (weak, nonatomic) IBOutlet UIButton *startMAC;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UILabel *nativeRt;
@property (weak, nonatomic) IBOutlet UILabel *nativeSuccess;
@property (weak, nonatomic) IBOutlet UILabel *nativeFailure;
@property (weak, nonatomic) IBOutlet UILabel *nativeTotal;
@property (weak, nonatomic) IBOutlet UILabel *macRt;
@property (weak, nonatomic) IBOutlet UILabel *macSuccess;
@property (weak, nonatomic) IBOutlet UILabel *macFailure;
@property (weak, nonatomic) IBOutlet UILabel *macTotal;
@end

@implementation ViewController {
    BOOL _isMACEnabled;
}

- (IBAction)startBenchmark:(id)sender {
    // Disable start buttons.
    [self setButtonsEnabled:false];
    
    // Turn on/off MAC.
    if (sender == self.startMAC && !_isMACEnabled) {
        [ALBBMAC restart];
        _isMACEnabled = true;
    }
    if (sender == self.startNative && _isMACEnabled) {
        [ALBBMAC stop];
        _isMACEnabled = false;
    }
    
     // Init UI controls.
    [self updateProgressBar:0];
    [self updateLabelsByRtSum:0 successCount:0 failureCount:0];
    
    // Execute benchmark tasks.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int requestCount = 0;
        __block volatile int32_t successCount = 0;
        __block volatile int32_t rtSum = 0;
        dispatch_queue_t requestQueue = dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT);
        dispatch_group_t dispatchGroup = dispatch_group_create();
        
        NSLog(@"Start benchmark using %s", _isMACEnabled ? "MAC" : "Native");
        
        while (requestCount < TOTAL_REQUESTS_NUM) {
            int numConcurrentRequests = MIN(arc4random_uniform(MAX_CONCURRENT_REQUESTS_NUM) + 1,
                                            TOTAL_REQUESTS_NUM - requestCount);
            NSLog(@"Execute requests %d to %d", requestCount + 1, requestCount + numConcurrentRequests);
            
            for (int i = 0; i < numConcurrentRequests; i++) {
                dispatch_group_async(dispatchGroup, requestQueue, ^{
                    // Use API for last request, and a random IMG for others.
                    NSString *requestURLStr = REQUEST_URL_API;
                    if (i < numConcurrentRequests - 1) {
                        requestURLStr = (arc4random_uniform(2) == 0 ? REQUEST_URL_IMG1: REQUEST_URL_IMG2);
                    }
                    
                    // Construct request.
                    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
                    [request setURL:[NSURL URLWithString:requestURLStr]];
                    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
                    [request setTimeoutInterval:REQUEST_TIMEOUT_INTERVAL];
                    
                    // Send request.
                    NSHTTPURLResponse* response;
                    NSError *error;
                    NSDate *date = [NSDate date];
                    
                    [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
                    //NSLog(@"Response: %@", response);
                    
                    // Process response.
                    if (error) {
                        NSLog(@"Failed to send request: %@", error);
                    } else if (response.statusCode != 200) {
                        NSLog(@"Status code: %ld", response.statusCode);
                    } else {
                        int32_t rt_ms = (int32_t) ([date timeIntervalSinceNow] * -1000.0);
                        //NSLog(@"Response time: %d ms", rt_ms);
                        OSAtomicAdd32(rt_ms, &rtSum);
                        OSAtomicIncrement32(&successCount);
                    }
                });
            }
            
            dispatch_group_wait(dispatchGroup, DISPATCH_TIME_FOREVER);
            
            requestCount += numConcurrentRequests;
            
            // Update UI controls.
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self updateProgressBar:requestCount];
                [self updateLabelsByRtSum:rtSum successCount:successCount failureCount:(requestCount - successCount)];
            });
        }
    });
    
    // Re-enable start buttons.
    [self setButtonsEnabled:true];
}

- (void) setButtonsEnabled:(BOOL)enable {
    [self.startNative setEnabled:enable];
    [self.startMAC setEnabled:enable];
}

- (void) updateProgressBar:(int)requestCount {
    [self.progressBar setProgress:((float)requestCount / TOTAL_REQUESTS_NUM)];
}

- (void) updateLabelsByRtSum:(int)rtSum successCount:(int)successCount failureCount:(int)failureCount {
    int averageRt = (successCount != 0 ? rtSum / successCount : 0);
    int totalCount = successCount + failureCount;
    if (!_isMACEnabled) {
        [self.nativeRt setText:[NSString stringWithFormat:@"%d ms", averageRt]];
        [self.nativeSuccess setText:[NSString stringWithFormat:@"%d", successCount]];
        [self.nativeFailure setText:[NSString stringWithFormat:@"%d", failureCount]];
        [self.nativeTotal setText:[NSString stringWithFormat:@"%d", totalCount]];
    } else {
        [self.macRt setText:[NSString stringWithFormat:@"%d ms", averageRt]];
        [self.macSuccess setText:[NSString stringWithFormat:@"%d", successCount]];
        [self.macFailure setText:[NSString stringWithFormat:@"%d", failureCount]];
        [self.macTotal setText:[NSString stringWithFormat:@"%d", totalCount]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // MAC is enabled at startup.
    _isMACEnabled = true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
