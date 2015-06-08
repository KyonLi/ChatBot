//
//  BotReplyList.h
//  ChatBot
//
//  Created by Kyon on 15/6/8.
//  Copyright (c) 2015年 Kyon Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BotReplyList : NSObject
@property (nonatomic, retain, readonly) NSString *name;
@property (nonatomic, retain, readonly) NSString *info;
@property (nonatomic, retain, readonly) NSString *detailurl;
@property (nonatomic, retain, readonly) NSString *icon;
@property (nonatomic, retain, readonly) NSString *article;
@property (nonatomic, retain, readonly) NSString *source;
@property (nonatomic, retain, readonly) NSString *trainnum;
@property (nonatomic, retain, readonly) NSString *start;
@property (nonatomic, retain, readonly) NSString *terminal;
@property (nonatomic, retain, readonly) NSString *starttime;
@property (nonatomic, retain, readonly) NSString *endtime;
@property (nonatomic, retain, readonly) NSString *flight;
@property (nonatomic, retain, readonly) NSString *route;
@property (nonatomic, retain, readonly) NSString *state;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
