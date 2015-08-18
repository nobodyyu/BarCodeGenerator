//
//  BarcodeViewController.m
//  barcodeGenerator
//
//  Created by AKI on 2015/5/30.
//  Copyright (c) 2015年 AKI. All rights reserved.
//

#import "BarcodeViewController.h"
#import "NKDCode39Barcode.h"
#import "UIImage-NKDBarcode.h"
#import "NKDEAN8Barcode.h"
#import "NKDEAN13Barcode.h"
#import "NKDCode128Barcode.h"

#define kAlphaNum  @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@interface BarcodeViewController ()<UITextFieldDelegate,VpadnBannerDelegate, VpadnInterstitialDelegate>

@end

@implementation BarcodeViewController
@synthesize code,CodeType;
- (void)viewDidLoad {
    [super viewDidLoad];
    
     textCode.text = code;
    pArray = [[NSArray alloc] initWithObjects:@"Code 128",@"Code 39",@"DEAN 8",@"DEAN 13",nil];

    [btnType setTitle:[NSString stringWithFormat:@"條碼格式 %@",[pArray objectAtIndex:CodeType]] forState:UIControlStateNormal];
    [self doCode];
    
    
    BOOL bStatusBarHide = [UIApplication sharedApplication].statusBarHidden;
    float screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if(!bStatusBarHide)
        screenHeight -= 20;
    // 設定廣告位置
    CGPoint origin = CGPointMake(0.0,screenHeight - CGSizeFromVpadnAdSize(VpadnAdSizeSmartBannerPortrait).height);
    vponAd = [[VpadnBanner alloc] initWithAdSize:VpadnAdSizeSmartBannerPortrait origin:origin];  // 初始化Banner物件
    vponAd.strBannerId = @"8a8081824d66da9a014da60e024f62c7";   // 填入您的BannerId
    vponAd.delegate = self;       // 設定delegate接收protocol回傳訊息
    vponAd.platform = @"TW";       // 台灣地區請填TW 大陸則填CN
    [vponAd setAdAutoRefresh:YES]; //如果為mediation則set NO
    [vponAd setRootViewController:self]; //請將window的rootViewController設定在此 以便廣告順利執行
    [self.view addSubview:[vponAd getVpadnAdView]]; // 將VponBanner的View加入此ViewController中
    [vponAd startGetAd:[self getTestIdentifiers]]; // 開始抓取Banner廣告

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)btnCodeType:(id)sender{
    [self.view endEditing:YES];
    mPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-180, self.view.frame.size.width, 180)];
    [mPicker setBackgroundColor:[UIColor colorWithRed:175.0f/255.0f green:222.0f/255.0f blue:250.0f/255.0f alpha:1]];
    
    mPicker.delegate = self;
    
    [self.view addSubview:mPicker];
    
}


-(IBAction)btnBack:(id)sender{
    
    if(![textCode.text isEqualToString:@""]){
        NSMutableArray *mArray =[[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"code"]];
        if (![mArray containsObject:[NSString stringWithFormat:@"Code,%d,%@",CodeType,textCode.text]]) {
            
            [mArray addObject:[NSString stringWithFormat:@"Code,%d,%@",CodeType,textCode.text]];
            [[NSUserDefaults standardUserDefaults] setObject:mArray forKey:@"code"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return pArray.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [pArray objectAtIndex:row];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    CodeType = (int)row;
    [btnType setTitle:[NSString stringWithFormat:@"條碼格式 %@",[pArray objectAtIndex:row]] forState:UIControlStateNormal];
    [self doCode];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    
    [mPicker removeFromSuperview];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum]invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
    
    BOOL canChange = [string isEqualToString:filtered];
    
    if(canChange){
        code = textCode.text;
        
        [self doCode];
    }
    
    return canChange;
    
}

-(void)doCode{
    
    if(CodeType==0){
        
        NKDCode128Barcode *bcode = [[NKDCode128Barcode alloc] initWithContent:textCode.text];
        [imgcode setImage:[UIImage imageFromBarcode:bcode]];
    }else if(CodeType==1){
        NKDCode39Barcode *bcode = [[NKDCode39Barcode alloc] initWithContent:textCode.text];
        [imgcode setImage:[UIImage imageFromBarcode:bcode]];
    }else if(CodeType==2){
        NKDEAN8Barcode *bcode = [[NKDEAN8Barcode alloc] initWithContent:textCode.text];
        [imgcode setImage:[UIImage imageFromBarcode:bcode]];
    }else if(CodeType==3){
        NKDEAN13Barcode *bcode = [[NKDEAN13Barcode alloc] initWithContent:textCode.text];
        [imgcode setImage:[UIImage imageFromBarcode:bcode]];
    }
    
}

#pragma mark -------------------------------------------
#pragma mark Vpon


// 請新增此function到您的程式內 如果為測試用 則在下方填入UUID，即可看到測試廣告。
-(NSArray*)getTestIdentifiers
{
    return [NSArray arrayWithObjects:@"", nil];
}

#pragma mark VponAdDelegate method 接一般Banner廣告就需要新增
- (void)onVponAdReceived:(UIView *)bannerView{
    NSLog(@"廣告抓取成功");
}

- (void)onVponAdFailed:(UIView *)bannerView didFailToReceiveAdWithError:(NSError *)error{
    NSLog(@"廣告抓取失敗");
}

- (void)onVponPresent:(UIView *)bannerView{
    NSLog(@"開啟vpon廣告頁面 %@",bannerView);
}

- (void)onVponDismiss:(UIView *)bannerView{
    NSLog(@"關閉vpon廣告頁面 %@",bannerView);
}

- (void)onVponLeaveApplication:(UIView *)bannerView{
    NSLog(@"離開publisher application");
}

#pragma mark VponInterstitial Delegate 有接Interstitial的廣告才需要新增
- (void)onVponInterstitialAdReceived:(UIView *)bannerView{
    NSLog(@"插屏廣告抓取成功");
    // 顯示插屏廣告
    [vponInterstitial show];
}

- (void)onVponInterstitialAdFailed:(UIView *)bannerView{
    NSLog(@"插屏廣告抓取失敗");
}

- (void)onVponInterstitialAdDismiss:(UIView *)bannerView{
    NSLog(@"關閉插屏廣告頁面 %@",bannerView);
}

#pragma mark 通知關閉vpon開屏廣告
- (void)onVponSplashAdDismiss{
    NSLog(@"關閉vpon開屏廣告頁面");
}

#pragma mark -------------------------------------------


@end
