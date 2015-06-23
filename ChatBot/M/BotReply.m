//
//  BotReply.m
//  ChatBot
//
//  Created by Kyon on 15/6/8.
//  Copyright (c) 2015年 Kyon Li. All rights reserved.
//

#import "BotReply.h"
#import "BotReplyList.h"

@implementation BotReply

-(instancetype)initWithDic:(NSDictionary *)dic {
	if (self = [super init]) {
		_dataList = [NSMutableArray new];
		[self setValuesForKeysWithDictionary:dic];
		_text = [[self text] stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
	}
	return self;
}

- (id)valueForUndefinedKey:(NSString *)key {
	return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
	if ([key isEqualToString:@"list"]) {
		for (NSDictionary *dic in value) {
			BotReplyList *list = [[BotReplyList alloc] initWithDic:dic];
			[_dataList addObject:list];
		}
	}
}

@end
