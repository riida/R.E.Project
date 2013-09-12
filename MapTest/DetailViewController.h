//
//  DetailViewController.h
//  MapTest
//
//  Created by 飯田 諒 on 2013/09/12.
//  Copyright (c) 2013年 飯田 諒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController {
    //NSString *argument;
}

@property (strong, nonatomic)NSString *argument;
@property (weak, nonatomic) IBOutlet UILabel *spotLabel;
@property (weak, nonatomic) IBOutlet UIImageView *spotPicture;
@property (weak, nonatomic) IBOutlet UILabel *spotDesc;


- (IBAction)valueButton:(id)sender;

@end
