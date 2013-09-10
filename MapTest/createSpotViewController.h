//
//  createSpotViewController.h
//  MapTest
//
//  Created by kitagawa erina on 13/09/10.
//  Copyright (c) 2013年 飯田 諒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface createSpotViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{

}
- (IBAction)startCamera:(id)sender;
- (IBAction)sendDataToServer:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImage;


@end
