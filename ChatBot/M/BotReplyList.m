//
//  BotReplyList.m
//  ChatBot
//
//  Created by Kyon on 15/6/8.
//  Copyright (c) 2015年 Kyon Li. All rights reserved.
//

#import "BotReplyList.h"

@implementation BotReplyList

- (instancetype)initWithDic:(NSDictionary *)dic {
	if (self = [super init]) {
		[self setValuesForKeysWithDictionary:dic];
		_info = [[self info] stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
	}
	return self;
}

- (id)valueForUndefinedKey:(NSString *)key {
	return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
	
}

@end
