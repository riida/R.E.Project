//
//  DetailViewController.m
//  MapTest
//
//  Created by 飯田 諒 on 2013/09/12.
//  Copyright (c) 2013年 飯田 諒. All rights reserved.
//

#import "DetailViewController.h"
#import "SVProgressHUD.h"

//define URL_STRING @"http://172.30.254.141:8000/"
#define URL_STRING @"http://192.168.11.2:8000/"
//#define URL_STRING @"http://ec2-54-250-229-175.ap-northeast-1.compute.amazonaws.com:8000/"

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
    NSLog(@"string%@", _argument);
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
    
    self.spotLabel.text = spotDic[@"title"];
    self.spotDesc.text = spotDic[@"desc"];
    
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
    NSString* dir = URL_STRING;
    NSString* picId = _argument;
    NSString* base = [dir stringByAppendingString:@"estimate?id="];
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
    
    NSDictionary *newSpotDic = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingAllowFragments
                                                                 error:&error];
    NSLog(@"oldValue : %@", spotDic[@"value"]);
    NSLog(@"newValue : %@", newSpotDic[@"value"]);
    
}
@end
