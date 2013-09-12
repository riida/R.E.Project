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

@interface MapTestViewController ()<GMSMapViewDelegate>{
    
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
	
    //ボタン（スポット追加）
    UIButton *addSpotButton =
    [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addSpotButton.frame =CGRectMake(10, 10, 100, 30);
    addSpotButton.center = CGPointMake(50, 400);
    [addSpotButton setTitle:@"スポット追加" forState:UIControlStateNormal];
    [addSpotButton addTarget:self action:@selector(buttonPush:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addSpotButton];
    
    //人気スポット
    UIButton *populerSpotButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    populerSpotButton.frame = CGRectMake(10, 10, 100, 30);
    populerSpotButton.center = CGPointMake(269, 400);
    [populerSpotButton setTitle:@"人気スポット" forState:UIControlStateNormal];
    [populerSpotButton addTarget:self action:@selector(pButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:populerSpotButton];
    
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
    //UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"spotDetailFromMap"];
    
    DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"spotDetailFromMap"];
    
    //DetailViewController *detailViewController = [[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil];
    // 渡したい値を設定
    detailViewController.argument = [[NSString alloc] initWithString:argument];//argument;
    NSLog(@"prepare\n%@", argument);
    
    [self presentViewController:detailViewController animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //2つ目の画面にパラメータを渡して遷移する
    
    NSLog(@"segue identifier: %@", segue.identifier);
    
    if ([segue.identifier isEqualToString:@"spotDetail"]) {
        //ここでパラメータを渡す
        DetailViewController *detailViewController = segue.destinationViewController;
        detailViewController.argument = argument;
        NSLog(@"pre\n%@", argument);
    }
}

@end
