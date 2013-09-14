//
//  DetailViewController.h
//  MapTest
//
//  Created by 飯田 諒 on 2013/09/12.
//  Copyright (c) 2013年 飯田 諒. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CATEGORY_OMO (0)
#define CATEGORY_MOE (1)
#define CATEGORY_TIN (2)

#define URL_STRING @"http://192.168.11.2:8000/"
//#define URL_STRING @"http://ec2-54-250-229-175.ap-northeast-1.compute.amazonaws.com:8000/"

@interface DetailViewController : UIViewController

@property (strong, nonatomic)NSString *argument;
@property (weak, nonatomic) IBOutlet UILabel *spotLabel;
@property (weak, nonatomic) IBOutlet UIImageView *spotPicture;
@property (weak, nonatomic) IBOutlet UILabel *spotDesc;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;


- (IBAction)valueButton:(id)sender;

@end
