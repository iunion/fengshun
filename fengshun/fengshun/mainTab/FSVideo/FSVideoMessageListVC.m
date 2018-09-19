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


- (BOOL)succeedLoadedRequestWithString:(NSString *)requestStr
{
    if ([requestStr bm_isNotEmpty]) {
        UITextView *label = [[UITextView alloc] initWithFrame:CGRectMake(16, 16, UI_SCREEN_WIDTH - 16*2, UI_MAINSCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - 16)];
        label.editable = NO;
        label.textColor = UI_COLOR_B1;
        label.font = UI_FONT_14;
        label.showsVerticalScrollIndicator = NO;
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:requestStr];
        NSRange textRange = NSMakeRange(0, requestStr.length);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentLeft;
        paragraphStyle.lineSpacing = 4.0;
        paragraphStyle.paragraphSpacing = 16;
        [attributedString addAttribute:NSFontAttributeName value:UI_FONT_14 range:textRange];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:textRange];
        
        label.attributedText = attributedString;
        [self.view addSubview:label];
    }

    return YES;
}

@end
