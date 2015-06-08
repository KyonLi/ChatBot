//
//  RootTabBarController.m
//  ChatBot
//
//  Created by Kyon on 15/6/8.
//  Copyright (c) 2015年 Kyon Li. All rights reserved.
//

#import "RootTabBarController.h"
#import "ChatViewController.h"

@interface RootTabBarController ()

@end

@implementation RootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	ChatViewController *chatVC = [[ChatViewController alloc] init];
	UINavigationController *chatNav = [[UINavigationController alloc] initWithRootViewController:chatVC];
	UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:500];
	[[chatNav tabBarItem] setTitle:@"聊天"];
	[chatNav setTabBarItem:tabBarItem];
	
	[self setViewControllers:@[chatNav] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
