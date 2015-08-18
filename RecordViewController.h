//
//  RecordViewController.h
//  barcodeGenerator
//
//  Created by AKI on 2015/5/31.
//  Copyright (c) 2015年 AKI. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VpadnBanner.h"
#import "VpadnInterstitial.h"

@interface RecordViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>{
    IBOutlet UITableView *mTable;
    NSArray *mArray;
   IBOutlet UILabel *lblTitle;
    UIActionSheet *act;
    
    BOOL isHttp;
    
    
    VpadnBanner*         vponAd; // 宣告使用VponBanner廣告
    VpadnInterstitial*   vponInterstitial; // 宣告使用Vpon插屏廣告
}

@property (nonatomic,assign) int Cata;
@property (nonatomic,assign) int NewCount;
@end
