//
//  SingleTextChaHistoryVC.m
//  ODR
//
//  Created by ILLA on 2018/9/10.
//  Copyright © 2018年 DH. All rights reserved.
//

#import "TextChatHistoryViewController.h"
#import "ChatTextView.h"
#import "SocketHelper.h"


@interface TextChatHistoryViewController ()
@property (nonatomic, strong) ChatTextViewModel *viewModel;
@property (nonatomic, assign) NSInteger pageIndex; ///< 第几页
@property (nonatomic, assign) NSInteger pageSize; ///< Default is 10.
@end

@implementation TextChatHistoryViewController

+ (instancetype)ChatTextVCWithMeetingModel:(VideoCallMemberModel *)memberModel {
    TextChatHistoryViewController *vc = [TextChatHistoryViewController new];
    vc.memberModel = memberModel;
    vc.viewModel = [ChatTextViewModel new];
    return vc;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor bm_colorWithHex:0xf6f6f6];
    self.pageIndex = 1;
    self.pageSize = 10;
    if (self.memberModel) {
        [self bm_setNavigationWithTitle:@"对话消息" barTintColor:[UIColor whiteColor] leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];
    } else {
        [self bm_setNavigationWithTitle:@"查看聊天记录" barTintColor:[UIColor whiteColor] leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];
    }

    self.m_TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.m_TableView.backgroundColor = [UIColor whiteColor];
    self.m_TableView.estimatedRowHeight = 100;
    [self.m_TableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessageListNoti:) name:kNotiReceiveHistoryPrivateMessageListName object:nil];
    
    [self freshDataWithTableView:self.m_TableView];
}

- (void)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)freshDataWithTableView:(FSTableView *)tableView {
    if (self.memberModel) {
        [[SocketHelper shareHelper] sentListMessageEvent:self.memberModel.memberId pageIndex:self.pageIndex pageSize:self.pageSize];
    } else {
        [[SocketHelper shareHelper] sentListMessageEvent:nil pageIndex:self.pageIndex pageSize:self.pageSize];
    }
}

- (void)receiveMessageListNoti:(NSNotification *)noti {
    // 判断当前的
    NSLog(@"%@", noti.userInfo);
    
    NSDictionary *dataDic = noti.userInfo[@"data"];
    if (dataDic[@"list"]) {
        NSArray *array = [ChatTextViewModel modelListWithData:dataDic[@"list"]];
        if (array.count) {
            NSInteger oldItem = [_viewModel.showList count];
            [_viewModel.chatList addObjectsFromArray:array];
            [_viewModel formatChatList];
            [_viewModel convertToItemsFromChatList];
            NSInteger newItem = [_viewModel.showList count];

            [self.m_TableView reloadData];

            if (self.pageIndex == 1) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newItem - 1 inSection:0];
                [self.m_TableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            } else {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newItem - oldItem inSection:0];
                [self.m_TableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        }
    }

    if ([dataDic[@"hasNextPage"] boolValue]) {
        self.pageIndex ++;
        [self.m_TableView resetFreshHeaderState];
    } else {
        [self.m_TableView resetFreshHeaderState];
        self.m_TableView.bm_freshHeaderView = nil;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_viewModel.showList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatTextModel *model = _viewModel.showList[indexPath.row];
    NSString *className = model.isOnlyTime ? @"ChatTimeViewCell":@"ChatTextViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:className];
    if (!cell) {
        cell = [[NSClassFromString(className) alloc] initWithStyle:0 reuseIdentifier:className];
    }
    if ([cell respondsToSelector:@selector(setModel:)]) {
        [cell performSelector:@selector(setModel:) withObject:model];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

@end

