//
//  MapTestViewController.h
//  MapTest
//
//  Created by 飯田 諒 on 2013/09/05.
//  Copyright (c) 2013年 飯田 諒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

//#define URL_STRING @"http://172.30.254.141:8000/"
#define URL_STRING @"http://192.168.11.2:8000/"
//#define URL_STRING @"http://ec2-54-250-229-175.ap-northeast-1.compute.amazonaws.com:8000/"

#define CATEGORY_ZEN (-1)
#define CATEGORY_OMO (0)
#define CATEGORY_MOE (1)
#define CATEGORY_TIN (2)

@interface MapTestViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    CLLocationManager *locationManager;
    NSString *argument;
    UIToolbar *toolBar;
    NSData *data;
}
//ロケーションマネージャー
@property(nonatomic, retain) CLLocationManager *locationManager;

@end
