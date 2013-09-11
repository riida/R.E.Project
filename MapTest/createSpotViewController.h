//
//  createSpotViewController.h
//  MapTest
//
//  Created by kitagawa erina on 13/09/10.
//  Copyright (c) 2013年 飯田 諒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface createSpotViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate, UIScrollViewDelegate, CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
}

- (IBAction)startCamera:(id)sender;
- (IBAction)sendDataToServer:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImage;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UITextField *descTF;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property(nonatomic, retain) CLLocationManager *locationManager;

@end
