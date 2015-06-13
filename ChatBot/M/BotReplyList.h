//
//  BotReplyList.h
//  ChatBot
//
//  Created by Kyon on 15/6/8.
//  Copyright (c) 2015年 Kyon Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BotReplyList : NSObject
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *info;
@property (nonatomic, copy, readonly) NSString *detailurl;
@property (nonatomic, copy, readonly) NSString *icon;
@property (nonatomic, copy, readonly) NSString *article;
@property (nonatomic, copy, readonly) NSString *source;
@property (nonatomic, copy, readonly) NSString *trainnum;
@property (nonatomic, copy, readonly) NSString *start;
@property (nonatomic, copy, readonly) NSString *terminal;
@property (nonatomic, copy, readonly) NSString *starttime;
@property (nonatomic, copy, readonly) NSString *endtime;
@property (nonatomic, copy, readonly) NSString *flight;
@property (nonatomic, copy, readonly) NSString *route;
@property (nonatomic, copy, readonly) NSString *state;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
