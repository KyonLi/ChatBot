//
//  RootTabBarController.m
//  ChatBot
//
//  Created by Kyon on 15/6/8.
//  Copyright (c) 2015年 Kyon Li. All rights reserved.
//

#import "RootTabBarController.h"
#import "ChatViewController.h"
#import "SettingsTableViewController.h"

@interface RootTabBarController ()

@end

@implementation RootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	ChatViewController *chatVC = [[ChatViewController alloc] init];
	UINavigationController *chatNav = [[UINavigationController alloc] initWithRootViewController:chatVC];
	[[chatNav tabBarItem] setTitle:@"聊天"];
	[[chatNav tabBarItem] setImage:[UIImage imageNamed:@"09-chat-2"]];
	
	SettingsTableViewController *settingsVC = [[SettingsTableViewController alloc] init];
	UINavigationController *settingsNav = [[UINavigationController alloc] initWithRootViewController:settingsVC];
	[[settingsNav tabBarItem] setTitle:@"设置"];
	[[settingsNav tabBarItem] setImage:[UIImage imageNamed:@"19-gear"]];
	
	[self setViewControllers:@[chatNav, settingsNav] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
