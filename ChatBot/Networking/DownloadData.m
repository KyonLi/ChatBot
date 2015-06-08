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

+ (NSURLSessionDataTask *)getReplyDataWithBlock:(void (^)(BotReply *, NSError *))block inputStr:(NSString *)str {
	return [[AFAppDotNetAPIClient sharedClient] GET:[NSString stringWithFormat:@"api?key=392e90d77d0b4e05b5bf6c9f6a434815&info=%@&userid=test", [str URLEncodedString]] parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseData) {
//		NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
		BotReply *botReply = [[BotReply alloc] initWithDic:responseData];
		if (block) {
			block(botReply, nil);
		}
	} failure:^(NSURLSessionDataTask *task, NSError *error) {
		NSLog(@"%@", error);
		BotReply *botReply = [[BotReply alloc] init];
		if (block) {
			block(botReply, error);
		}
	}];
}

@end
