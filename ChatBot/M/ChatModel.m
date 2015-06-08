//
//  ChatModel.m
//  ChatBot
//
//  Created by Kyon on 15/6/8.
//  Copyright (c) 2015年 Kyon Li. All rights reserved.
//

#import "ChatModel.h"
#import "UUMessage.h"
#import "UUMessageFrame.h"

@implementation ChatModel
static NSString *previousTime = nil;

- (instancetype)init {
	if (self = [super init]) {
		_dataSource = [NSMutableArray new];
	}
	return self;
}

- (void)addChatRecordFromMe:(NSDictionary *)dic {
	UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
	UUMessage *message = [[UUMessage alloc] init];
	NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
	
	NSString *URLStr = @"http://img0.bdstatic.com/img/image/shouye/xinshouye/mingxing16.jpg";
	[dataDic setObject:@(UUMessageFromMe) forKey:@"from"];
	[dataDic setObject:[[NSDate date] description] forKey:@"strTime"];
	[dataDic setObject:@"UserName" forKey:@"strName"];
	[dataDic setObject:URLStr forKey:@"strIcon"];
	
	[message setWithDict:dataDic];
	[message minuteOffSetStart:previousTime end:dataDic[@"strTime"]];
	messageFrame.showTime = message.showDateLabel;
	[messageFrame setMessage:message];
	
	if (message.showDateLabel) {
		previousTime = dataDic[@"strTime"];
	}
	[self.dataSource addObject:messageFrame];
}

- (void)addChatRecordFromBot:(NSDictionary *)dic {
	UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
	UUMessage *message = [[UUMessage alloc] init];
	NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
	
	NSString *URLStr = @"http://p1.qqyou.com/touxiang/uploadpic/2011-3/20113212244659712.jpg";
	[dataDic setObject:@(UUMessageFromOther) forKey:@"from"];
	[dataDic setObject:[[NSDate date] description] forKey:@"strTime"];
	[dataDic setObject:@"Bot" forKey:@"strName"];
	[dataDic setObject:URLStr forKey:@"strIcon"];
	
	[message setWithDict:dataDic];
	[message minuteOffSetStart:previousTime end:dataDic[@"strTime"]];
	messageFrame.showTime = message.showDateLabel;
	[messageFrame setMessage:message];
	
	if (message.showDateLabel) {
		previousTime = dataDic[@"strTime"];
	}
	[self.dataSource addObject:messageFrame];
}

@end
