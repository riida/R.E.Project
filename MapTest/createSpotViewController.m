//
//  createSpotViewController.m
//  MapTest
//
//  Created by kitagawa erina on 13/09/10.
//  Copyright (c) 2013年 飯田 諒. All rights reserved.
//

#import "createSpotViewController.h"

@interface createSpotViewController ()

@end

@implementation createSpotViewController

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
	// Do any additional setup after loading the view.
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
    NSString *urlString = @"http://172.30.255.128:8000/register";
	
	// 画像をNSDataに変換
	NSData *imageData = [[NSData alloc]initWithData:UIImagePNGRepresentation(self.pictureImage.image)];
	//NSData *imageData = [[[NSData alloc]initWithData:UIImageJPEGRepresentation(self.pictureImage.image, 0.5)]autorelease];
	
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
	NSMutableString *sendDataStringNext = [NSMutableString stringWithString:@"\r\n"];
	[sendDataStringNext appendString:@"--"];
	[sendDataStringNext appendString:boundary];
    [sendDataStringNext appendString:@"\r\n"];
    [sendDataStringNext appendString:@"Content-Disposition: form-data; name=\"place_lati\"; \r\n\r\n"];
    [sendDataStringNext appendString:@"135.00 \r\n\r\n"];
	//[sendDataStringNext appendString:@"Content-Type: text/plain\r\n\r\n"];
    
    [sendDataStringNext appendString:@"--"];
	[sendDataStringNext appendString:boundary];
    [sendDataStringNext appendString:@"\r\n"];
    [sendDataStringNext appendString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"place_long\"; \r\n\r\n"]];
    [sendDataStringNext appendString:@"35.00\r\n\r\n"];
	//[sendDataStringNext appendString:@"Content-Type: text/plain\r\n\r\n"];
    
    [sendDataStringNext appendString:@"--"];
	[sendDataStringNext appendString:boundary];
    [sendDataStringNext appendString:@"\r\n"];
    [sendDataStringNext appendString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"title\"; \r\n\r\n"]];
    [sendDataStringNext appendString:@"sampleTitle\r\n\r\n"];
	//[sendDataStringNext appendString:@"Content-Type: text/plain\r\n\r\n"];
    
    [sendDataStringNext appendString:@"--"];
	[sendDataStringNext appendString:boundary];
    [sendDataStringNext appendString:@"\r\n"];
    [sendDataStringNext appendString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"desc\"; \r\n\r\n"]];
    [sendDataStringNext appendString:@"piyo\r\n"];
	//[sendDataStringNext appendString:@"Content-Type: text/plain\r\n\r\n"];
    
    
	
    NSMutableString *sendDataStringTail = [NSMutableString stringWithString:@"\r\n"];
	[sendDataStringTail appendString:@"--"];
	[sendDataStringTail appendString:boundary];
    [sendDataStringTail appendString:@"--"];
    
	// 送信データの生成
	NSMutableData *sendData = [NSMutableData data];
	[sendData appendData:[sendDataStringPrev dataUsingEncoding:NSUTF8StringEncoding]];
	[sendData appendData:imageData];
	[sendData appendData:[sendDataStringNext dataUsingEncoding:NSUTF8StringEncoding]];
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
    NSData* data = [NSURLConnection
                    sendSynchronousRequest:request
                    returningResponse:&response
                    error:&error];
    
    NSString* result = [[NSString alloc]
                        initWithData:data
                        encoding:NSASCIIStringEncoding];
    NSLog(@"%@",result);
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

@end
