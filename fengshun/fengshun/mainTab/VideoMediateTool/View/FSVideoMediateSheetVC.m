//
//  FSVideoMediateSheetVC.m
//  fengshun
//
//  Created by ILLA on 2018/9/13.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSVideoMediateSheetVC.h"

#define BUTTON_TAG_OFFSET 100

@interface FSVideoMediateSheetVC ()
@property (nonatomic, strong) NSArray *m_TitleArray;
@property (nonatomic, strong) UIView *m_ContentView;
@end

@implementation FSVideoMediateSheetVC

- (instancetype)initWithTitleArray:(NSArray *)titles
{
    self = [super init];
    
    if (self) {
        self.m_TitleArray = titles;
    }
    
    return self;
}

- (instancetype)initWithTitleArray:(NSArray *)titles block:(FSVideoMediateActionSheetDoneBlock)block
{
    self = [self initWithTitleArray:titles];
    
    self.m_ActionSheetDoneBlock = block;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    UIView *getsureView = [UIView new];
    [self.view addSubview:getsureView];
    getsureView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    [getsureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapedSelf:)];
    tapGes.numberOfTapsRequired = 1;
    [getsureView addGestureRecognizer:tapGes];
    
    [self buildUI];
}

- (void)buildUI
{
    NSInteger count = _m_TitleArray.count + 1;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bm_bottom, self.view.bm_width, 48*count+9)];
    contentView.backgroundColor = UI_COLOR_G2;
    [self.view addSubview:contentView];
    self.m_ContentView = contentView;
    
    NSInteger index = 0;
    for (NSString *title in _m_TitleArray) {
        UIButton *btn = [self buttonWithFrame:CGRectMake(0, 48*index, contentView.bm_width, 48) Title:title];
        [contentView addSubview:btn];
        btn.tag = index + BUTTON_TAG_OFFSET;
        index ++;
        if ([title isEqualToString:@"删除"])
        {
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        if (index < count - 1) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 48*index-0.5, contentView.bm_width, 0.5)];
            line.backgroundColor = UI_COLOR_B6;
            [contentView addSubview:line];
        }
    }
    
    UIButton *cancle = [self buttonWithFrame:CGRectMake(0, 48*index+9, contentView.bm_width, 48) Title:@"取消"];
    [cancle setTitleColor:UI_COLOR_B1 forState:UIControlStateNormal];
    [contentView addSubview:cancle];
}

- (UIButton *)buttonWithFrame:(CGRect)frame Title:(NSString *)title
{
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    btn.titleLabel.font = UI_FONT_16;
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:UI_COLOR_BL6 forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)buttonClickAction:(UIButton *)btn
{
    if (btn.tag) {
        if (self.m_ActionSheetDoneBlock) {
            self.m_ActionSheetDoneBlock(btn.tag-BUTTON_TAG_OFFSET, [btn titleForState:UIControlStateNormal]);
        }
    }
    
    [self hideView];
}

- (void)showView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
            _m_ContentView.bm_bottom = self.view.bm_bottom;
        } completion:^(BOOL finished) {
            if (finished) {
            }
        }];
    });
}

- (void)hideView
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
        _m_ContentView.bm_top = self.view.bm_bottom;
    } completion:^(BOOL finished) {
        if (finished) {
            [self dismissViewControllerAnimated:NO completion:^{
                if (self.m_ActionSheetDismissBlock) {
                    self.m_ActionSheetDismissBlock();
                }
            }];
        }
    }];
}

- (void)tapedSelf:(id)sender
{
    [self hideView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self showView];
}

@end
