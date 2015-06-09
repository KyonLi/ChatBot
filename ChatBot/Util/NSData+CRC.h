//
//  NSData+CRC.h
//  ChatBot
//
//  Created by Kyon on 15/6/9.
//  Copyright (c) 2015年 Kyon Li. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSData (CRC)

- (unsigned int)crc16;

- (unsigned long)crc32;

- (unsigned long long)crc64;


@end
