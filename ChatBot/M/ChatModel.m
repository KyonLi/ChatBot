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
	
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
	NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"gravatar.jpg"];
	if ([[NSFileManager defaultManager] fileExistsAtPath:imageFilePath]) {
		[dataDic setObject:imageFilePath forKey:@"strIcon"];
	} else {
		[dataDic setObject:[[NSBundle mainBundle] pathForResource:@"chatfrom_doctor_icon" ofType:@"png"] forKey:@"strIcon"];
	}
	
	[dataDic setObject:@(UUMessageFromMe) forKey:@"from"];
	[dataDic setObject:[[NSDate date] description] forKey:@"strTime"];
	NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
	[dataDic setObject:userName forKey:@"strName"];
	
	
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
	
	NSString *URLStr = [[NSBundle mainBundle] pathForResource:@"headImage" ofType:@"jpeg"];
	[dataDic setObject:@(UUMessageFromOther) forKey:@"from"];
	[dataDic setObject:[[NSDate date] description] forKey:@"strTime"];
	[dataDic setObject:@"小小m" forKey:@"strName"];
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
