//
//  createSpotViewController.h
//  MapTest
//
//  Created by kitagawa erina on 13/09/10.
//  Copyright (c) 2013年 飯田 諒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#define URL_STRING @"http://172.30.254.141:8000/"
//#define URL_STRING @"http://192.168.11.2:8000/"
//#define URL_STRING @"http://ec2-54-250-229-175.ap-northeast-1.compute.amazonaws.com:8000/"

#define CATEGORY_OMO (0)
#define CATEGORY_MOE (1)
#define CATEGORY_TIN (2)

@interface createSpotViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate, UIScrollViewDelegate, CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
    double spot_long;
    double spot_lati;
    int spotCategory;
}

- (IBAction)startCamera:(id)sender;
- (IBAction)sendDataToServer:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImage;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UITextField *descTF;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sc;
@property(nonatomic, retain) CLLocationManager *locationManager;

- (IBAction)segChanged:(id)sender;

@end
