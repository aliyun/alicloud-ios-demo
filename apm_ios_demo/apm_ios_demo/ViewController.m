//
//  ViewController.m
//  apm_ios_demo
//
//  Created by sky on 2019/10/11.
//  Copyright © 2019 aliyun. All rights reserved.
//

#import "ViewController.h"
#import "ALC1ViewController.h"
#import "ALC2ViewController.h"
#import "ALC3ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)page1:(id)sender {
    
    ALC1ViewController *vc1 = [[ALC1ViewController alloc] init];
    [self.navigationController pushViewController:vc1 animated:YES];
}

- (IBAction)page2:(id)sender {
    ALC2ViewController *vc1 = [[ALC2ViewController alloc] init];
    [self.navigationController pushViewController:vc1 animated:YES];
}

- (IBAction)page3:(id)sender {
    ALC3ViewController *vc1 = [[ALC3ViewController alloc] init];
    [self.navigationController pushViewController:vc1 animated:YES];
}


@end
