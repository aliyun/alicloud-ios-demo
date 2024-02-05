//
//  TBDevice.h
//  
//
//  Created by Alvin on 4/21/13.
//
//  设备信息存储的元类

#ifndef EMASRestDeviceInfo_h
#define EMASRestDeviceInfo_h

#import <Foundation/Foundation.h>

@interface EMASRestDeviceInfo : NSObject

@property(readwrite,strong) NSString * mAppVersion;
@property(readwrite,strong) NSString * mOsName;
@property(readwrite,strong) NSString * mUtdid;
@property(readwrite,strong) NSString * mImei;
@property(readwrite,strong) NSString * mImsi;
@property(readwrite,strong) NSString * mBrand;
@property(readwrite,strong) NSString * mCpu;
@property(readwrite,strong) NSString * mDeviceId;
@property(readwrite,strong) NSString * mDeviceModel;
@property(readwrite,strong) NSString * mResolution;
@property(readwrite,strong) NSString * mCarrier;
@property(readwrite,strong) NSString * mAccess;
@property(readwrite,strong) NSString * mAccessSubType;
@property(readwrite,strong) NSString * mCountry;
@property(readwrite,strong) NSString * mLanguage;
@property(readwrite,strong) NSString * mOsVersion;
//@property(readwrite,strong) NSString * mDebugId;

@end


#endif
