//
//  SpotDetailViewController.m
//  MapTest
//
//  Created by 飯田 諒 on 2013/09/11.
//  Copyright (c) 2013年 飯田 諒. All rights reserved.
//

#import "SpotDetailViewController.h"

@interface SpotDetailViewController ()
- (void)configureView;
@end

@implementation SpotDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        //[self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        //NSLog(@"%@-----\n%@", @"configure",_detailItem);
        self.titleLabel.text = _detailItem[@"title"];
        self.descLabel.text = _detailItem[@"desc"];
        NSString* dir = URL_STRING;
        NSString* picPath = _detailItem[@"pic"];
        NSString* address = [dir stringByAppendingString:picPath];
        NSURL *url = [NSURL URLWithString:address];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage* image = [[UIImage alloc] initWithData:data];
        self.spotNavi.title = [_detailItem[@"title"] stringByAppendingString:@"の詳細"];
        self.spotPicture.image = image;
        NSLog(@"success");
    } else {
        NSLog(@"error");
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
