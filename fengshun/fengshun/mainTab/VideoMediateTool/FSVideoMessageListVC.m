//
//  FSVideoMessageListVC.m
//  fengshun
//
//  Created by ILLA on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSVideoMessageListVC.h"

@implementation FSVideoMessageListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self bm_setNavigationWithTitle:@"消息记录" barTintColor:[UIColor whiteColor] leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];

    [self loadApiData];
}

- (NSMutableURLRequest *)setLoadDataRequest
{
    return [FSApiRequest getRoomMessageRecordList:self.roomId];
}

- (void)succeedLoadedRequestWithString:(NSString *)content
{
    if ([content bm_isNotEmpty]) {
        UITextView *label = [[UITextView alloc] initWithFrame:CGRectMake(16, 16, UI_SCREEN_WIDTH - 16*2, UI_MAINSCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - 16)];
        label.editable = NO;
        label.textColor = UI_COLOR_B1;
        label.font = UI_FONT_14;
        label.showsVerticalScrollIndicator = NO;
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
        NSRange textRange = NSMakeRange(0, content.length);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentLeft;
        paragraphStyle.lineSpacing = 4.0;
        paragraphStyle.paragraphSpacing = 16;
        [attributedString addAttribute:NSFontAttributeName value:UI_FONT_14 range:textRange];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:textRange];

        label.attributedText = attributedString;
        [self.view addSubview:label];
    }
}

- (void)loadDataResponseFinished:(NSURLResponse *)response responseDic:(NSDictionary *)responseDic
{
    [self.m_ProgressHUD hideAnimated:NO];

    if (![responseDic bm_isNotEmptyDictionary])
    {
        [self failLoadedResponse:response responseDic:responseDic withErrorCode:FSAPI_JSON_ERRORCODE];
        
        if (self.m_ShowResultHUD)
        {
            [self.m_ProgressHUD showAnimated:YES withDetailText:[FSApiRequest publicErrorMessageWithCode:FSAPI_JSON_ERRORCODE] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        }
        
        return;
    }
    
#if DEBUG
    NSString *responseStr = [[NSString stringWithFormat:@"%@", responseDic] bm_convertUnicode];
    BMLog(@"API返回数据是:+++++%@", responseStr);
#endif
    
    NSInteger statusCode = [responseDic bm_intForKey:@"code"];
    if (statusCode == 1000)
    {
        [self succeedLoadedRequestWithString:[responseDic bm_stringForKey:@"data"]];

        return;
    }
    else
    {
        [self failLoadedResponse:response responseDic:responseDic withErrorCode:statusCode];
        
        NSString *message = [responseDic bm_stringTrimForKey:@"message" withDefault:[FSApiRequest publicErrorMessageWithCode:FSAPI_DATA_ERRORCODE]];
        if ([self checkRequestStatus:statusCode message:message responseDic:responseDic])
        {
            [self.m_ProgressHUD hideAnimated:YES];
        }
        else if (self.m_ShowResultHUD)
        {
#if DEBUG
            [self.m_ProgressHUD showAnimated:YES withDetailText:[NSString stringWithFormat:@"%@:%@", @(statusCode), message] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
#else
            [self.m_ProgressHUD showAnimated:YES withDetailText:message delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
#endif
        }
    }
}

@end
