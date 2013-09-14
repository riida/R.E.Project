//
//  DetailViewController.m
//  MapTest
//
//  Created by 飯田 諒 on 2013/09/12.
//  Copyright (c) 2013年 飯田 諒. All rights reserved.
//

#import "DetailViewController.h"
#import "SVProgressHUD.h"

@interface DetailViewController ()

@end

@implementation DetailViewController{
    NSMutableDictionary *spotDic;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.spotLabel.text = _argument;
    [SVProgressHUD showWithStatus:@"通信中" maskType:SVProgressHUDMaskTypeBlack];
    NSString* dir = URL_STRING;
    NSString* picId = _argument;
    NSString* base = [dir stringByAppendingString:@"spot?id="];
    NSString* address = [base stringByAppendingString:picId];
    NSURL* url = [NSURL URLWithString:address];
    NSURLRequest* request = [NSURLRequest
                             requestWithURL:url];
    NSURLResponse* response = nil;
    NSError* error = nil;
    NSData* data = [NSURLConnection
                    sendSynchronousRequest:request
                    returningResponse:&response
                    error:&error];

    spotDic = [NSJSONSerialization JSONObjectWithData:data
                                                     options:NSJSONReadingAllowFragments
                                                       error:&error];
    
    [SVProgressHUD dismiss];
    
    self.spotLabel.text = spotDic[@"title"];
    self.spotDesc.text = spotDic[@"desc"];
    
    currentValue = [spotDic[@"value"] intValue];
    NSString *value = [NSString stringWithFormat:@"%d", currentValue];
    NSString *valueText = [value stringByAppendingString:@" ぐっど！"];
    self.valueLabel.text = valueText;
    
    NSString* picPath = spotDic[@"pic"];
    NSString* picAddress = [dir stringByAppendingString:picPath];
    NSURL *picURL = [NSURL URLWithString:picAddress];
    NSData *picData = [NSData dataWithContentsOfURL:picURL];
    UIImage* image = [[UIImage alloc] initWithData:picData];
    self.spotPicture.image = image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//いいねボタンの処理
- (IBAction)valueButton:(id)sender {
    
    currentValue++;
    NSString *value = [NSString stringWithFormat:@"%d", currentValue];
    NSString *valueText = [value stringByAppendingString:@" ぐっど！"];
    self.valueLabel.text = valueText;
    NSString* dir = URL_STRING;
    NSString* picId = _argument;
    NSString* base = [dir stringByAppendingString:@"estimate?id="];
    NSString* address = [base stringByAppendingString:picId];
    NSURL* url = [NSURL URLWithString:address];
    NSURLRequest* request = [NSURLRequest
                             requestWithURL:url];
    NSURLResponse* response = nil;
    NSError* error = nil;
    [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&response
                                      error:&error];
    
}
@end
