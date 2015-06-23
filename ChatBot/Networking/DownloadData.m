//
//  DownloadData.m
//  ChatBot
//
//  Created by Kyon on 15/6/8.
//  Copyright (c) 2015年 Kyon Li. All rights reserved.
//

#import "DownloadData.h"
#import "AFAppDotNetAPIClient.h"
#import "NSString+URLEncoding.h"
#import "BotReply.h"

@implementation DownloadData

+ (NSURLSessionDataTask *)getReplyDataWithBlock:(void (^)(BotReply *data, NSError *error))block inputStr:(NSString *)str userID:(NSString *)userID location:(NSString *)loc longitude:(NSString *)lon latitude:(NSString *)lat {
	NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"392e90d77d0b4e05b5bf6c9f6a434815", @"key", str, @"info", userID, @"userid", loc, @"loc", lon, @"lon", lat, @"lat", nil];
	return [[AFAppDotNetAPIClient sharedClient] GET:@"api" parameters:parameters success:^(NSURLSessionDataTask *task, NSDictionary *responseData) {
//		NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
		BotReply *botReply = [[BotReply alloc] initWithDic:responseData];
		if (block) {
			block(botReply, nil);
		}
	} failure:^(NSURLSessionDataTask *task, NSError *error) {
		NSLog(@"%@", error);
		NSDictionary *dic = @{@"code":@"100000", @"text":@"网络连接异常，请稍后再试"};
		BotReply *botReply = [[BotReply alloc] initWithDic:dic];
		if (block) {
			block(botReply, error);
		}
	}];
}

@end
