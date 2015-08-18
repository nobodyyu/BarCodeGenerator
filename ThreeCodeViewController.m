//
//  ThreeCodeViewController.m
//  barcodeGenerator
//
//  Created by AKI on 2015/5/30.
//  Copyright (c) 2015年 AKI. All rights reserved.
//

#import "ThreeCodeViewController.h"
#import "NKDCode39Barcode.h"
#import "UIImage-NKDBarcode.h"
#import "NKDEAN8Barcode.h"
#import "NKDEAN13Barcode.h"
#import "NKDCode128Barcode.h"
#define kAlphaNum  @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@interface ThreeCodeViewController ()<VpadnBannerDelegate, VpadnInterstitialDelegate>

@end

@implementation ThreeCodeViewController
@synthesize code1,code2,code3,CodeType;

- (void)viewDidLoad {
    [super viewDidLoad];
    pArray = [[NSArray alloc] initWithObjects:@"Code 128",@"Code 39",@"DEAN 8",@"DEAN 13",nil];
    textCode1.text = code1;
    textCode2.text = code2;
    textCode3.text = code3;
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

-(IBAction)btnBack:(id)sender{
    
    if(![textCode1.text isEqualToString:@""]){
        NSMutableArray *mArray =[[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"code"]];
        
        if (![mArray containsObject:[NSString stringWithFormat:@"3Code,%d,%@,%@,%@",CodeType,textCode1.text,textCode2.text,textCode3.text]]) {
            [mArray addObject:[NSString stringWithFormat:@"3Code,%d,%@,%@,%@",CodeType,textCode1.text,textCode2.text,textCode3.text]];
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum]invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
    
    BOOL canChange = [string isEqualToString:filtered];
    
    if(canChange){
        code1 = textCode1.text;
        code2 = textCode2.text;
        code3 = textCode3.text;
        
        [self doCode];
    }
    
    return canChange;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}


-(void)doCode{
    
    if(CodeType==0){
        
        NKDCode128Barcode *bcode1 = [[NKDCode128Barcode alloc] initWithContent:textCode1.text];
        [imgcode1 setImage:[UIImage imageFromBarcode:bcode1]];
        NKDCode128Barcode *bcode2 = [[NKDCode128Barcode alloc] initWithContent:textCode2.text];
        [imgcode2 setImage:[UIImage imageFromBarcode:bcode2]];
        NKDCode128Barcode *bcode3 = [[NKDCode128Barcode alloc] initWithContent:textCode3.text];
        [imgcode3 setImage:[UIImage imageFromBarcode:bcode3]];
    }else if(CodeType==1){
        NKDCode39Barcode *bcode1 = [[NKDCode39Barcode alloc] initWithContent:textCode1.text];
        [imgcode1 setImage:[UIImage imageFromBarcode:bcode1]];
        NKDCode39Barcode *bcode2 = [[NKDCode39Barcode alloc] initWithContent:textCode2.text];
        [imgcode2 setImage:[UIImage imageFromBarcode:bcode2]];
        NKDCode39Barcode *bcode3 = [[NKDCode39Barcode alloc] initWithContent:textCode3.text];
        [imgcode3 setImage:[UIImage imageFromBarcode:bcode3]];
    }else if(CodeType==2){
        NKDEAN8Barcode *bcode1 = [[NKDEAN8Barcode alloc] initWithContent:textCode1.text];
        [imgcode1 setImage:[UIImage imageFromBarcode:bcode1]];
        NKDEAN8Barcode *bcode2 = [[NKDEAN8Barcode alloc] initWithContent:textCode2.text];
        [imgcode2 setImage:[UIImage imageFromBarcode:bcode2]];
        NKDEAN8Barcode *bcode3 = [[NKDEAN8Barcode alloc] initWithContent:textCode3.text];
        [imgcode3 setImage:[UIImage imageFromBarcode:bcode3]];
        
    }else if(CodeType==3){
        
        NKDEAN13Barcode *bcode1 = [[NKDEAN13Barcode alloc] initWithContent:textCode1.text];
        [imgcode1 setImage:[UIImage imageFromBarcode:bcode1]];
        NKDEAN13Barcode *bcode2 = [[NKDEAN13Barcode alloc] initWithContent:textCode2.text];
        [imgcode2 setImage:[UIImage imageFromBarcode:bcode2]];
        NKDEAN13Barcode *bcode3 = [[NKDEAN13Barcode alloc] initWithContent:textCode3.text];
        [imgcode3 setImage:[UIImage imageFromBarcode:bcode3]];
    }
    
}

-(IBAction)btnCodeType:(id)sender{
    [self.view endEditing:YES];
    mPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-180, self.view.frame.size.width, 180)];
    [mPicker setBackgroundColor:[UIColor colorWithRed:175.0f/255.0f green:222.0f/255.0f blue:250.0f/255.0f alpha:1]];
    
    mPicker.delegate = self;
    
    [self.view addSubview:mPicker];
    
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
