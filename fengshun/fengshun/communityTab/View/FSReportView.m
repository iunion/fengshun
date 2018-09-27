//
//  FSReportView.m
//  fengshun
//
//  Created by best2wa on 2018/9/19.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSReportView.h"

@interface FSReportView()

@property (nonatomic, strong)UIView *m_AlertView;

@property (nonatomic, strong)NSMutableArray *m_TitleArray;

@end

@implementation FSReportView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (void)showReportView:(id<FSReportViewDelegate>)delegate
{
    FSReportView *aView = [[FSReportView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT) btnTitleArr:@[@"举报"] cancelTitle:@"取消"];
    aView.delegate = delegate;
    [[UIApplication sharedApplication].keyWindow addSubview:aView];
}

- (instancetype)initWithFrame:(CGRect)frame btnTitleArr:(NSArray *)btnTitleArr cancelTitle:(NSString *)cancelTitle
{
    if (self = [super initWithFrame:frame])
    {
        self.m_TitleArray = [NSMutableArray arrayWithArray:btnTitleArr];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        // 每个按钮高度
        CGFloat btnHeight = 47.f;
        //
        self.m_AlertView = [[UIView alloc]initWithFrame:CGRectMake(0, self.bm_height, self.bm_width, btnHeight* (btnTitleArr.count + 1) + UI_HOME_INDICATOR_HEIGHT)];
        self.m_AlertView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.m_AlertView];
        // 初始化按钮
        for (int i = 0; i < btnTitleArr.count + 1; i ++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(0, i*btnHeight, self.bm_width, btnHeight)];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            btn.tag = 100 + i;
            [self.m_AlertView addSubview:btn];
            
            if (i == (btnTitleArr.count))// 取消按钮
            {
                [btn setTitle:cancelTitle forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor bm_colorWithHex:0x999999] forState:UIControlStateNormal];
            }
            else
            {
                [btn setTitle:btnTitleArr[i] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor bm_colorWithHex:0x333333] forState:UIControlStateNormal];
                // 分割线
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, (i+1)*btnHeight - 0.5f, self.bm_width, 1)];
                line.backgroundColor = [UIColor bm_colorWithHex:0xF6F6F6];
                [self.m_AlertView addSubview:line];
            }
            [btn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self showAnimation];
    }
    return self;
}

- (void)btnClickAction:(UIButton *)sender
{
    if ((sender.tag - 100) == self.m_TitleArray.count)// 取消按钮
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(cancelAlertView:)])
        {
            [self.delegate cancelAlertView:self];
        }
        [self removeFromSuperview];
    }
    else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewClick:index:)])
        {
            [self.delegate alertViewClick:self index:sender.tag - 100];
        }
    }
}

- (void)showAnimation
{
    [UIView animateWithDuration:DEFAULT_DELAY_TIME animations:^{
        self.m_AlertView.bm_top = self.bm_height - self.m_AlertView.bm_height;
    } completion:^(BOOL finished) {
        
    }];
}

@end
