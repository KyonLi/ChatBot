//
//  ChatViewController.m
//  ChatBot
//
//  Created by Kyon on 15/6/8.
//  Copyright (c) 2015年 Kyon Li. All rights reserved.
//

#import "ChatViewController.h"
#import "UUInputFunctionView.h"
//#import "MJRefresh.h"
#import "UUMessageCell.h"
#import "UUMessageFrame.h"
#import "UUMessage.h"
#import "ChatModel.h"
#import "DownloadData.h"
#import "BotReply.h"
#import "BotReplyList.h"

@interface ChatViewController () <UUInputFunctionViewDelegate,UUMessageCellDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (strong, nonatomic) MJRefreshHeader *head;
@property (strong, nonatomic) UUInputFunctionView *IFView;
@property (strong, nonatomic) ChatModel *chatModel;
@property (strong, nonatomic) NSString *userID;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	[[self tableView] registerClass:[UUMessageCell class] forCellReuseIdentifier:@"ChatCell"];
	[self initBar];
//	[self addRefreshViews];
	[self loadBaseViewsAndData];
	
	NSDictionary *dic = @{@"strContent": @"我是XX，很高兴能和你聊天",
						  @"type": @(UUMessageTypeText)};
	[self.chatModel addChatRecordFromBot:dic];
	[self.tableView reloadData];
	[self tableViewScrollToBottom];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	_userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	//add notification
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewScrollToBottom) name:UIKeyboardDidShowNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)initBar {
	[[self navigationItem] setTitle:@"聊天"];
	
	self.navigationController.navigationBar.tintColor = [UIColor grayColor];
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:nil action:nil];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:nil];
}

- (void)loadBaseViewsAndData {
	self.chatModel = [[ChatModel alloc]init];
	_IFView = [[UUInputFunctionView alloc]initWithSuperVC:self];
	_IFView.delegate = self;
	[_IFView setFrame:CGRectMake(_IFView.frame.origin.x, _IFView.frame.origin.y - 49, _IFView.frame.size.width, _IFView.frame.size.height)];
	[_IFView changeSendBtnWithPhoto:NO];
	[self.view addSubview:_IFView];
	[self.tableView reloadData];
	[self tableViewScrollToBottom];
}

-(void)keyboardChange:(NSNotification *)notification {
	NSDictionary *userInfo = [notification userInfo];
	NSTimeInterval animationDuration;
	UIViewAnimationCurve animationCurve;
	CGRect keyboardEndFrame;
	
	[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
	[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
	[[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:animationDuration];
	[UIView setAnimationCurve:animationCurve];
	
	//adjust ChatTableView's height
	if (notification.name == UIKeyboardWillShowNotification) {
		self.bottomConstraint.constant = keyboardEndFrame.size.height + 40 - 49;
	}else{
		self.bottomConstraint.constant = 40;
	}
	
	[self.view layoutIfNeeded];
	
	//adjust UUInputFunctionView's originPoint
	CGRect newFrame = _IFView.frame;
	if (notification.name == UIKeyboardWillShowNotification) {
		newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height;
	}else{
		newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height - 49;
	}
	_IFView.frame = newFrame;
	
	[UIView commitAnimations];
}

- (void)tableViewScrollToBottom {
	if (self.chatModel.dataSource.count==0)
		return;
	
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatModel.dataSource.count-1 inSection:0];
	[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - InputFunctionViewDelegate
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message {
	if (![message isEqualToString:@""]) {
		NSDictionary *dic = @{@"strContent": message,
							  @"type": @(UUMessageTypeText)};
		funcView.TextViewInput.text = @"";
//		[funcView changeSendBtnWithPhoto:YES];
		[self dealTheFunctionData:dic];
	}
}

- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendPicture:(UIImage *)image {
	NSDictionary *dic = @{@"picture": image,
						  @"type": @(UUMessageTypePicture)};
	[self dealTheFunctionData:dic];
}

- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendVoice:(NSData *)voice time:(NSInteger)second {
	NSDictionary *dic = @{@"voice": voice,
						  @"strVoiceTime": [NSString stringWithFormat:@"%d",(int)second],
						  @"type": @(UUMessageTypeVoice)};
	[self dealTheFunctionData:dic];
}

- (void)dealTheFunctionData:(NSDictionary *)dic {
	[self.chatModel addChatRecordFromMe:dic];
	[self.tableView reloadData];
	[self tableViewScrollToBottom];
	
	[DownloadData getReplyDataWithBlock:^(BotReply *data, NSError *error) {
//		NSDictionary *replyDic =  [self dealTheReplyToDic:data];
		NSArray *array = [self dealTheReply:data];
		for (NSDictionary *replyDic in array) {
			[self.chatModel addChatRecordFromBot:replyDic];
		}
		[self.tableView reloadData];
		[self tableViewScrollToBottom];
		
		if ([data.code integerValue] == 200000) {
			dispatch_queue_t queue = dispatch_queue_create("com.kyonli.openUrl", DISPATCH_QUEUE_SERIAL);
			dispatch_async(queue, ^{
				sleep(1);
				dispatch_async(dispatch_get_main_queue(), ^{
					[[UIApplication sharedApplication] openURL:[NSURL URLWithString:data.url]];
				});
			});
		}
	} inputStr:dic[@"strContent"] userID:_userID];
}

- (NSArray *)dealTheReply:(BotReply *)data {
	NSMutableArray *array = [NSMutableArray new];
	NSArray *contentData = data.dataList;
	NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:data.text, @"strContent", @(UUMessageTypeText), @"type", nil];
	if ([data.code integerValue] == 200000) {
		[dic addEntriesFromDictionary:@{@"url":[NSURL URLWithString:data.url]}];
	}
	[array addObject:dic];
	NSInteger code = [data.code integerValue];
	static NSString *text = nil;
	for (BotReplyList *botReplyList in contentData) {
		if (code == 305000) {
			text = [NSString stringWithFormat:@"车次:%@\n起始站:%@(%@) 到达站:%@(%@)\n详情见: %@", botReplyList.trainnum, botReplyList.start, botReplyList.starttime, botReplyList.terminal, botReplyList.endtime, botReplyList.detailurl];
		}
		else if (code == 306000) {
			text = [NSString stringWithFormat:@"航班:%@(%@)\n%@(%@ - %@)\n详情见: %@", botReplyList.flight, botReplyList.state, botReplyList.route, botReplyList.starttime, botReplyList.endtime, botReplyList.detailurl];
		}
		else if (code == 302000) {
			text = [NSString stringWithFormat:@"%@\n来源:%@ 详情见: %@", botReplyList.article, botReplyList.source, botReplyList.detailurl];
		}
		else if (code == 308000) {
			text = [NSString stringWithFormat:@"%@\n%@\n详情见: %@", botReplyList.name, botReplyList.info, botReplyList.detailurl];
		}
		NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:text, @"strContent", @(UUMessageTypeText), @"type", nil];
		if (botReplyList.detailurl) {
			[dic setObject:[NSURL URLWithString:botReplyList.detailurl] forKey:@"url"];
		}
		[array addObject:dic];
	}
	return array;
}

#pragma mark - tableView delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return self.chatModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UUMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell"];
	cell.delegate = self;
	[cell setMessageFrame:self.chatModel.dataSource[indexPath.row]];
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return [self.chatModel.dataSource[indexPath.row] cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[self.view endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
	[self.view endEditing:YES];
}

#pragma mark - cellDelegate
- (void)headImageDidClick:(UUMessageCell *)cell userId:(NSString *)userId{
	// headIamgeIcon is clicked
	UIAlertView *alert = [[UIAlertView alloc]initWithTitle:cell.messageFrame.message.strName message:@"headImage clicked" delegate:nil cancelButtonTitle:@"sure" otherButtonTitles:nil];
	[alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
