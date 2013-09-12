//
//  SpotDetailViewController.h
//  MapTest
//
//  Created by 飯田 諒 on 2013/09/11.
//  Copyright (c) 2013年 飯田 諒. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CATEGORY_OMO (0)
#define CATEGORY_MOE (1)
#define CATEGORY_TIN (2)

@interface SpotDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UIImageView *spotPicture;
@property (weak, nonatomic) IBOutlet UINavigationItem *spotNavi;

@end
