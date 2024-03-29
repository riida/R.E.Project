//
//  createSpotViewController.m
//  MapTest
//
//  Created by kitagawa erina on 13/09/10.
//  Copyright (c) 2013年 飯田 諒. All rights reserved.
//

#import "createSpotViewController.h"
#import "MapTestViewController.h"
#import "SVProgressHUD.h"

@interface createSpotViewController ()

@end

@implementation createSpotViewController

@synthesize locationManager;

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
     self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    _titleTF.delegate = self;
    _descTF.delegate = self;
    //[_cameraButton setTitle:@"かめら" forState:UIControlStateNormal];
    //[_sendButton setTitle:@"のこす" forState:UIControlStateNormal];
    
    //スポットのカテゴリの初期化
    spotCategory = CATEGORY_OMO;
    
    [self registerForKeyboardNotifications];
    
    locationManager = [[CLLocationManager alloc] init];
    
    if ([CLLocationManager locationServicesEnabled]) {
        locationManager.delegate = self;
        // 測位開始
        [locationManager startUpdatingLocation];
    } else {
        NSLog(@"Location services not available.");
    }
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
		// カメラかライブラリからの読込指定。カメラを指定。
		[imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
		// トリミングなどを行うか否か
		[imagePickerController setAllowsEditing:YES];
		// Delegate
		[imagePickerController setDelegate:self];
		
		// アニメーションをしてカメラUIを起動
		[self presentViewController:imagePickerController animated:YES completion:nil];
	}
	else
	{
		NSLog(@"camera invalid.");
	}
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startCamera:(id)sender {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
		// カメラかライブラリからの読込指定。カメラを指定。
		[imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
		// トリミングなどを行うか否か
		[imagePickerController setAllowsEditing:YES];
		// Delegate
		[imagePickerController setDelegate:self];
		
		// アニメーションをしてカメラUIを起動
		[self presentViewController:imagePickerController animated:YES completion:nil];
	}
	else
	{
		NSLog(@"camera invalid.");
	}
}

- (IBAction)sendDataToServer:(id)sender {
    // アラートビューを作成
    // キャンセルボタンを表示しない場合はcancelButtonTitleにnilを指定
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"ほぞん"
                          message:@"実行しますか？"
                          delegate:self
                          cancelButtonTitle:@"いいえ"
                          otherButtonTitles:@"はい", nil];
    [alert show];
}

/**
 * アラートのボタンが押されたとき
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:{ // はいが押されたとき
            [SVProgressHUD showWithStatus:@"送信中"maskType:SVProgressHUDMaskTypeBlack];
            NSLog(@"はい");
            NSString *root = URL_STRING;
            NSString *urlString = [root stringByAppendingString:@"register"];
            // 画像をNSDataに変換
            NSData *imageData = [[NSData alloc]initWithData:UIImagePNGRepresentation(self.pictureImage.image)];
            
            
            // 送信データの境界
            NSString *boundary = @"1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
            // アップロードする際のパラメーター名とファイル名
            NSString *uploadName = @"pic";
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *uploadFileName = [dateFormatter stringFromDate:[NSDate date]];
            // 送信するデータ（前半）
            NSMutableString *sendDataStringPrev = [NSMutableString stringWithString:@"--"];
            [sendDataStringPrev appendString:boundary];
            [sendDataStringPrev appendString:@"\r\n"];
            //ファイルの名前は日付
            [sendDataStringPrev appendString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.png\"\r\n",uploadName,uploadFileName]];
            [sendDataStringPrev appendString:@"Content-Type: image/ping\r\n\r\n"];
            // 送信するデータ（後半）
            NSMutableString *sendDataStringMiddle = [NSMutableString stringWithString:@"\r\n"];
            [sendDataStringMiddle appendString:@"--"];
            [sendDataStringMiddle appendString:boundary];
            [sendDataStringMiddle appendString:@"\r\n"];
            [sendDataStringMiddle appendString:@"Content-Disposition: form-data; name=\"place_lati\"; \r\n\r\n"];
            NSString *lati = [NSString stringWithFormat:@"%f", spot_lati];
            [sendDataStringMiddle appendString:lati];
            [sendDataStringMiddle appendString:@"\r\n\r\n"];
            
            [sendDataStringMiddle appendString:@"--"];
            [sendDataStringMiddle appendString:boundary];
            [sendDataStringMiddle appendString:@"\r\n"];
            [sendDataStringMiddle appendString:@"Content-Disposition: form-data; name=\"place_long\"; \r\n\r\n"];
            NSString *longtitude = [NSString stringWithFormat:@"%f", spot_long];
            [sendDataStringMiddle appendString:longtitude];
            [sendDataStringMiddle appendString:@"\r\n\r\n"];
            
            [sendDataStringMiddle appendString:@"--"];
            [sendDataStringMiddle appendString:boundary];
            [sendDataStringMiddle appendString:@"\r\n"];
            [sendDataStringMiddle appendString:@"Content-Disposition: form-data; name=\"category\"; \r\n\r\n"];
            NSString *category = [NSString stringWithFormat:@"%d", spotCategory];
            [sendDataStringMiddle appendString:category];
            [sendDataStringMiddle appendString:@"\r\n\r\n"];
            
            [sendDataStringMiddle appendString:@"--"];
            [sendDataStringMiddle appendString:boundary];
            [sendDataStringMiddle appendString:@"\r\n"];
            [sendDataStringMiddle appendString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"title\"; \r\n\r\n"]];
            [sendDataStringMiddle appendString:_titleTF.text];
            [sendDataStringMiddle appendString:@"\r\n\r\n"];
            
            [sendDataStringMiddle appendString:@"--"];
            [sendDataStringMiddle appendString:boundary];
            [sendDataStringMiddle appendString:@"\r\n"];
            [sendDataStringMiddle appendString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"desc\"; \r\n\r\n"]];
            [sendDataStringMiddle appendString:_descTF.text];
            [sendDataStringMiddle appendString:@"\r\n"];
            
            NSMutableString *sendDataStringTail = [NSMutableString stringWithString:@"\r\n"];
            [sendDataStringTail appendString:@"--"];
            [sendDataStringTail appendString:boundary];
            [sendDataStringTail appendString:@"--"];
            
            // 送信データの生成
            NSMutableData *sendData = [NSMutableData data];
            [sendData appendData:[sendDataStringPrev dataUsingEncoding:NSUTF8StringEncoding]];
            [sendData appendData:imageData];
            [sendData appendData:[sendDataStringMiddle dataUsingEncoding:NSUTF8StringEncoding]];
            [sendData appendData:[sendDataStringTail dataUsingEncoding:NSUTF8StringEncoding]];
            // リクエストヘッダー
            NSDictionary *requestHeader = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [NSString stringWithFormat:@"%d",[sendData length]],@"Content-Length",
                                           [NSString stringWithFormat:@"multipart/form-data;boundary=%@",boundary],@"Content-Type",nil];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
            [request setAllHTTPHeaderFields:requestHeader];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:sendData];
            
            NSURLResponse* response = nil;
            NSError* error = nil;
            [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            [SVProgressHUD dismiss];
            
            MapTestViewController *mapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapView"];
            
            [self presentViewController:mapViewController animated:YES completion:^(void){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"スポット登録"
                                                                message:@""
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
                [alert show];
            }];
        }
            break;
        default: // いいえが押されたとき
            NSLog(@"いいえ");
             [SVProgressHUD dismiss];
            break;
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // オリジナル画像
	UIImage *originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
	// 編集画像
	UIImage *editedImage = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
	UIImage *saveImage;
	
	if(editedImage)
	{
		saveImage = editedImage;
	}
	else
	{
		saveImage = originalImage;
	}
	
	// UIImageViewに画像を設定
	self.pictureImage.image = saveImage;
	
	if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
	{
		// カメラから呼ばれた場合は画像をフォトライブラリに保存してViewControllerを閉じる
		UIImageWriteToSavedPhotosAlbum(saveImage, nil, nil, nil);
		[self dismissViewControllerAnimated:YES completion:nil];
	}
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    CGPoint scrollPoint = CGPointMake(0.0,200.0);
    [_scrollView setContentOffset:scrollPoint animated:YES];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [_scrollView setContentOffset:CGPointZero animated:YES];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    NSLog(@"didUpdateToLocation latitude=%f, longitude=%f",
          [newLocation coordinate].latitude,
          [newLocation coordinate].longitude);
    spot_lati = [newLocation coordinate].latitude;
    spot_long = [newLocation coordinate].longitude;
    
}

-(void)locationManager:(CLLocationManager *)manager
      didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError");
}

- (IBAction)segChanged:(id)sender {
    switch (_sc.selectedSegmentIndex) {
        case CATEGORY_OMO:
            spotCategory = CATEGORY_OMO;
            break;
            
        case CATEGORY_MOE:
            spotCategory = CATEGORY_MOE;
            break;
            
        case CATEGORY_TIN:
            spotCategory = CATEGORY_TIN;
        
        default:
            break;
    }
}

- (IBAction)execCamera:(id)sender {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
		// カメラかライブラリからの読込指定。カメラを指定。
		[imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
		// トリミングなどを行うか否か
		[imagePickerController setAllowsEditing:YES];
		// Delegate
		[imagePickerController setDelegate:self];
		
		// アニメーションをしてカメラUIを起動
		[self presentViewController:imagePickerController animated:YES completion:nil];
	}
	else
	{
		NSLog(@"camera invalid.");
	}
}

- (IBAction)registerSpot:(id)sender {
    // アラートビューを作成
    // キャンセルボタンを表示しない場合はcancelButtonTitleにnilを指定
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"ほぞん"
                          message:@"実行しますか？"
                          delegate:self
                          cancelButtonTitle:@"いいえ"
                          otherButtonTitles:@"はい", nil];
    [alert show];
}

@end
