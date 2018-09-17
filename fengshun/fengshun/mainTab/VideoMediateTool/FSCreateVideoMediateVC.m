//
//  FSCreateVideoMediateVC.m
//  fengshun
//
//  Created by ILLA on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSCreateVideoMediateVC.h"
#import "FSCreateVideoMediateHeader.h"
#import "FSVideoMediatePersonalCell.h"
#import "FSVideoInviteLitigantVC.h"

@interface FSCreateVideoMediateVC ()
<
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic, strong) FSMeetingDetailModel *m_CreateModel;
@property (nonatomic, strong) NSMutableArray *m_AttendedList; // 参与人员列表
@end

@implementation FSCreateVideoMediateVC
@synthesize m_FreshViewType = _m_FreshViewType;

- (void)viewDidLoad {
    _m_FreshViewType = BMFreshViewType_NONE;
    [super viewDidLoad];

    [self bm_setNavigationWithTitle:@"新建视频调解" barTintColor:[UIColor whiteColor] leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];

    self.m_CreateModel = [FSMeetingDetailModel new];
    [self buildUI];
}

-(void)buildUI
{
    UIButton *bottom = [UIButton bm_buttonWithFrame:CGRectMake(0, UI_MAINSCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT - 48, self.view.bm_width, 48)
                                              title:@"确定"];
    bottom.backgroundColor = UI_COLOR_BL1;
    bottom.titleLabel.font = UI_FONT_17;
    [bottom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottom addTarget:self action:@selector(bottomButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottom];
    
    self.m_TableView.frame = CGRectMake(0, 0, self.view.bm_width, UI_MAINSCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT - 48);
    
    FSCreateVideoMediateHeader *header = [[FSCreateVideoMediateHeader alloc] initWithFrame:CGRectMake(0, 0, self.m_TableView.bm_width, 0)];
    self.m_TableView.tableHeaderView = header;
    header.m_Model = _m_CreateModel;

    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.m_TableView.bm_width, 24+44)];
    
    UIButton *btn = [UIButton bm_buttonWithFrame:CGRectMake(0, 0, self.m_TableView.bm_width, 44)];
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.font = UI_FONT_14;
    [btn addTarget:self action:@selector(inviteAction) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:btn];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"+  邀请当事人"
                                                                             attributes:@{NSForegroundColorAttributeName:UI_COLOR_BL1,
                                                                                          NSFontAttributeName:UI_FONT_14
                                                                                          }];
    [attr addAttribute:NSFontAttributeName value:UI_BOLDFONT_18 range:NSMakeRange(0, 1)];
    [btn setAttributedTitle:attr forState:UIControlStateNormal];
    self.m_TableView.tableFooterView = footer;
}

- (NSMutableArray *)m_AttendedList
{
    if (_m_AttendedList == nil) {
        _m_AttendedList = [NSMutableArray array];
        [_m_AttendedList addObject:[FSMeetingPersonnelModel userModel]];
    }
    
    return _m_AttendedList;
}

- (void)inviteAction
{
    FSVideoInviteLitigantVC *vc = [FSVideoInviteLitigantVC new];
    BMWeakSelf
    vc.inviteComplete = ^(NSArray *litigantList) {
        [weakSelf.m_AttendedList addObjectsFromArray:litigantList];
        [weakSelf.m_TableView reloadData];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)bottomButtonClickAction
{
    FSCreateVideoMediateHeader *header = (FSCreateVideoMediateHeader *)self.m_TableView.tableHeaderView;
    if (![header validMeetingInfo]) {
        return;
    }

    if (self.m_AttendedList.count < 2) {
        [self.m_ProgressHUD showAnimated:YES withDetailText:@"请邀请当事人" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        return;
    }
    
    self.m_CreateModel.meetingPersonnelResponseDTO = self.m_AttendedList;
    [self sendSaveMeetingRequest];
}

- (void)sendSaveMeetingRequest
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableURLRequest *request = [FSApiRequest saveMeetingWithInfo:[self.m_CreateModel formToParameters]];
    if (request)
    {
        [self.m_ProgressHUD showAnimated:YES showBackground:NO];
        NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error)
            {
                BMLog(@"Error: %@", error);
                [self.m_ProgressHUD showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_NET_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            }
            else
            {
#if DEBUG
                NSString *responseStr = [[NSString stringWithFormat:@"%@", responseObject] bm_convertUnicode];
                BMLog(@"%@ %@", response, responseStr);
#endif
                [self saveRequestFinished:response responseDic:responseObject];
            }
        }];
        [task resume];
    }
}

- (void)saveRequestFinished:(NSURLResponse *)response responseDic:(NSDictionary *)resDic
{
    if (![resDic bm_isNotEmptyDictionary])
    {
        [self.m_ProgressHUD showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_JSON_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        return;
    }
    
    NSInteger statusCode = [resDic bm_intForKey:@"code"];
    if (statusCode == 1000)
    {
        [self.m_ProgressHUD hideAnimated:NO];
        NSDictionary *dataDic = [resDic bm_dictionaryForKey:@"data"];
        if ([dataDic bm_isNotEmptyDictionary])
        {
            if (self.successBlock) {
                self.successBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    
    NSString *message = [resDic bm_stringTrimForKey:@"message" withDefault:[FSApiRequest publicErrorMessageWithCode:FSAPI_DATA_ERRORCODE]];
    [self.m_ProgressHUD showAnimated:YES withDetailText:message delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
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

#pragma mark -
#pragma mark Table Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_AttendedList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 24;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, self.m_TableView.bm_width-28, 24)];
    label.text = [NSString stringWithFormat:@"参与人员：%@人",@(_m_AttendedList.count)];
    label.textColor = UI_COLOR_B4;
    label.font = UI_FONT_12;
    [view addSubview:label];
    
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"FSVideoMediatePersonalCell";

    FSVideoMediatePersonalCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[FSVideoMediatePersonalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID selectEnable:YES];
    }
    FSMeetingPersonnelModel *model = self.m_AttendedList[indexPath.row];
    [cell setModel:model];
    return cell;
}


@end
