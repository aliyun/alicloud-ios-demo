//
//  ViewController.m
//  KoaPullToRefresh
//
//  Created by Sergi Gracia on 09/05/13.
//  Copyright (c) 2013 Sergi Gracia. All rights reserved.
//

#import "ViewController.h"
#import "KoaPullToRefresh.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableValues;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    //Init values
    self.tableValues = [[NSMutableArray alloc] initWithObjects: @"Croissant cookie gingerbread",
                                                                @"Chocolate bar marshmallow",
                                                                @"Pudding carrot cake",
                                                                @"Topping candy canes chocolate bar",
                                                                @"Fruitcake chocolate",
                                                                @"Brownie biscuit",
                                                                @"Gummies ice cream",
                                                                @"Topping sesame snaps",
                                                                @"Topping marshmallow applicake",
                                                                @"Toffee jujubes",
                                                                @"Tart macaroon muffin",
                                                                @"Lemon drops",
                                                                @"Dessert biscuit oat cake",
                                                                @"Chocolate bar pastry", nil];
    
    //Add pull to refresh
    [self.tableView addPullToRefreshWithActionHandler:^{
        [self refreshTable];
    } withBackgroundColor:[UIColor colorWithRed:0.251 green:0.663 blue:0.827 alpha:1] withPullToRefreshHeightShowed:4];
    
    //Customize pulltorefresh text colors
    [self.tableView.pullToRefreshView setTextColor:[UIColor whiteColor]];
    [self.tableView.pullToRefreshView setTextFont:[UIFont fontWithName:@"OpenSans-Semibold" size:16]];
    
    //Set fontawesome icon
    [self.tableView.pullToRefreshView setFontAwesomeIcon:@"icon-refresh"];

    //Set titles
    [self.tableView.pullToRefreshView setTitle:@"Pull" forState:KoaPullToRefreshStateStopped];
    [self.tableView.pullToRefreshView setTitle:@"Release" forState:KoaPullToRefreshStateTriggered];
    [self.tableView.pullToRefreshView setTitle:@"Loading" forState:KoaPullToRefreshStateLoading];
    
    //Hide scroll indicator
    [self.tableView setShowsVerticalScrollIndicator:NO];

    [self.tableView.pullToRefreshView startAnimating];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.tableView.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshTable
{
    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:2];
    [self.tableView.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:2];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableValues.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    cell.textLabel.text = [self.tableValues objectAtIndex:indexPath.row];
    [cell.textLabel setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:13]];
    [cell.textLabel setTextColor:[UIColor grayColor]];
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    return cell;
}

@end
