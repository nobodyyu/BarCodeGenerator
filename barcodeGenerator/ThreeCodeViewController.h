//
//  ThreeCodeViewController.h
//  barcodeGenerator
//
//  Created by AKI on 2015/5/30.
//  Copyright (c) 2015年 AKI. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VpadnBanner.h"
#import "VpadnInterstitial.h"

@interface ThreeCodeViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>{
    IBOutlet UIImageView *imgcode1;
    IBOutlet UITextField *textCode1;
    IBOutlet UIImageView *imgcode2;
    IBOutlet UITextField *textCode2;
    IBOutlet UIImageView *imgcode3;
    IBOutlet UITextField *textCode3;
    IBOutlet UIButton *btnType;
    
    
    NSArray *pArray;
    
    UIPickerView *mPicker;

    
    VpadnBanner*         vponAd; // 宣告使用VponBanner廣告
    VpadnInterstitial*   vponInterstitial; // 宣告使用Vpon插屏廣告
    
}

@property (nonatomic,retain) NSString *code1,*code2,*code3;
@property (nonatomic,assign) int CodeType;
@end
