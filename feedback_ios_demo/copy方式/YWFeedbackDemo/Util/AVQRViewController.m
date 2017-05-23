//
//  AVQRViewController.m
//  YWFeedbackKit
//
//  Created by Fujun on 15/7/2.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import "AVQRViewController.h"
#import "UIAlertView+XY.h"

static CGFloat const kFocusViewLeftInterval = 60.0f;
static CGFloat const kTitleLabelHeight = 20.0f;


@interface AVQRViewController ()
@property (strong, nonatomic) UIImageView *focusView;

@end

@implementation AVQRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"关闭"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(dismissView)];
    
    closeButton.tintColor = [UIColor blackColor];
    
    self.navigationItem.leftBarButtonItem = closeButton;
    
    [self setupCamera];
    [self initialWithFocusView];
}

- (void)dismissView
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)initialWithFocusView
{
    CGFloat width = self.view.frame.size.width-kFocusViewLeftInterval*2;
    
    UIGraphicsBeginImageContext(CGSizeMake(self.view.frame.size.width,
                                           self.view.frame.size.height));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, 0,0,0,0.4);
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect drawRect = CGRectMake(0, 0, screenSize.width,screenSize.height);
    
    CGContextFillRect(ctx, drawRect);
    drawRect = CGRectMake(kFocusViewLeftInterval,
                          (self.view.frame.size.height-width)/2-20, width, width);
    
    CGContextClearRect(ctx, drawRect);
    
    UIImage *qrMaskImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.focusView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   self.view.frame.size.width,
                                                                   self.view.frame.size.height)];
    self.focusView.image = qrMaskImage;
    [self.view addSubview:self.focusView];
    
    UILabel *noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                     drawRect.origin.y
                                                                     + drawRect.size.height
                                                                     + kTitleLabelHeight,
                                                                     self.view.frame.size.width, kTitleLabelHeight)];
    noticeLabel.backgroundColor = [UIColor clearColor];
    noticeLabel.textColor = [UIColor whiteColor];
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    noticeLabel.font = [UIFont systemFontOfSize:15.0f];
    noticeLabel.text = @"将二维码放入框中，即可自动扫描";
    [self.focusView addSubview:noticeLabel];
    
    UIView *borderView = [[UIView alloc] initWithFrame:drawRect];
    borderView.backgroundColor = [UIColor clearColor];
    borderView.layer.borderWidth = 1.0f;
    borderView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.focusView addSubview:borderView];
}

- (void)setupCamera
{
    self.avDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    self.avInput = [AVCaptureDeviceInput deviceInputWithDevice:self.avDevice error:nil];
    
    self.avOutput = [[AVCaptureMetadataOutput alloc]init];
    [self.avOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    self.avSession = [[AVCaptureSession alloc]init];
    if([self.avSession canSetSessionPreset:AVCaptureSessionPresetHigh])
    {
        [self.avSession setSessionPreset:AVCaptureSessionPresetHigh];
    }
    else
    {
        [self.avSession setSessionPreset:AVCaptureSessionPresetMedium];
    }
    
    //判断有无相机权限
    if ([self.avSession canAddInput:self.avInput])
    {
        [self.avSession addInput:self.avInput];
    }
    
    if ([self.avSession canAddOutput:self.avOutput])
    {
        [self.avSession addOutput:self.avOutput];
    }
    
    if ([self.avOutput.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode])
    {
        self.avOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    }
    else
    {
        __weak typeof(self) weakSelf = self;
        [self showErrorViewWithText:@"请在设置中打开相机功能" clickBlock:^{
            [weakSelf dismissView];
        }];
        return;
    }
    
    self.avPreview = [AVCaptureVideoPreviewLayer layerWithSession:self.avSession];
    self.avPreview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.avPreview.frame = CGRectMake(0,
                                      0,
                                      self.view.frame.size.width,
                                      self.view.frame.size.height);
    [self.view.layer insertSublayer:self.avPreview atIndex:0];
    
    [self.avSession startRunning];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [self.avSession stopRunning];
    
    NSLog(@"扫描结果 = %@", stringValue);

    if ([stringValue canBeConvertedToEncoding:NSShiftJISStringEncoding]) {
        stringValue = [NSString stringWithCString:[stringValue cStringUsingEncoding:NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
    }
    
    if (self.readFinishedBlock) {
        self.readFinishedBlock(stringValue);
    } 
}

- (void)showErrorViewWithText:(NSString *)text clickBlock:(void (^)())clickBlock
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:text delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
    
    [alertView handlerClickedButton:^(UIAlertView *alertView, NSInteger btnIndex) {
        if (clickBlock) {
            clickBlock();
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
