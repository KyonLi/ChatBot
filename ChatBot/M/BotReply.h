//
//  BotReply.h
//  ChatBot
//
//  Created by Kyon on 15/6/8.
//  Copyright (c) 2015年 Kyon Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BotReply : NSObject
@property (nonatomic, retain, readonly) NSNumber *code;
@property (nonatomic, copy, readonly) NSString *text;
@property (nonatomic, copy, readonly) NSString *url;
@property (nonatomic, readonly) NSMutableArray *dataList;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
