//
//  SplashViewController.h
//  barcodeGenerator
//
//  Created by AKI on 2015/5/30.
//  Copyright (c) 2015年 AKI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

#import "VpadnBanner.h"
#import "VpadnInterstitial.h"

@interface SplashViewController : UIViewController<ZBarReaderDelegate>
{
    
    ZBarReaderViewController *reader;
    
    IBOutlet UIButton *btnHistory;
    IBOutlet UIButton *btnScanHistory;
    

    VpadnBanner*         vponAd; // 宣告使用VponBanner廣告
    VpadnInterstitial*   vponInterstitial; // 宣告使用Vpon插屏廣告
   
    
    
}



@end
