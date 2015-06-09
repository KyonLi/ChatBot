//
//  SettingsTableViewController.m
//  ChatBot
//
//  Created by Kyon on 15/6/9.
//  Copyright (c) 2015年 Kyon Li. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "NSData+CRC.h"

@interface SettingsTableViewController () <UIAlertViewDelegate>
@property (nonatomic, retain) UIAlertView *alertView;

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
	_alertView = [[UIAlertView alloc] initWithTitle:@"请输入昵称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
	[_alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
	[[self tableView] addSubview:_alertView];
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
	} else {
		[[cell textLabel] setText:@"设置头像"];
	}
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		[_alertView show];
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

@end
