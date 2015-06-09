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

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	[[self tableView] registerClass:[UUMessageCell class] forCellReuseIdentifier:@"ChatCell"];
	[self initBar];
//	[self addRefreshViews];
	[self loadBaseViewsAndData];
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
	
	NSLog(@"%@", dic[@"strContent"]);
	
	[DownloadData getReplyDataWithBlock:^(BotReply *data, NSError *error) {
		NSDictionary *replyDic =  [self dealTheReplyToDic:data];
		[self.chatModel addChatRecordFromBot:replyDic];
		[self.tableView reloadData];
		[self tableViewScrollToBottom];
		
		if ([data.code integerValue] == 200000) {
			dispatch_queue_t queue = dispatch_queue_create("com.kyonli.openUrl", DISPATCH_QUEUE_SERIAL);
			dispatch_async(queue, ^{
				sleep(2);
				dispatch_async(dispatch_get_main_queue(), ^{
					[[UIApplication sharedApplication] openURL:[NSURL URLWithString:data.url]];
				});
			});
		}
	} inputStr:dic[@"strContent"]];
}

- (NSDictionary *)dealTheReplyToDic:(BotReply *)data {
	BotReplyList *botReplyList = [data.dataList firstObject];
	NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:data.text, @"strContent", @(UUMessageTypeText), @"type", nil];
	if (botReplyList && botReplyList.detailurl) {
		[dic addEntriesFromDictionary:@{@"url":[NSURL URLWithString:botReplyList.detailurl]}];
	}
	if ([data.code integerValue] == 200000) {
		[dic addEntriesFromDictionary:@{@"url":[NSURL URLWithString:data.url]}];
	}
	return dic;
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
