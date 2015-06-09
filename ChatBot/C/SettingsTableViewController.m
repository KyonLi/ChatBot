//
//  SettingsTableViewController.m
//  ChatBot
//
//  Created by Kyon on 15/6/9.
//  Copyright (c) 2015年 Kyon Li. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "NSData+CRC.h"

@interface SettingsTableViewController () <UIAlertViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, retain) UIAlertView *alertView;
@property (nonatomic, retain) UIActionSheet *actionSheet;

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
	_alertView = [[UIAlertView alloc] initWithTitle:@"请输入昵称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
	[_alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
	[[self tableView] addSubview:_alertView];
	
	_actionSheet= [[UIActionSheet alloc] initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机", @"图库", @"删除头像", nil];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
	[[_alertView textFieldAtIndex:0] setText:userName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellID"];
	}
	if (indexPath.row == 0) {
		[[cell textLabel] setText:@"设置昵称"];
	}
	else if(indexPath.row == 1) {
		[[cell textLabel] setText:@"设置头像"];
	}
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		[_alertView show];
	}
	else if(indexPath.row == 1) {
		// 弹出actionsheet。选择获取头像的方式
		[_actionSheet showInView:self.view.window];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSLog(@"%@", [[alertView textFieldAtIndex:0] text]);
	NSData *data = [[[alertView textFieldAtIndex:0] text] dataUsingEncoding:NSUTF8StringEncoding];
	NSString *userID = [NSString stringWithFormat:@"%x", [data crc16]];
	NSLog(@"%@", userID);
	[[NSUserDefaults standardUserDefaults] setObject:[[alertView textFieldAtIndex:0] text] forKey:@"userName"];
	[[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"userID"];
}


#pragma mark -
#pragma UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex) {
		case 0://照相机
		{
			UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
			imagePicker.delegate = self;
			imagePicker.allowsEditing = YES;
			imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
			//            [self presentModalViewController:imagePicker animated:YES];
			[self presentViewController:imagePicker animated:YES completion:nil];
		}
			break;
		case 1://本地相簿
		{
			UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
			imagePicker.delegate = self;
			imagePicker.allowsEditing = YES;
			imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
			//            [self presentModalViewController:imagePicker animated:YES];
			[self presentViewController:imagePicker animated:YES completion:nil];
		}
			break;
		case 2://删除头像
		{
			NSFileManager *fileManager = [NSFileManager defaultManager];
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory = [paths objectAtIndex:0];
			NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"gravatar.jpg"];
			if([fileManager fileExistsAtPath:imageFilePath]) {
				[fileManager removeItemAtPath:imageFilePath error:nil];
			}
		}
			break;
		default:
			break;
	}
}

#pragma mark -
#pragma UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
	[self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
	//    [picker dismissModalViewControllerAnimated:YES];
	[picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	//    [picker dismissModalViewControllerAnimated:YES];
	[picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image {
	//    NSLog(@"保存头像！");
	BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"gravatar.jpg"];
	NSLog(@"imageFile->>%@",imageFilePath);
	success = [fileManager fileExistsAtPath:imageFilePath];
	if(success) {
		success = [fileManager removeItemAtPath:imageFilePath error:&error];
	}
	UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(220, 220)];
	[UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
}

// 改变图像的尺寸，方便上传服务器
//- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
//{
//	UIGraphicsBeginImageContext(size);
//	[image drawInRect:CGRectMake(0, 0, size.width, size.height)];
//	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//	UIGraphicsEndImageContext();
//	return newImage;
//}

//2.保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
	UIImage *newimage;
	if (nil == image) {
		newimage = nil;
	}
	else{
		CGSize oldsize = image.size;
		CGRect rect;
		if (asize.width/asize.height > oldsize.width/oldsize.height) {
			rect.size.width = asize.height*oldsize.width/oldsize.height;
			rect.size.height = asize.height;
			rect.origin.x = (asize.width - rect.size.width)/2;
			rect.origin.y = 0;
		}
		else{
			rect.size.width = asize.width;
			rect.size.height = asize.width*oldsize.height/oldsize.width;
			rect.origin.x = 0;
			rect.origin.y = (asize.height - rect.size.height)/2;
		}
		UIGraphicsBeginImageContext(asize);
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
		UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
		[image drawInRect:rect];
		newimage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
	return newimage;
}

@end
