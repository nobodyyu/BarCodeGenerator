//
//  BarcodeViewController.h
//  barcodeGenerator
//
//  Created by AKI on 2015/5/30.
//  Copyright (c) 2015年 AKI. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VpadnBanner.h"
#import "VpadnInterstitial.h"

@interface BarcodeViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>
{
    IBOutlet UIImageView *imgcode;
    IBOutlet UITextField *textCode;
    
    
    IBOutlet UIButton *btnType;
    

    
    NSArray *pArray;
    
    UIPickerView *mPicker;
    
    
    VpadnBanner*         vponAd; // 宣告使用VponBanner廣告
    VpadnInterstitial*   vponInterstitial; // 宣告使用Vpon插屏廣告

}

@property (nonatomic,retain) NSString *code;
@property (nonatomic,assign) int CodeType;


@end
