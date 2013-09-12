//
//  MapTestViewController.m
//  MapTest
//
//  Created by 飯田 諒 on 2013/09/05.
//  Copyright (c) 2013年 飯田 諒. All rights reserved.
//

#import "MapTestViewController.h"
#import "DetailViewController.h"
#import <GoogleMaps/GoogleMaps.h>

#define URL_STRING @"http://172.30.254.141:8000/"
//#define URL_STRING @"http://192.168.11.2:8000/"
//#define URL_STRING @"http://ec2-54-250-229-175.ap-northeast-1.compute.amazonaws.com:8000/"

@interface MapTestViewController ()<GMSMapViewDelegate, UITabBarControllerDelegate>{
    
}

@end

@implementation MapTestViewController{
    GMSMapView *mapView_;
    NSMutableDictionary *markerDictionary;
}

@synthesize locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:35.65
                                                            longitude:139.69
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
    NSData* data = [NSURLConnection
                    sendSynchronousRequest:request
                    returningResponse:&response
                    error:&error];
    
    if(data) {
        NSArray *results = [self parseJson:data];
        markerDictionary = [NSMutableDictionary dictionaryWithCapacity:[results count]];

        for(NSDictionary *spot in results){
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake([spot[@"place_lati"] doubleValue], [spot[@"place_long"] doubleValue]);
            marker.title = spot[@"title"];
            marker.snippet = spot[@"desc"];
            marker.userData = spot[@"_id"];
            marker.map = mapView_;
            [markerDictionary setObject:spot[@"title"] forKey:marker];
        }
    }
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44 )];
    // ツールバーを親Viewに追加
    [self.view addSubview:toolBar];
    
    UIBarButtonItem * btn0 = [[UIBarButtonItem alloc] initWithTitle:@"切替" style:UIBarButtonItemStyleBordered target:self action:@selector( onTapChangeA:)];
    UIBarButtonItem * btn1 = [[UIBarButtonItem alloc] initWithTitle:@"もえ" style:UIBarButtonItemStyleBordered target:self action:@selector( onTapTest:)];
    UIBarButtonItem * btn2 = [[UIBarButtonItem alloc] initWithTitle:@"おも" style:UIBarButtonItemStyleBordered target:self action:@selector( onTapTest:)];
    UIBarButtonItem * btn3 = [[UIBarButtonItem alloc] initWithTitle:@"ちん" style:UIBarButtonItemStyleBordered target:self action:@selector( onTapTest:)];
    UIBarButtonItem * btn4 = [[UIBarButtonItem alloc] initWithTitle:@"ぜん" style:UIBarButtonItemStyleBordered target:self action:@selector( onTapTest:)];
    // ボタン配列をツールバーに設定する
    toolBar.items = [NSArray arrayWithObjects:btn0, btn1, btn2, btn3, btn4, nil];
    // 略
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
            UIBarButtonItem * btn0 = [[UIBarButtonItem alloc] initWithTitle:@"切替" style:UIBarButtonItemStyleBordered target:self action:@selector(onTapChangeA:)];
            UIBarButtonItem * btn1 = [[UIBarButtonItem alloc] initWithTitle:@"もえ" style:UIBarButtonItemStyleBordered target:self action:@selector( onTapTest:)];
            UIBarButtonItem * btn2 = [[UIBarButtonItem alloc] initWithTitle:@"おも" style:UIBarButtonItemStyleBordered target:self action:@selector( onTapTest:)];
            UIBarButtonItem * btn3 = [[UIBarButtonItem alloc] initWithTitle:@"ちん" style:UIBarButtonItemStyleBordered target:self action:@selector( onTapTest:)];
            UIBarButtonItem * btn4 = [[UIBarButtonItem alloc] initWithTitle:@"ぜん" style:UIBarButtonItemStyleBordered target:self action:@selector( onTapTest:)];
            newButtonArray = [ NSArray arrayWithObjects:btn0, btn1, btn2, btn3, btn4, nil ];
        }
        else
        {
            // ボタン群のBパターンを作成する
            UIBarButtonItem * btn0 = [[UIBarButtonItem alloc] initWithTitle:@"切替" style:UIBarButtonItemStyleBordered target:self action:@selector( onTapChangeB:)];
            UIBarButtonItem * btn1 = [[UIBarButtonItem alloc] initWithTitle:@"かめら" style:UIBarButtonItemStyleBordered target:self action:@selector( addSpotButton:)];
            UIBarButtonItem * btn2 = [[UIBarButtonItem alloc] initWithTitle:@"にんき" style:UIBarButtonItemStyleBordered target:self action:@selector( showSpotsButton:)];
            
            newButtonArray = [ NSArray arrayWithObjects:btn0, btn1, btn2, nil ];
        }
        // アニメーション付きでボタンを切り替える
        [toolBar setItems:newButtonArray animated:YES ];
        return;
}
    

- (void)onTapTest:(id)inSender
{
    // ボタンを押された時の処理をここに追加
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



//スポット追加
- (void)addSpotButton:(UIButton *)addsupotto
{
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"callFromSampleMap"];
    
    [self presentViewController:viewController animated:YES completion:nil];
}

//人気スポット
- (void)showSpotsButton:(UIButton *)populersupotto
{
    UIViewController *viewControlle = [self.storyboard instantiateViewControllerWithIdentifier:@"spotRanking"];
    
    [self presentViewController:viewControlle animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//位置情報更新時
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    [mapView_ animateToLocation:[newLocation coordinate]];
    
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
    argument = marker.userData;
    NSLog(@"Jump to %@", argument);
        
    DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"spotDetailFromMap"];
    
    detailViewController.argument = [[NSString alloc] initWithString:argument];//argument;
    NSLog(@"prepare\n%@", argument);
    
    [self presentViewController:detailViewController animated:YES completion:nil];
}

@end
