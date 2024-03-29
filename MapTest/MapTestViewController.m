//
//  MapTestViewController.m
//  MapTest
//
//  Created by 飯田 諒 on 2013/09/05.
//  Copyright (c) 2013年 飯田 諒. All rights reserved.
//

#import "MapTestViewController.h"
#import "DetailViewController.h"
#import "SVProgressHUD.h"
#import <GoogleMaps/GoogleMaps.h>

@interface MapTestViewController ()<GMSMapViewDelegate, UITabBarControllerDelegate>{
    
}

@end

@implementation MapTestViewController{
    GMSMapView *mapView_;
}

@synthesize locationManager;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    UIImage *omoMK = [UIImage imageNamed:@"greenpin.png"];
    omoMarker = [self resizeImage:omoMK rect:CGRectMake(0,0,60,100)];
    
    UIImage *moeMK = [UIImage imageNamed:@"red.png"];
    moeMarker = [self resizeImage:moeMK rect:CGRectMake(0,0,60,100)];
    
    UIImage *tinMK = [UIImage imageNamed:@"yellow.png"];
    tinMarker = [self resizeImage:tinMK rect:CGRectMake(0,0,60,100)];
    
    //ViewControllerにテスト的に表示させる
    
    locationManager = [[CLLocationManager alloc] init];
    
    // 位置情報サービスが利用できるかどうかをチェック
    if ([CLLocationManager locationServicesEnabled]) {
        locationManager.delegate = self;
        // 測位開始
        [locationManager startUpdatingLocation];
    } else {
        NSLog(@"Location services not available.");
    }
    
    // Do any additional setup after loading the view, typically from a nib.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:35.653623
                                                            longitude:139.692890
                                                                 zoom:17];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    mapView_.settings.myLocationButton = YES;
    self.view = mapView_;
    mapView_.delegate = self;
    
    // Creates a marker in the center of the map.
    NSString* root = URL_STRING;
    NSString* address = [root stringByAppendingString:@"spots"];
    
    NSURL* url = [NSURL URLWithString:address];
    NSURLRequest* request = [NSURLRequest
                             requestWithURL:url];
    NSURLResponse* response = nil;
    NSError* error = nil;
    data = [NSURLConnection
            sendSynchronousRequest:request
            returningResponse:&response
            error:&error];
    
    if(data) {
        NSArray *results = [self parseJson:data];
        
        for(NSDictionary *spot in results){
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake([spot[@"place_lati"] doubleValue],[spot[@"place_long"] doubleValue]);
            switch ([spot[@"category"] intValue]) {
                case CATEGORY_OMO:
                    marker.icon = omoMarker;
                    break;
                case CATEGORY_MOE:
                    marker.icon = moeMarker;
                    break;
                case CATEGORY_TIN:
                    marker.icon = tinMarker;
                    break;
                default:
                    break;
            }
            marker.title = spot[@"title"];
            marker.snippet = spot[@"desc"];
            marker.userData = spot[@"_id"];
            marker.map = mapView_;
        }
    }
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44 )];
    // ツールバーを親Viewに追加
    [self.view addSubview:toolBar];
    
    [self changeButtons:YES];
    
    if([CLLocationManager locationServicesEnabled]){
        locationManager.delegate = self;
        [locationManager startUpdatingLocation];
    }else{
        NSLog(@"Location services not avaiable");
    }
}

- (void)changeButtons:(BOOL)inFlag{
    NSArray * newButtonArray = nil;
    
    if(inFlag == YES)
    {
        // ボタン群のAパターンを作成する
        UIBarButtonItem * btn0 = [[UIBarButtonItem alloc] initWithTitle:@"機能" style:UIBarButtonItemStyleBordered target:self action:@selector(onTapChangeA:)];
        UIBarButtonItem * btn1 = [[UIBarButtonItem alloc] initWithTitle:@"おも" style:UIBarButtonItemStyleBordered target:self action:@selector( onFilterOmo:)];
        UIBarButtonItem * btn2 = [[UIBarButtonItem alloc] initWithTitle:@"萌" style:UIBarButtonItemStyleBordered target:self action:@selector( onFilterMoe:)];
        UIBarButtonItem * btn3 = [[UIBarButtonItem alloc] initWithTitle:@"珍" style:UIBarButtonItemStyleBordered target:self action:@selector( onFilterTin:)];
        UIBarButtonItem * btn4 = [[UIBarButtonItem alloc] initWithTitle:@"全" style:UIBarButtonItemStyleBordered target:self action:@selector( onNoFilter:)];
        newButtonArray = [ NSArray arrayWithObjects:btn0, btn1, btn2, btn3, btn4, nil ];
    }
    else
    {
        // ボタン群のBパターンを作成する
        UIBarButtonItem * btn0 = [[UIBarButtonItem alloc] initWithTitle:@"フィルタ" style:UIBarButtonItemStyleBordered target:self action:@selector( onTapChangeB:)];
        UIBarButtonItem * btn1 = [[UIBarButtonItem alloc] initWithTitle:@"とうろく" style:UIBarButtonItemStyleBordered target:self action:@selector( addSpotButton:)];
        UIBarButtonItem * btn2 = [[UIBarButtonItem alloc] initWithTitle:@"にんき" style:UIBarButtonItemStyleBordered target:self action:@selector( showSpotsButton:)];
        
        newButtonArray = [ NSArray arrayWithObjects:btn0, btn1, btn2, nil ];
    }
    // アニメーション付きでボタンを切り替える
    [toolBar setItems:newButtonArray animated:YES ];
    return;
}

- (void)onTapChangeA:(id)inSender
{
    [self changeButtons:NO];
    return;
}

- (void)onTapChangeB:(id)inSender
{
    [self changeButtons:YES];
    return;
}

-(void)onNoFilter:(id)inSender{
    [mapView_ clear];
    [self makeMarker:CATEGORY_ZEN];
}

-(void)onFilterOmo:(id)inSender{
    [mapView_ clear];
    [self makeMarker:CATEGORY_OMO];
}

-(void)onFilterMoe:(id)inSender{
    [mapView_ clear];
    [self makeMarker:CATEGORY_MOE];
}

-(void)onFilterTin:(id)inSender{
    [mapView_ clear];
    [self makeMarker:CATEGORY_TIN];
}

-(void)makeMarker:(int)category{
    NSArray *results = [self parseJson:data];
    
    switch (category) {
        case CATEGORY_OMO:
            for(NSDictionary *spot in results){
                if([spot[@"category"] intValue] == CATEGORY_OMO) {
                    GMSMarker *marker = [[GMSMarker alloc] init];
                    marker.position = CLLocationCoordinate2DMake([spot[@"place_lati"] doubleValue], [spot[@"place_long"] doubleValue]);
                    marker.icon = omoMarker;
                    marker.title = spot[@"title"];
                    marker.snippet = spot[@"desc"];
                    marker.userData = spot[@"_id"];
                    marker.map = mapView_;
                }
            }
            break;
            
        case CATEGORY_MOE:
            for(NSDictionary *spot in results){
                if([spot[@"category"] intValue] == CATEGORY_MOE) {
                    GMSMarker *marker = [[GMSMarker alloc] init];
                    marker.position = CLLocationCoordinate2DMake([spot[@"place_lati"] doubleValue], [spot[@"place_long"] doubleValue]);
                    marker.icon = moeMarker;
                    marker.title = spot[@"title"];
                    marker.snippet = spot[@"desc"];
                    marker.userData = spot[@"_id"];
                    marker.map = mapView_;
                }
            }
            break;
            
        case CATEGORY_TIN:
            for(NSDictionary *spot in results){
                if([spot[@"category"] intValue] == CATEGORY_TIN) {
                    GMSMarker *marker = [[GMSMarker alloc] init];
                    marker.position = CLLocationCoordinate2DMake([spot[@"place_lati"] doubleValue], [spot[@"place_long"] doubleValue]);
                    marker.icon = tinMarker;
                    marker.title = spot[@"title"];
                    marker.snippet = spot[@"desc"];
                    marker.userData = spot[@"_id"];
                    marker.map = mapView_;
                }
            }
            break;
        default:
            for(NSDictionary *spot in results){
                GMSMarker *marker = [[GMSMarker alloc] init];
                marker.position = CLLocationCoordinate2DMake([spot[@"place_lati"] doubleValue], [spot[@"place_long"] doubleValue]);
                switch ([spot[@"category"] intValue]) {
                    case CATEGORY_OMO:
                        marker.icon = omoMarker;
                        break;
                    case CATEGORY_MOE:
                        marker.icon = moeMarker;
                        break;
                    case CATEGORY_TIN:
                        marker.icon = tinMarker;
                        break;
                    default:
                        break;
                }
                marker.title = spot[@"title"];
                marker.snippet = spot[@"desc"];
                marker.userData = spot[@"_id"];
                marker.map = mapView_;
            }
            break;
    }
}


//スポット追加
- (void)addSpotButton:(UIButton *)addsupotto
{
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"callFromSampleMap"];
    
    [self presentViewController:viewController animated:YES completion:nil];
}

//人気スポット
- (void)showSpotsButton:(UIButton *)populersupotto
{
    [SVProgressHUD showWithStatus:@"取得中"maskType:SVProgressHUDMaskTypeBlack];
    UIViewController *viewControlle = [self.storyboard instantiateViewControllerWithIdentifier:@"spotRanking"];
    
    [self presentViewController:viewControlle animated:YES completion:nil];
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//位置情報更新時
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    //[mapView_ animateToLocation:[newLocation coordinate]];
    
    NSLog(@"didUpdateToLocation latitude=%f, longitude=%f",
          [newLocation coordinate].latitude,
          [newLocation coordinate].longitude);
}

-(void)locationManager:(CLLocationManager *)manager
      didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError");
}

- (NSArray *)parseJson:(NSData *)parseData {
    NSError *error = nil;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:parseData
                                                     options:NSJSONReadingAllowFragments
                                                       error:&error];
    return array;
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker* )marker{
    [SVProgressHUD showWithStatus:@"通信中" maskType:SVProgressHUDMaskTypeBlack];
    argument = marker.userData;
    
    DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"spotDetailFromMap"];
    
    detailViewController.argument = [[NSString alloc] initWithString:argument];//argument;
    
    [self presentViewController:detailViewController animated:YES completion:^(void){
        [SVProgressHUD dismiss];
    }];
}

//画像を縮小するクラス
- (UIImage*)resizeImage:(UIImage *)img rect:(CGRect)rect{
    
    UIGraphicsBeginImageContext(rect.size);
    
    [img drawInRect:rect];
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

@end
