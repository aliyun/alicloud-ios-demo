//
//  AVQRViewController.h
//  YWFeedbackKit
//
//  Created by Fujun on 15/7/2.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^ AVQRViewReadFinishedBlock)(NSString *text);

@interface AVQRViewController : UIViewController
<AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) AVCaptureDevice            * avDevice;
@property (strong, nonatomic) AVCaptureDeviceInput       * avInput;
@property (strong, nonatomic) AVCaptureMetadataOutput    * avOutput;
@property (strong, nonatomic) AVCaptureSession           * avSession;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer * avPreview;

@property (copy, nonatomic) AVQRViewReadFinishedBlock readFinishedBlock;
@end
