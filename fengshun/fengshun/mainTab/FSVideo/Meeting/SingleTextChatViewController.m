//
//  SingleChatTextViewController.m
//  ODR
//
//  Created by DH on 2017/11/9.
//  Copyright © 2017年 DH. All rights reserved.
//

#import "SingleTextChatViewController.h"
#import "ChatTextView.h"
#import "SocketHelper.h"

@interface SingleTextChatViewController () <ChatTextImportViewDelegate>
@property (nonatomic, strong) ChatTextImportView *improtView;
@property (nonatomic, strong) MASConstraint *importViewBottomConstaint;
@property (nonatomic, strong) VideoCallMemberModel *memberModel;
@property (nonatomic, strong) ChatTextViewModel *viewModel;
@property (nonatomic, strong) NSString *m_StartId;
@end

@implementation SingleTextChatViewController
@synthesize m_FreshViewType = _m_FreshViewType;

+ (instancetype)singleChatTextVCWithMeetingModel:(VideoCallMemberModel *)memberModel {
    SingleTextChatViewController *vc = [SingleTextChatViewController new];
    vc.memberModel = memberModel;
    vc.viewModel = [ChatTextViewModel new];
    return vc;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.delegate respondsToSelector:@selector(finishPriviteSessionModel:)])
    {
        [self.delegate finishPriviteSessionModel:self.memberModel];
    }
}

- (void)viewDidLoad {
    _m_FreshViewType = BMFreshViewType_Head;
    [super viewDidLoad];

    self.m_CountPerPage = 10;
    [self setNavTitle];
    [self buildUI];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNewMessageNoti:) name:kNotiReceiveNewPrivateMessageName object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessageListNoti:) name:kNotiReceiveHistoryPrivateMessageListName object:nil];
}

- (void)freshDataWithTableView:(FSTableView *)tableView
{
    [self.m_TableView resetFreshHeaderState];

    [[SocketHelper shareHelper] sentListMessageEvent:self.memberModel.memberId startId:self.m_StartId pageSize:self.m_CountPerPage];
}

-(void)viewSafeAreaInsetsDidChange
{
    [super viewSafeAreaInsetsDidChange];

    if (@available(iOS 11.0, *))
    {
        [self.improtView.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset = -self.view.safeAreaInsets.bottom-6;
        }];

        [self.view layoutIfNeeded];
    }
}

- (void)setNavTitle
{
    NSString *title = [NSString stringWithFormat:@"与%@私密聊天中...",self.memberModel.memberName];
    self.bm_NavigationShadowHidden = NO;
    self.bm_NavigationShadowColor = UI_COLOR_B6;
    [self bm_setNavigationWithTitle:title barTintColor:[UIColor whiteColor] leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];
}

- (void)buildUI
{
    [self.view bringSubviewToFront:self.m_TableView];
    
    _improtView = [ChatTextImportView new];
    _improtView.delegate = self;
    [self.view addSubview:_improtView];
    [_improtView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.importViewBottomConstaint = make.bottom.equalTo(self.view).offset(0);
        make.left.right.equalTo(self.view);
    }];

    self.m_TableView.backgroundColor = [UIColor whiteColor];
    self.m_TableView.estimatedRowHeight = 100;
    self.m_TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.m_TableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.improtView.mas_top);
    }];
}

- (void)receiveNewMessageNoti:(NSNotification *)noti {
    // 判断当前的
    NSLog(@"%@", noti.userInfo);
    ChatTextModel *textModel = [ChatTextViewModel chatTextModelWithDict:noti.userInfo[@"data"]];
    if ([textModel.sender.memberId isEqualToString:self.memberModel.memberId] ||
        [textModel.receiver.memberId isEqualToString:self.memberModel.memberId]) {
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
        if ([firstItem.sender.memberId isEqualToString:self.memberModel.memberId] ||
            [firstItem.receiver.memberId isEqualToString:self.memberModel.memberId]) {
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

- (void)formatMessages
{
    [_viewModel formatChatList];
    [_viewModel convertToItemsFromChatList];
    
    if ([_viewModel.chatList bm_isNotEmpty]) {
        ChatTextModel *firstItem = _viewModel.chatList.firstObject;
        self.m_StartId = firstItem.messageId;
    }
}

/// 将tableView滚动到底部
- (void)dh_scrollToBottomAnimatied:(BOOL)animatied {
    NSInteger count = [_viewModel.showList count];
    if (!count) return;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:count - 1 inSection:0];
    [self.m_TableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animatied];
}

#pragma mark - ChatTextImportViewDelegate
- (void)importView:(ChatTextImportView *)importView keyboardFrameDidChangeWithDistanceRelativeBottom:(CGFloat)distance {
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

        _importViewBottomConstaint.offset = - distance;
        [self.view layoutIfNeeded];
    }];
    [self dh_scrollToBottomAnimatied:NO];
}

- (void)importView:(ChatTextImportView *)importView senderBtnDidClick:(NSString *)content {
    if (content.length)
    {
        [[SocketHelper shareHelper] sentTextMessageEvent:content receiverId:self.memberModel.memberId isVoice:NO];
    }
}

#pragma mark - 屏幕触摸事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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

