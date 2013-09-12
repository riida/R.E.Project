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

@interface MapTestViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    CLLocationManager *locationManager;
    NSString *argument;
    UIToolbar *toolBar;
}
//ロケーションマネージャー
@property(nonatomic, retain) CLLocationManager *locationManager;


@end
