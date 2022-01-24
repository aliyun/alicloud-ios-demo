//
//  FeedsViewController.m
//  AliCloudCodeDemo
//
//  Created by yannan on 2022/1/24.
//

#import "FeedsViewController.h"
#import <AlicloudCloudCode/AliccAdNativeExpressAdManager.h>
#import <AlicloudCloudCode/AliccAdNativeExpressAdView.h>
#import "UIColor+CloudCodeDemo.h"
#import "UIAlertController+CloudCodeDemo.h"


@interface FeedsViewController () <UITableViewDelegate, UITableViewDataSource, AliccAdNativeExpressAdDelegate>



@property (weak, nonatomic) IBOutlet UILabel *widthLbl;
@property (weak, nonatomic) IBOutlet UISlider *widthSlider;

@property (weak, nonatomic) IBOutlet UILabel *heightLbl;
@property (weak, nonatomic) IBOutlet UISlider *heightSlider;

@property (weak, nonatomic) IBOutlet UILabel *countLbl;
@property (weak, nonatomic) IBOutlet UISlider *countSlider;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;


@property (weak, nonatomic) IBOutlet UITextField *slotidTextField;


/*   -----------------------------------------------------------------------      */

@property (nonatomic, strong) AliccAdNativeExpressAdManager *expressAdManager;
@property (nonatomic, strong) NSMutableArray <AliccAdNativeExpressAdView *>* expressAdViews;

@end

@implementation FeedsViewController

static NSString *const NativeCell = @"NativeCell";
static NSString *const ExpressAdCell = @"ExpressAdCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    [self.mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NativeCell];
    [self.mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ExpressAdCell];
    
    
    self.widthSlider.minimumValue = 0;
    self.widthSlider.maximumValue = [UIScreen mainScreen].bounds.size.width;
    self.widthSlider.value = self.widthSlider.maximumValue;
    self.widthLbl.text = [NSString stringWithFormat:@"宽:%d", (int)self.widthSlider.value];
    
    self.heightSlider.minimumValue = 0;
    self.heightSlider.maximumValue = [UIScreen mainScreen].bounds.size.height;
    self.heightSlider.value = self.heightSlider.minimumValue;
    self.heightLbl.text = [NSString stringWithFormat:@"高:%d", (int)self.heightSlider.value];
    
    
    self.countSlider.minimumValue = 1;
    self.countSlider.maximumValue = 3;
    self.countSlider.value = self.countSlider.maximumValue;
    self.countLbl.text = [NSString stringWithFormat:@"count:%d", (int)self.countSlider.value];
    
    
}


- (IBAction)loadAd:(id)sender {
    
    
    if (self.slotidTextField.text.length <= 0) {
        [UIAlertController alicc_showAlertTitle:@"请检查输入" message:@"广告位为空" parentVC:self];
        return;
    }
    
    
    
    AliccAdNativeExpressAdManagerProps *props = [[AliccAdNativeExpressAdManagerProps alloc] init];
    props.expressType = AliccAdNativeExpressAdType_All;
    props.adSize = CGSizeMake(self.widthSlider.value, self.heightSlider.value);
    props.videoMuted = YES;
    props.minVideoDuration = 5;
    props.maxVideoDuration = 10;
    self.expressAdManager = [[AliccAdNativeExpressAdManager alloc] initWithSlotID:self.slotidTextField.text expressProps:props];
    self.expressAdManager.adDelegate = self;
    [self.expressAdManager loadAdData:(int)self.countSlider.value];
}

- (IBAction)sliderChanged:(id)sender {
    
    if (sender == self.widthSlider) {
        self.widthLbl.text = [NSString stringWithFormat:@"宽:%d", (int)self.widthSlider.value];
    } else if (sender == self.heightSlider) {
        self.heightLbl.text = [NSString stringWithFormat:@"高:%d", (int)self.heightSlider.value];
    } else if (sender == self.countSlider) {
        self.countLbl.text = [NSString stringWithFormat:@"count:%d", (int)self.countSlider.value];
    }
    
    
    
}


#pragma mark -
#pragma mark -------------- AliccAdNativeExpressAdDelegate

- (void)aliccAdNativeExpressAdSuccessToLoad:(AliccAdNativeExpressAdManager *)nativeExpressAdManager views:(NSArray<__kindof AliccAdNativeExpressAdView *> *)views {
    [self.expressAdViews removeAllObjects];
    
    if (views.count) {
        [self.expressAdViews addObjectsFromArray:views];
        [views enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            AliccAdNativeExpressAdView *expressView = (AliccAdNativeExpressAdView *)obj;
            expressView.rootViewController = self;
            [expressView render];

        }];
    }
    [self.mainTableView reloadData];
    
}


- (void)aliccAdNativeExpressAdFailToLoad:(AliccAdNativeExpressAdManager *)nativeExpressAdManager error:(NSError *_Nullable)error {
    NSLog(@"feed流获取数据失败, error=%@", error);
}


- (void)aliccAdNativeExpressAdViewRenderSuccess:(AliccAdNativeExpressAdView *)nativeExpressAdView {
    [self.mainTableView reloadData];
}


- (void)aliccAdNativeExpressAdViewRenderFail:(AliccAdNativeExpressAdView *)nativeExpressAdView error:(NSError *_Nullable)error {
    NSLog(@"");
}


- (void)aliccAdNativeExpressAdViewDidClose:(AliccAdNativeExpressAdView *)nativeExpressAdView {
    [self.expressAdViews removeObject:nativeExpressAdView];
    [self.mainTableView reloadData];
}


- (void)aliccAdNativeExpressAdViewDidClick:(AliccAdNativeExpressAdView *)nativeExpressAdView {
    NSLog(@"广告被点击");
}


#pragma mark -
#pragma mark -------------- UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.expressAdViews.count * 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
   
    UITableViewCell *cell = nil;
    if (indexPath.row % 10 == 0 ) {
        cell = [self.mainTableView dequeueReusableCellWithIdentifier:ExpressAdCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        // 重用BUNativeExpressAdView，先把之前的广告试图取下来，再添加上当前视图
        UIView *subView = (UIView *)[cell.contentView viewWithTag:1000];
        if ([subView superview]) {
            [subView removeFromSuperview];
        }
        
        UIView *view = [self.expressAdViews objectAtIndex:indexPath.row / 10];
        view.tag = 1000;
        
        [cell.contentView addSubview:view];
    } else {
        cell = [self.mainTableView dequeueReusableCellWithIdentifier:NativeCell forIndexPath:indexPath];
        cell.backgroundColor = [UIColor cloudCodeDemo_randomColor];
    }
    
    return cell;
    
 
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 10 == 0) {
        AliccAdNativeExpressAdView *view = (AliccAdNativeExpressAdView *)[self.expressAdViews objectAtIndex:indexPath.row / 10];
        if (view.isReady) {
            return view.bounds.size.height;
        } else {
            return 0;
        }
    }
    return 88;
}


#pragma mark -
#pragma mark -------------- lazy


- (NSMutableArray<AliccAdNativeExpressAdView *> *)expressAdViews {
    if (!_expressAdViews){
        _expressAdViews = [NSMutableArray array];
    }
    return _expressAdViews;
}




@end
