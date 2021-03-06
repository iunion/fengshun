//
//  FSTableViewVC.m
//  fengshun
//
//  Created by jiang deng on 2018/8/27.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSTableViewVC.h"
#import "FSCoreStatus.h"

#define DEFAULT_COUNTPERPAGE    20

@interface FSTableViewVC ()

@property (nonatomic, strong) FSTableView *m_TableView;


// 内容数据
//@property (nonatomic, strong) NSMutableArray *m_DataArray;

// 是否下拉刷新
@property (nonatomic, assign) BOOL m_IsLoadNew;

@end

@implementation FSTableViewVC

- (void)dealloc
{
    [_m_DataTask cancel];
    _m_DataTask = nil;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil freshViewType:BMFreshViewType_ALL];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil freshViewType:(BMFreshViewType)freshViewType
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _m_CountPerPage = DEFAULT_COUNTPERPAGE;
        _m_FreshViewType = freshViewType;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    s_IsNoMorePage = NO;
    
    self.m_TableView = [[FSTableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_MAINSCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT) style:self.m_TableViewStyle freshViewType:self.m_FreshViewType];
    self.m_TableView.backgroundColor = [UIColor clearColor];
    
    self.m_TableView.dataSource = self;
    self.m_TableView.delegate = self;
    self.m_TableView.tableViewDelegate = self;
    
    [self.view addSubview:self.m_TableView];
    
    self.m_DataArray = [NSMutableArray arrayWithCapacity:0];
    
    self.m_showEmptyView = YES;
    
    [self.m_TableView hideEmptyView];
    
    [self bringSomeViewToFront];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)m_showEmptyView
{
    return self.m_TableView.bm_showEmptyView;
}

- (void)setM_showEmptyView:(BOOL)showEmptyView
{
    self.m_TableView.bm_showEmptyView = showEmptyView;
}

- (void)bringSomeViewToFront
{
    [self.m_TableView bringSomeViewToFront];

    [super bringSomeViewToFront];    
}

- (void)setFreshTitles:(NSDictionary *)titles
{
    [self.m_TableView setFreshTitles:titles];
}

- (void)setHeaderFreshTitles:(NSDictionary *)titles
{
    [self.m_TableView setHeaderFreshTitles:titles];
}

- (void)setFooterFreshTitles:(NSDictionary *)titles
{
    [self.m_TableView setFooterFreshTitles:titles];
}

- (void)showEmptyViewWithType:(BMEmptyViewType)type
{
    BMWeakSelf
    [self showEmptyViewWithType:type action:^(BMEmptyView *emptyView, BMEmptyViewType state) {
        [weakSelf loadApiData];
    }];
}

- (void)showEmptyViewWithType:(BMEmptyViewType)type action:(BMEmptyViewActionBlock)actionBlock
{
    [self showEmptyViewWithType:type customImageName:nil customMessage:nil customView:nil action:actionBlock];
}

- (void)showEmptyViewWithType:(BMEmptyViewType)type customImageName:(NSString *)customImageName customMessage:(NSString *)customMessage customView:(UIView *)customView
{
    BMWeakSelf
    [self showEmptyViewWithType:type customImageName:customImageName customMessage:customMessage customView:customView action:^(BMEmptyView *emptyView, BMEmptyViewType state) {
        [weakSelf loadApiData];
    }];
}

- (void)showEmptyViewWithType:(BMEmptyViewType)type customImageName:(NSString *)customImageName customMessage:(NSString *)customMessage customView:(UIView *)customView action:(BMEmptyViewActionBlock)actionBlock
{
    if (!self.m_showEmptyView)
    {
        return;
    }
    
    if (type == BMEmptyViewType_SysError)
    {
        [self.m_TableView showEmptyViewWithType:type action:actionBlock];
        return;
    }
    
    if (![self.m_DataArray bm_isNotEmpty])
    {
        if (type == BMEmptyViewType_NetworkError)
        {
            if ([FSCoreStatus currentNetWorkStatus] == FSCoreNetWorkStatusNone)
            {
                [self.m_TableView showEmptyViewWithType:BMEmptyViewType_NetworkError action:actionBlock];
            }
            else
            {
                [self.m_TableView showEmptyViewWithType:BMEmptyViewType_ServerError action:actionBlock];
            }
        }
        else
        {
            [self.m_TableView showEmptyViewWithType:type customImageName:customImageName customMessage:customMessage customView:customView action:actionBlock];
        }
    }
    else
    {
        [self.m_TableView hideEmptyView];
    }
}

- (void)setEmptyViewActionBlock:(BMEmptyViewActionBlock)actionBlock
{
    [self.m_TableView setEmptyViewActionBlock:actionBlock];
}

- (void)hideEmptyView
{
    [self.m_TableView hideEmptyView];
}

- (BMEmptyViewType)getNoDataEmptyViewType
{
    return BMEmptyViewType_NoData;
}

- (NSString *)getNoDataEmptyViewCustomImageName
{
    return nil;
}

- (NSString *)getNoDataEmptyViewCustomMessage
{
    return nil;
}

- (UIView *)getNoDataEmptyViewCustomView
{
    return nil;
}


#pragma mark -
#pragma mark Table Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_DataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *taskCellIdentifier = @"FSCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:taskCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:taskCellIdentifier];
    }
    cell.backgroundColor = FS_VIEW_BGCOLOR;
    
//    if (cell == nil)
//    {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"FSCell" owner:self options:nil] lastObject];
//    }
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    cell.selectedBackgroundView.backgroundColor = [UIColor bm_colorWithHex:0xEEEEEE];
    
    return cell;
}


#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark -
#pragma mark FSTableViewDelegate

- (void)freshDataWithTableView:(FSTableView *)tableView
{
    [self loadApiData];
}

- (void)loadNextDataWithTableView:(FSTableView *)tableView
{
    [self loadNextApiData];
}

- (void)tableViewFreshFromNoDataView:(FSTableView *)tableView
{
    [self loadApiData];
}

- (void)resetTableViewFreshState:(BMFreshBaseView *)freshView;
{
    BMLog(@"resetTableViewFreshState");
    [self loadDateFinished:(freshView.freshState == BMFreshStateNoMoreData)];
}

#pragma mark -
#pragma mark FSSuperNetVCProtocol

// 刷新数据
- (BOOL)canLoadApiData
{
    return [super canLoadApiData];
}

- (void)loadApiData
{
    self.m_IsLoadNew = YES;
    
    [self loadNextApiData];
}

 // 获取下一页
- (void)loadNextApiData
{
    if (![self canLoadApiData])
    {
        if (self.m_IsLoadNew)
        {
            [self.m_TableView resetFreshHeaderState];
        }
        else
        {
            [self.m_TableView resetFreshFooterStateWithNoMoreData];
        }
        
        self.m_IsLoadNew = NO;
        
        return;
    }
    
    if (self.m_LoadDataType == FSAPILoadDataType_Page)
    {
        if (self.m_IsLoadNew)
        {
            s_LoadedPage = 1;
            s_BakLoadedPage = 1;
        }
        else
        {
            if (s_IsNoMorePage)
            {
                [self.m_TableView resetFreshFooterStateWithNoMoreData];

                self.m_IsLoadNew = NO;
                
                return;
            }
            
            s_BakLoadedPage = s_LoadedPage + 1;
        }
    }
    
    if (self.m_ShowProgressHUD)
    {
#if (PROGRESSHUD_UESGIF)
        [self.m_ProgressHUD showWait:YES backgroundColor:nil text:nil useHMGif:YES];
#else
        [self.m_ProgressHUD showAnimated:YES showBackground:NO];
#endif
    }
    
    [self hideEmptyView];
    
    [self.m_DataTask cancel];
    self.m_DataTask = nil;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableURLRequest *request = [self setLoadDataRequest];
    if (!request)
    {
        request = [self setLoadDataRequestWithFresh:self.m_IsLoadNew];
    }
    
    //BMLog(@"absoluteURL1: %@", request.URL.absoluteURL);
    if (self.m_DataTask)
    {
        request = nil;
    }
    
    if (request)
    {
        BMWeakSelf
        self.m_DataTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            //LLog(@"absoluteURL2: %@", response.URL.absoluteURL);
            if (error)
            {
                BMLog(@"Error: %@", error);
                [weakSelf loadDataResponseFailed:response error:error];
                
            }
            else
            {
#ifdef DEBUG
                NSString *responseStr = [NSString stringWithFormat:@"%@", responseObject];
                if (responseStr.length <= 2048) {
                    responseStr = [responseStr bm_convertUnicode];
                    BMLog(@"%@ %@", response, responseStr);
                }
#endif
                [weakSelf loadDataResponseFinished:response responseDic:responseObject];
            }
            weakSelf.m_DataTask = nil;
        }];
        [self.m_DataTask resume];
    }
    else
    {
        if (self.m_IsLoadNew)
        {
            [self.m_TableView resetFreshHeaderState];
        }
        else
        {
            [self.m_TableView resetFreshFooterStateWithNoMoreData];
        }
        
        self.m_IsLoadNew = NO;
        
        [self.m_ProgressHUD hideAnimated:YES];
    }
}

// 设置具体的API请求
- (NSMutableURLRequest *)setLoadDataRequest
{
    // 无用
    return nil;
}

- (NSMutableURLRequest *)setLoadDataRequestWithFresh:(BOOL)isLoadNew
{
    return nil;
}

// API请求成功的代理方法
- (void)loadDataResponseFinished:(NSURLResponse *)response responseDic:(NSDictionary *)responseDic
{
    if (!self.m_ShowResultHUD)
    {
        [self.m_ProgressHUD hideAnimated:NO];
    }
    
    if (![responseDic bm_isNotEmptyDictionary])
    {
        [self failLoadedResponse:response responseDic:responseDic withErrorCode:FSAPI_JSON_ERRORCODE];
        
        if (self.m_ShowResultHUD)
        {
            [self.m_ProgressHUD showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_JSON_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        }
        
        [self showEmptyViewWithType:BMEmptyViewType_DataError];
        self.m_IsLoadNew = NO;

        return;
    }

//#ifdef DEBUG
//    // 上面打印过了，此处打印重复
//    NSString *responseStr = [[NSString stringWithFormat:@"%@", responseDic] bm_convertUnicode];
//    BMLog(@"API返回数据是:+++++%@", responseStr);
//#endif

    NSInteger statusCode = [responseDic bm_intForKey:@"code"];
    if (statusCode == 1000)
    {
        if (self.m_ShowResultHUD)
        {
            [self.m_ProgressHUD hideAnimated:NO];
        }
        
        BOOL succeed = NO;
        
        NSDictionary *dataDic = [responseDic bm_dictionaryForKey:@"data"];
        succeed = [self succeedLoadedRequestWithDic:dataDic];
        NSArray *dataArray = nil;
        if (!succeed)
        {
            dataArray = [responseDic bm_arrayForKey:@"data"];
            succeed = [self succeedLoadedRequestWithArray:dataArray];
            if (!succeed)
            {
                NSString *dataStr = [responseDic bm_stringTrimForKey:@"data"];
                succeed = [self succeedLoadedRequestWithString:dataStr];
            }
        }
        
        if (succeed)
        {
            [self.m_TableView resetFreshHeaderState];

            if (self.m_LoadDataType == FSAPILoadDataType_Page)
            {
                if ([self checkLoadFinish:dataDic])
                {
                    [self.m_TableView resetFreshFooterStateWithNoMoreData];
                }
                else
                {
                    [self.m_TableView resetFreshFooterState];
                }
            }
            else if (self.m_LoadDataType == FSAPILoadDataType_Count)
            {
                //
            }

            [self showEmptyViewWithType:[self getNoDataEmptyViewType] customImageName:[self getNoDataEmptyViewCustomImageName] customMessage:[self getNoDataEmptyViewCustomMessage] customView:[self getNoDataEmptyViewCustomView]];
            
            // 无数据时隐藏上拉
            if (self.m_IsLoadNew)
            {
                if ([self.m_DataArray bm_isNotEmpty])
                {
                    self.m_TableView.bm_freshFooterView.hidden = NO;
                }
                else
                {
                    self.m_TableView.bm_freshFooterView.hidden = YES;
                }
            }
            self.m_IsLoadNew = NO;
            
            return;
        }
        
        if (![dataDic bm_isNotEmptyDictionary] && ![dataArray bm_isNotEmpty])
        {
            // 允许"data"为空
            if (self.m_AllowEmptyJson)
            {
                [self.m_TableView resetFreshHeaderState];
                [self.m_TableView resetFreshFooterState];
                
                self.m_IsLoadNew = NO;
                
                return;
            }
        }
        
        [self failLoadedResponse:response responseDic:responseDic withErrorCode:FSAPI_DATA_ERRORCODE];
        
        // StateError
        [self.m_TableView resetFreshHeaderState];
        [self.m_TableView resetFreshFooterState];

        if (self.m_ShowResultHUD)
        {
            [self.m_ProgressHUD showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_DATA_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        }
        
        [self showEmptyViewWithType:BMEmptyViewType_DataError];
        self.m_IsLoadNew = NO;
    }
    else
    {
        [self failLoadedResponse:response responseDic:responseDic withErrorCode:statusCode];
        
        NSString *message = [responseDic bm_stringTrimForKey:@"message" withDefault:[FSApiRequest publicErrorMessageWithCode:FSAPI_DATA_ERRORCODE]];
        if ([self checkRequestStatus:statusCode message:message responseDic:responseDic logOutQuit:YES showLogin:YES])
        {
            [self.m_ProgressHUD hideAnimated:YES];
        }
        else if (self.m_ShowResultHUD)
        {
#ifdef DEBUG
            [self.m_ProgressHUD showAnimated:YES withDetailText:[NSString stringWithFormat:@"%@:%@", @(statusCode), message] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
#else
            [self.m_ProgressHUD showAnimated:YES withDetailText:message delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
#endif
        }

        // StateError
        [self.m_TableView resetFreshHeaderState];
        [self.m_TableView resetFreshFooterState];
        
        [self showEmptyViewWithType:BMEmptyViewType_DataError];

        self.m_IsLoadNew = NO;
    }
}

- (BOOL)checkRequestStatus:(NSInteger)statusCode message:(NSString *)message responseDic:(NSDictionary *)responseDic logOutQuit:(BOOL)quit showLogin:(BOOL)show
{
    switch (statusCode)
    {
        case 1000:
            break;
            
        default:
            [self showEmptyViewWithType:BMEmptyViewType_DataError];
            break;
    }
    
    return [super checkRequestStatus:statusCode message:message responseDic:responseDic logOutQuit:quit showLogin:show];
}

// API请求失败的代理方法，一般不需要重写
- (void)loadDataResponseFailed:(NSURLResponse *)response error:(NSError *)error
{
    [super loadDataResponseFailed:response error:error];
    
    [self.m_TableView resetFreshHeaderState];
    [self.m_TableView resetFreshFooterState];
    
    [self showEmptyViewWithType:BMEmptyViewType_NetworkError];
    self.m_IsLoadNew = NO;
}

// 处理成功的数据使用succeedLoadedRequestWithDic:
- (BOOL)succeedLoadedRequestWithDic:(NSDictionary *)requestDic
{
    return [super succeedLoadedRequestWithDic:requestDic];
}

- (BOOL)succeedLoadedRequestWithArray:(NSArray *)requestArray
{
    return [super succeedLoadedRequestWithArray:requestArray];
}

- (BOOL)succeedLoadedRequestWithString:(NSString *)requestStr
{
    return [super succeedLoadedRequestWithString:requestStr];
}

// 全部失败情况适用
- (void)failLoadedResponse:(NSURLResponse *)response responseDic:(NSDictionary *)responseDic withErrorCode:(NSInteger)errorCode
{
    return;
}
 
// 全部获取数据判断
- (BOOL)checkLoadFinish:(NSDictionary *)requestDic
{
    if (self.m_IsLoadNew)
    {
        s_IsNoMorePage = NO;
    }
    
//    hasNextPage = 0;
//    hasPreviousPage = 0;
//    lastPage = 1;
//    pageIndex = 1;
//    pageSize = 10;
//    totalPages = 1;
//    startRow = 0;
//    totalRows = 10;
//    endRow = 9;

    if ([requestDic bm_isNotEmptyDictionary])
    {
        NSDictionary *pageDic = requestDic;//[requestDic bm_dictionaryForKey:@"pageInfo"];
        
        //if ([pageDic bm_isNotEmptyDictionary])
        {
            // 总记录数:  totalRows
            NSUInteger totalcount = [pageDic bm_uintForKey:@"totalRows"];
            // 每页记录数: pageSize
            //NSUInteger pageSize = [pageDic bm_uintForKey:@"pageSize"];
            // 当前页码: pageIndex
            NSUInteger curPageNo = [pageDic bm_uintForKey:@"pageIndex"];
            //总页码: totalPages
            NSUInteger totalPage = [pageDic bm_uintForKey:@"totalPages"];
            
            if (self.m_CountPerPage != 0 && totalcount != 0)
            {
                //s_LoadedPage = s_BakLoadedPage;
                s_LoadedPage = curPageNo;
                
                // totalRecord/pageSize + 1;
                s_TotalPage = totalPage;
                
                if (s_TotalPage <= s_LoadedPage)
                {
                    s_IsNoMorePage = YES;
                    return YES;
                }
            }
            else if (totalcount == 0)
            {
                s_IsNoMorePage = YES;
                return YES;
            }
        }
    }
    
    return NO;
}
 
- (void)loadDateFinished:(BOOL)isNoMoreData
{
    
}

@end
