//
//  ChatModel.h
//  ChatBot
//
//  Created by Kyon on 15/6/8.
//  Copyright (c) 2015年 Kyon Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatModel : NSObject
@property (nonatomic, strong) NSMutableArray *dataSource;

- (void)addChatRecordFromMe:(NSDictionary *)dic;
- (void)addChatRecordFromBot:(NSDictionary *)dic;

@end
