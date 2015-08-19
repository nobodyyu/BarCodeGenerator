//
//  SplashViewController.m
//  barcodeGenerator
//
//  Created by AKI on 2015/5/30.
//  Copyright (c) 2015年 AKI. All rights reserved.
//

#import "SplashViewController.h"
#import "QRCodeViewController.h"
#import "BarcodeViewController.h"
#import "ThreeCodeViewController.h"
#import "RecordViewController.h"

@interface SplashViewController ()<VpadnBannerDelegate, VpadnInterstitialDelegate>

@end

@implementation SplashViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
 
    
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

-(void)viewWillAppear:(BOOL)animated{
    [btnHistory setTitle:[NSString stringWithFormat:@"歷史紀錄%@",@""] forState:UIControlStateNormal];
    
    [btnScanHistory setTitle:[NSString stringWithFormat:@"掃瞄紀錄%@",@""] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)btnQRCode:(id)sender{
    QRCodeViewController *qr = [[QRCodeViewController alloc] initWithNibName:@"QRCodeViewController" bundle:nil];
    [self.navigationController pushViewController:qr animated:YES];
}


-(IBAction)btnBarcode:(id)sender{
    BarcodeViewController *barcode = [[BarcodeViewController alloc] initWithNibName:@"BarcodeViewController" bundle:nil];
    [self.navigationController pushViewController:barcode animated:YES];
}

-(IBAction)btnThree:(id)sender{
    ThreeCodeViewController *three = [[ThreeCodeViewController alloc] initWithNibName:@"ThreeCodeViewController" bundle:nil];
    [self.navigationController pushViewController:three animated:YES];
}

-(IBAction)btnScan:(id)sender{
    
    reader = [ZBarReaderViewController new];

    reader.readerView.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
    
    @try {
        reader.readerView.torchMode = 0;
        //close flash light
    }
    @catch (NSException *exception) {
        
    }
    
    
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame: CGRectMake(5, 26, 32, 32)];
    [backBtn setTitle:@"<" forState:UIControlStateNormal];
    [backBtn addTarget:self
                action:@selector(BackFromReaderbtn:)
      forControlEvents:UIControlEventTouchUpInside];
    
    
    [reader.view addSubview:backBtn];
    
    reader.readerDelegate = self;
    
    
    reader.tracksSymbols = NO;
    [reader setShowsZBarControls:NO];
    
    ZBarImageScanner *scanner = reader.scanner;
    
    
    [scanner setSymbology: 0
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    [scanner setSymbology: ZBAR_CODE128
                   config: ZBAR_CFG_ENABLE
                       to:1];
    
    [scanner setSymbology: ZBAR_CODE39
                   config: ZBAR_CFG_ENABLE
                       to:1];
    
    [scanner setSymbology: ZBAR_QRCODE
                   config: ZBAR_CFG_ENABLE
                       to:1];
    
    
    
    [self presentViewController:reader animated:YES completion:nil];



}

-(IBAction)BackFromReaderbtn:(id)sender{
    [reader dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerController: (UIImagePickerController*) MyReader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    
    NSMutableArray *scanArr =[[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"scan"]];
    
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    

    int cunt = 0;
    for (symbol in results)
    {
        [scanArr insertObject:symbol.data atIndex:0];
        cunt ++;
        
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:scanArr forKey:@"scan"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [reader dismissViewControllerAnimated:YES completion:nil];
    
    RecordViewController *record = [[RecordViewController alloc] initWithNibName:@"RecordViewController" bundle:nil];
    
    record.Cata = 1;
    record.NewCount = cunt;
    [self.navigationController pushViewController:record animated:YES];

    
    
}

-(IBAction)btnHistory:(id)sender{
    RecordViewController *record = [[RecordViewController alloc] initWithNibName:@"RecordViewController" bundle:nil];
    
    record.Cata = 0;
    
    [self.navigationController pushViewController:record animated:YES];
}

-(IBAction)btnScanHistory:(id)sender{
    RecordViewController *record = [[RecordViewController alloc] initWithNibName:@"RecordViewController" bundle:nil];
    
    record.Cata = 1;
    
    [self.navigationController pushViewController:record animated:YES];
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
