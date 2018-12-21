//
//  FSMessageListVC.m
//  fengshun
//
//  Created by jiang deng on 2018/9/15.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSMessageListVC.h"

#import "FSCommentMessageCell.h"
#import "FSNoticeMessageCell.h"

@interface FSMessageListVC ()

@property (nonatomic, assign) FSMessageType m_MessageType;

@end

@implementation FSMessageListVC

- (instancetype)initWithMessageType:(FSMessageType)messageType
{
    self = [super init];
    if (self)
    {
        self.m_MessageType = messageType;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.m_LoadDataType = FSAPILoadDataType_Page;
    
    [self loadApiData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableURLRequest *)setLoadDataRequestWithFresh:(BOOL)isLoadNew
{
    switch (self.m_MessageType)
    {
        case FSMessageType_COMMENT:
            return [FSApiRequest getUserCommentMessagesWithPageIndex:s_BakLoadedPage pageSize:self.m_CountPerPage];

        case FSMessageType_NOTICE:
            return [FSApiRequest getUserNoticeMessagesWithPageIndex:s_BakLoadedPage pageSize:self.m_CountPerPage];
    }
    
    return nil;
}


- (BOOL)succeedLoadedRequestWithDic:(NSDictionary *)requestDic
{
    NSArray *messageDicArray = [requestDic bm_arrayForKey:@"list"];
    if ([messageDicArray bm_isNotEmpty])
    {
        NSMutableArray *messageArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (NSDictionary *dic in messageDicArray)
        {
            switch (self.m_MessageType)
            {
                case FSMessageType_COMMENT:
                {
                    FSCommentMessageModel *message = [FSCommentMessageModel commentMessageModelWithServerDic:dic];
                    if ([message bm_isNotEmpty])
                    {
                        [messageArray addObject:message];
                    }
                }
                    break;

                case FSMessageType_NOTICE:
                {
                    FSNoticeMessageModel *message = [FSNoticeMessageModel noticeMessageModelWithServerDic:dic];
                    if ([message bm_isNotEmpty])
                    {
                        [messageArray addObject:message];
                    }
                }
                    break;
            }
        }
        if ([messageArray bm_isNotEmpty])
        {
            if (self.m_IsLoadNew)
            {
                [self.m_DataArray removeAllObjects];
            }
            [self.m_DataArray addObjectsFromArray:messageArray];
            [self.m_TableView reloadData];
        }
    }
    
    return YES;
}


#pragma mark -
#pragma mark Table Data Source Methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.m_MessageType)
    {
        case FSMessageType_COMMENT:
            return [FSCommentMessageCell cellHeight];
            
        case FSMessageType_NOTICE:
            return [FSNoticeMessageCell cellHeight];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *taskCellIdentifier;
    
    switch (self.m_MessageType)
    {
        case FSMessageType_COMMENT:
        {
            taskCellIdentifier = @"FSCommentMessageCell";
            FSCommentMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:taskCellIdentifier];
            
            if (cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"FSCommentMessageCell" owner:self options:nil] lastObject];
            }
            
            [cell drawCellWithModel:self.m_DataArray[indexPath.row]];
            
            return cell;
        }
            
        case FSMessageType_NOTICE:
        {
            taskCellIdentifier = @"FSNoticeMessageCell";
            FSNoticeMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:taskCellIdentifier];
            
            if (cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"FSNoticeMessageCell" owner:self options:nil] lastObject];
            }
            
            [cell drawCellWithModel:self.m_DataArray[indexPath.row]];
            
            return cell;
        }
    }
    
    return nil;
}


#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (self.m_MessageType)
    {
        case FSMessageType_COMMENT:
        {
            FSCommentMessageModel *model = self.m_DataArray[indexPath.row];
            
            //if (model.m_JumpType == FSJumpType_H5)
            {
                [FSPushVCManager showWebView:self.m_PushVC url:model.m_JumpAddress title:nil];
                
            }
        }
            
        case FSMessageType_NOTICE:
        {
            FSNoticeMessageModel *model = self.m_DataArray[indexPath.row];
            
            //if (model.m_JumpType == FSJumpType_H5)
            {
                [FSPushVCManager showWebView:self.m_PushVC url:model.m_JumpAddress title:nil];
            }
        }
    }
}

@end
