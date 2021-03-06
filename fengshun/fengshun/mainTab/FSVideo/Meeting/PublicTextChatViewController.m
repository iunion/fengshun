//
//  MDTChatTextViewController.m
//  ODR
//
//  Created by DH on 2018/6/1.
//  Copyright © 2018年 DH. All rights reserved.
//

#import "PublicTextChatViewController.h"
#import "ChatTextView.h"
#import "SocketHelper.h"
#import "ChatTextViewModel.h"

@interface PublicTextChatViewController () <ChatTextImportViewDelegate >
@property (nonatomic, strong) ChatTextViewModel *viewModel;
@property (nonatomic, strong) ChatTextImportView *improtView;
@property (nonatomic, strong) MASConstraint *importViewBottomConstaint;
@property (nonatomic, strong) RTCRoomInfoModel *roomInfoModel;
@property (nonatomic, strong) NSString *m_StartId;

@end

@implementation PublicTextChatViewController
@synthesize m_FreshViewType = _m_FreshViewType;

+ (instancetype)vcWithMeetingModel:(RTCRoomInfoModel *)model {
    PublicTextChatViewController *vc = [self new];
    vc.viewModel = [ChatTextViewModel new];
    vc.roomInfoModel = model;
    return vc;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showChat
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.importViewBottomConstaint.offset = 0;
        if (@available(iOS 11.0, *))
        {
            [self.improtView.textView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.offset = -self.view.safeAreaInsets.bottom-6;
            }];
        }

        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (finished) {
            }
        }];
    });
}

- (void)hideChat
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.25 animations:^{
        _importViewBottomConstaint.offset = 300;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    }];
}

- (void)tapedSelf:(id)sender
{
    [self hideChat];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self freshDataWithTableView:self.m_TableView];
    [self showChat];
}

- (void)viewDidLoad
{
    _m_FreshViewType = BMFreshViewType_Head;
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.m_CountPerPage = 10;

    [self buildUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNewMessageNoti:) name:kNotiReceiveNewPublicMessageName object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessageListNoti:) name:kNotiReceiveHistoryPrivateMessageListName object:nil];
}

- (void)buildUI
{
    UIView *getsureView = [UIView new];
    [self.view addSubview:getsureView];
    getsureView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    [getsureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapedSelf:)];
    tapGes.numberOfTapsRequired = 1;
    [getsureView addGestureRecognizer:tapGes];

    [self.view bringSubviewToFront:self.m_TableView];
    
    _improtView = [ChatTextImportView new];
    _improtView.delegate = self;
    [self.view addSubview:_improtView];
    [_improtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        self.importViewBottomConstaint = make.bottom.equalTo(self.view).offset(300);
    }];

    self.m_TableView.estimatedRowHeight = 100;
    self.m_TableView.backgroundColor = [UIColor whiteColor];
    [self.m_TableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(230);
        make.bottom.equalTo(self.improtView.mas_top);
    }];
}

- (void)freshDataWithTableView:(FSTableView *)tableView
{
    [self.m_TableView resetFreshHeaderState];

    [[SocketHelper shareHelper] sentListMessageEvent:nil startId:self.m_StartId pageSize:self.m_CountPerPage];
}

- (void)receiveNewMessageNoti:(NSNotification *)noti {
    NSLog(@"%@",noti.userInfo);
    ChatTextModel *textModel = [ChatTextViewModel chatTextModelWithDict:noti.userInfo[@"data"]];
    if (textModel.receiver == nil) {
        [_viewModel.chatList addObject:textModel];
        [self formatMessages];
        [self.m_TableView reloadData];
        [self dh_scrollToBottomAnimatied:YES];
    }
}

- (void)receiveMessageListNoti:(NSNotification *)noti {
    // 判断当前的
    NSLog(@"%@", noti.userInfo);

    NSDictionary *dataDic = noti.userInfo[@"data"];
    NSArray *array = [ChatTextViewModel modelListWithData:dataDic[@"list"]];
    if (array.count) {
        ChatTextModel *firstItem = array.firstObject;
        if (firstItem.receiver == nil) {
            NSInteger oldItemCount = [_viewModel.showList count];
            [_viewModel.chatList addObjectsFromArray:array];
            [self formatMessages];
            NSInteger newItemCount = [_viewModel.showList count];
            
            [self.m_TableView reloadData];
            
            if (oldItemCount == 0) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newItemCount - 1 inSection:0];
                [self.m_TableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            } else {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newItemCount - oldItemCount inSection:0];
                [self.m_TableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
            
            if (![dataDic[@"hasNextPage"] boolValue]) {
                self.m_TableView.bm_freshHeaderView = nil;
            }
        }
    }
}


/// 将tableView滚动到底部
- (void)dh_scrollToBottomAnimatied:(BOOL)animatied {
    NSInteger count = [self.viewModel.showList count];
    if (!count) return;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:count - 1 inSection:0];
    [self.m_TableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animatied];
}

- (void)formatMessages
{
    [_viewModel formatChatList];
    [_viewModel convertToItemsFromChatList];
    
    if ([_viewModel.chatList bm_isNotEmpty]) {
        ChatTextModel *firstItem = _viewModel.chatList.firstObject;
        self.m_StartId = firstItem.messageId;
    }
}

#pragma mark - ChatTextImportViewDelegate
- (void)importView:(ChatTextImportView *)importView keyboardFrameDidChangeWithDistanceRelativeBottom:(CGFloat)distance
{
    [UIView animateWithDuration:0.25 animations:^{
        
        if (@available(iOS 11.0, *))
        {
            if (distance > 0)
            {
                [self.improtView.textView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.offset = -6;
                }];
            }
            else
            {
                [self.improtView.textView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.offset = -self.view.safeAreaInsets.bottom-6;
                }];
            }
        }
        
        _importViewBottomConstaint.offset = -distance;
        [self.view layoutIfNeeded];
    }];
    [self dh_scrollToBottomAnimatied:NO];
}

- (void)importView:(ChatTextImportView *)importView senderBtnDidClick:(NSString *)content {
    if (content.length)
    {
        [[SocketHelper shareHelper] sentTextMessageEvent:content receiverId:nil isVoice:NO];
    }
}

#pragma mark - scorllView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tracking) {
        [self.view endEditing:YES];
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

