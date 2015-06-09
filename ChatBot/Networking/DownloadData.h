//
//  DownloadData.h
//  ChatBot
//
//  Created by Kyon on 15/6/8.
//  Copyright (c) 2015年 Kyon Li. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BotReply;

@interface DownloadData : NSObject
+ (NSURLSessionDataTask *)getReplyDataWithBlock:(void (^)(BotReply *data, NSError *error))block inputStr:(NSString *)str userID:(NSString *)userID;

@end
