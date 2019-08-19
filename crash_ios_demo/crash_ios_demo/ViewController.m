//
//  ViewController.m
//  crash_ios_demo
//
//  Created by sky on 2019/8/7.
//  Copyright © 2019 sky. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// crash
- (IBAction)testCrash:(id)sender {
    // full stack crash
    NSMutableArray *array = @[];
    [array addObject:nil];
}

// abort
- (IBAction)testAbort:(id)sender {
    // abort
    exit(0);
}

// freezing
- (IBAction)testFreezing:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSThread sleepForTimeInterval:30];
    });
}



@end
