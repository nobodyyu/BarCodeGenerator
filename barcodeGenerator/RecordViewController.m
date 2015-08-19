//
//  RecordViewController.m
//  barcodeGenerator
//
//  Created by AKI on 2015/5/31.
//  Copyright (c) 2015年 AKI. All rights reserved.
//

#import "RecordViewController.h"
#import "QRCodeViewController.h"
#import "BarcodeViewController.h"
#import "ThreeCodeViewController.h"
@interface RecordViewController ()<VpadnBannerDelegate, VpadnInterstitialDelegate>

@end

@implementation RecordViewController
@synthesize Cata,NewCount;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if(Cata ==0){
    
        mArray = [[NSArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"code"]];
        
        lblTitle.text = @"歷史紀錄";
    }else{
        
        mArray=[[NSArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"scan"]];

        lblTitle.text = @"掃瞄紀錄";
    }
    
    
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
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark --------------------------------------------------------
#pragma mark UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mArray.count ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *cellIDT = [NSString stringWithFormat:@"TableViewCell-%ld",(long)indexPath.row];
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIDT];
    
    if (cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIDT];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        
        
    }
    
    
    if(Cata==0){
        if ([[[[mArray objectAtIndex:indexPath.row] componentsSeparatedByString:@","] objectAtIndex:0] isEqualToString:@"QR"]) {
             cell.textLabel.text = [[[mArray objectAtIndex:indexPath.row] componentsSeparatedByString:@","] objectAtIndex:1];
            
            cell.detailTextLabel.text = @"QRCode";
        }else if ([[[[mArray objectAtIndex:indexPath.row] componentsSeparatedByString:@","] objectAtIndex:0] isEqualToString:@"Code"]) {
            cell.textLabel.text = [[[mArray objectAtIndex:indexPath.row] componentsSeparatedByString:@","] objectAtIndex:2];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"一維條碼 [%@]",[self codetype:[[[[mArray objectAtIndex:indexPath.row] componentsSeparatedByString:@","] objectAtIndex:1]intValue]]];
        }else if ([[[[mArray objectAtIndex:indexPath.row] componentsSeparatedByString:@","] objectAtIndex:0] isEqualToString:@"3Code"]) {
            cell.textLabel.text =[[[mArray objectAtIndex:indexPath.row] componentsSeparatedByString:@","] objectAtIndex:2];
         cell.detailTextLabel.text = [NSString stringWithFormat:@"超商三段條碼:[%@]",[self codetype:[[[[mArray objectAtIndex:indexPath.row] componentsSeparatedByString:@","] objectAtIndex:1]intValue]]];
        }
    }else{
        cell.textLabel.text =[mArray objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"掃瞄條碼"];
    }
    
   
    
    return  cell;
}

-(NSString *)codetype:(int)type{
    if(type==0){
        return @"Code 128";
    }else if(type==1){
        return @"Code 39";
    }else if(type==2){
        return @"DEAN 8";
    }else if(type==3){
        return @"DEAN 13";
    }
    
    return @"";
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(Cata==0){
        if ([[[[mArray objectAtIndex:indexPath.row] componentsSeparatedByString:@","] objectAtIndex:0] isEqualToString:@"QR"]) {
        
            QRCodeViewController *QRCODE = [[QRCodeViewController alloc] initWithNibName:@"QRCodeViewController" bundle:nil];
            
            QRCODE.QRCode = [[[mArray objectAtIndex:indexPath.row] componentsSeparatedByString:@","] objectAtIndex:1];

            [self.navigationController pushViewController:QRCODE animated:YES];
            
        }else if ([[[[mArray objectAtIndex:indexPath.row] componentsSeparatedByString:@","] objectAtIndex:0] isEqualToString:@"Code"]) {
           
            BarcodeViewController *barcode = [[BarcodeViewController alloc] initWithNibName:@"BarcodeViewController" bundle:nil];
            
            barcode.code = [[[mArray objectAtIndex:indexPath.row] componentsSeparatedByString:@","] objectAtIndex:2];
           
            barcode.CodeType = [[[[mArray objectAtIndex:indexPath.row] componentsSeparatedByString:@","] objectAtIndex:1] intValue];
            
            [self.navigationController pushViewController:barcode animated:YES];
            
        }else if ([[[[mArray objectAtIndex:indexPath.row] componentsSeparatedByString:@","] objectAtIndex:0] isEqualToString:@"3Code"]) {
            
            ThreeCodeViewController *three = [[ThreeCodeViewController alloc] initWithNibName:@"ThreeCodeViewController" bundle:nil];
            three.CodeType =[[[[mArray objectAtIndex:indexPath.row] componentsSeparatedByString:@","] objectAtIndex:1] intValue];
            three.code1 =[[[mArray objectAtIndex:indexPath.row] componentsSeparatedByString:@","] objectAtIndex:2];
             three.code2 =[[[mArray objectAtIndex:indexPath.row] componentsSeparatedByString:@","] objectAtIndex:3];
             three.code3 =[[[mArray objectAtIndex:indexPath.row] componentsSeparatedByString:@","] objectAtIndex:4];
            
            [self.navigationController pushViewController:three animated:YES];
        }
    }else{
        if([[mArray objectAtIndex:indexPath.row] rangeOfString:@"http://"].location != NSNotFound){
            act = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"瀏覽器",@"QRCode",@"一維條碼", nil];
            isHttp = YES;
        }else if([[mArray objectAtIndex:indexPath.row] rangeOfString:@"https://"].location != NSNotFound){
            act = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"瀏覽器",@"QRCode",@"一維條碼", nil];
            isHttp = YES;
        }else{
            act = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"QRCode",@"一維條碼", nil];
            isHttp = NO;
        }
        act.delegate = self;
        act.tag = (int)indexPath.row;
        [act showInView:self.view];
        
        
    }
    
    
}

#pragma mark --------------------------------------------------------

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(isHttp){
        if (buttonIndex==0) {
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[mArray objectAtIndex:actionSheet.tag]]]){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[mArray objectAtIndex:actionSheet.tag]]];
            }
        }else if (buttonIndex==1){
            QRCodeViewController *qrcode = [[QRCodeViewController alloc] initWithNibName:@"QRCodeViewController" bundle:nil];
            qrcode.QRCode =[mArray objectAtIndex:actionSheet.tag];
            [self.navigationController pushViewController:qrcode animated:YES];
            
        }else if (buttonIndex==2){
            BarcodeViewController *barcode = [[BarcodeViewController alloc] initWithNibName:@"BarcodeViewController" bundle:nil];
            barcode.code =[mArray objectAtIndex:actionSheet.tag];
            barcode.CodeType = 0;
            [self.navigationController pushViewController:barcode animated:YES];
            
        }
    }else {
        if (buttonIndex==0){
            QRCodeViewController *qrcode = [[QRCodeViewController alloc] initWithNibName:@"QRCodeViewController" bundle:nil];
            qrcode.QRCode =[mArray objectAtIndex:actionSheet.tag];
            [self.navigationController pushViewController:qrcode animated:YES];
            
        }else if (buttonIndex==1){
            BarcodeViewController *barcode = [[BarcodeViewController alloc] initWithNibName:@"BarcodeViewController" bundle:nil];
            barcode.code =[mArray objectAtIndex:actionSheet.tag];
            barcode.CodeType = 0;
            [self.navigationController pushViewController:barcode animated:YES];
            
        }
    
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
