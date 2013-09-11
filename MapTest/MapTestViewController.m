//
//  MapTestViewController.m
//  MapTest
//
//  Created by 飯田 諒 on 2013/09/05.
//  Copyright (c) 2013年 飯田 諒. All rights reserved.
//

#import "MapTestViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface MapTestViewController ()

@end

@implementation MapTestViewController{
    GMSMapView *mapView_;
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
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:17];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    mapView_.settings.myLocationButton = YES;
    self.view = mapView_;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(35.0, 140.0);
    marker.title = @"Tokyo";
    marker.snippet = @"Japan";
    marker.map = mapView_;
	
    //ボタン（スポット追加）
    UIButton *addsupotto =
    [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addsupotto.frame =CGRectMake(10, 10, 100, 30);
    addsupotto.center = CGPointMake(50, 400);
    [addsupotto setTitle:@"スポット追加" forState:UIControlStateNormal];
    [addsupotto addTarget:self action:@selector(buttonPush:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addsupotto];
    
    //人気スポット
    UIButton *populersupotto =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    populersupotto.frame = CGRectMake(10, 10, 100, 30);
    populersupotto.center = CGPointMake(269, 400);
    [populersupotto setTitle:@"人気スポット" forState:UIControlStateNormal];
    [populersupotto addTarget:self action:@selector(pButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:populersupotto];
    
    if([CLLocationManager locationServicesEnabled]){
        locationManager.delegate = self;
        [locationManager startUpdatingLocation];
    }else{
        NSLog(@"Location services not avaiable");
    }

}

//スポット追加
- (void)buttonPush:(UIButton *)addsupotto
{
    UIViewController *viewControlle = [self.storyboard instantiateViewControllerWithIdentifier:@"callFromSampleMap"];
    
    [self presentViewController:viewControlle animated:YES completion:nil];
}

//人気スポット
- (void)pButton:(UIButton *)populersupotto
{
    UIViewController *viewControlle = [self.storyboard instantiateViewControllerWithIdentifier:@"supotto"];
    
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


@end
