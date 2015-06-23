//
//  BotReply.h
//  ChatBot
//
//  Created by Kyon on 15/6/8.
//  Copyright (c) 2015年 Kyon Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BotReply : NSObject
@property (nonatomic, readonly) NSNumber *code;
@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly) NSString *url;
@property (nonatomic, readonly) NSMutableArray *dataList;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
