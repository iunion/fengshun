//
//  FSSetProfessionalVC.m
//  fengshun
//
//  Created by jiang deng on 2019/4/16.
//  Copyright © 2019 FS. All rights reserved.
//

#import "FSSetProfessionalVC.h"
#import "AppDelegate.h"

#define MAX_ItemCount   15

@interface FSSetProfessionalVC ()

@property (nonatomic, strong) BMTableViewSection *m_ProfessionalSection;

//@property (nonatomic, strong) NSMutableArray *m_ProfessionalArray;
//@property (nonatomic, strong) NSMutableArray *m_ItemArray;

@property (nonatomic, strong) UIButton *m_AddBtn;

@end

@implementation FSSetProfessionalVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = FS_VIEW_BGCOLOR;
    self.m_TableView.bounces = YES;
    
    [self bm_setNavigationWithTitle:@"专业任职" barTintColor:nil leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:@"完成" rightItemImage:nil rightToucheEvent:@selector(updateAction:)];

    [self interfaceSettings];
}

- (BOOL)needKeyboardEvent
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)makeFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.m_TableView.bm_width, 130.0f)];
    footerView.backgroundColor = [UIColor clearColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, self.m_TableView.bm_width-60.0f, 44);
    btn.backgroundColor = [UIColor clearColor];
    btn.titleLabel.font = FS_BUTTON_LARGETEXTFONT;
    btn.exclusiveTouch = YES;
    [btn addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"+ 继续添加" forState:UIControlStateNormal];
    [btn setTitleColor:UI_COLOR_BL1 forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [btn bm_roundedDashRect:4.0f borderWidth:1.0f borderColor:UI_COLOR_BL1];
    [footerView addSubview:btn];
    [btn bm_centerInSuperView];
    self.m_AddBtn = btn;
    
    self.m_TableView.tableFooterView = footerView;
}

- (BMTextItem *)makeItemWithValue:(NSString *)value last:(BOOL)last
{
    BMTextItem *item = [[BMTextItem alloc] initWithTitle:@"任职信息" value:value placeholder:@"请输入"];
    item.textFont = FS_CELLTITLE_TEXTFONT;
    item.textFieldTextFont = FS_CELLTITLE_TEXTFONT;
    item.keyboardType = UIKeyboardTypeDefault;
    item.clearButtonMode = UITextFieldViewModeWhileEditing;
    item.charactersLimit = 100;
    item.cellHeight = 50.0f;
    
    item.underLineColor = UI_DEFAULT_LINECOLOR;
    if (last)
    {
        item.underLineDrawType = BMTableViewCell_UnderLineDrawType_None;
    }
    else
    {
        item.underLineDrawType = BMTableViewCell_UnderLineDrawType_SeparatorAllLeftInset;
    }
    
    return item;
}

- (void)interfaceSettings
{
    [super interfaceSettings];
    
    self.m_ProfessionalSection = [BMTableViewSection section];
    
    self.m_ProfessionalSection.headerHeight = 10.0f;
    self.m_ProfessionalSection.footerHeight = 0.0f;
    
    [self.m_TableManager addSection:self.m_ProfessionalSection];
    
    [self makeFooterView];

    [self freshViews];
}

- (void)freshViews
{
    [self.m_ProfessionalSection removeAllItems];
    
    FSUserInfoModel *userInfo = [FSUserInfoModel userInfo];
    if ([userInfo.m_UserBaseInfo.m_ProfessionalArray bm_isNotEmpty])
    {
        for (NSUInteger index=0; index<userInfo.m_UserBaseInfo.m_ProfessionalArray.count; index++)
        {
            NSString *professional = userInfo.m_UserBaseInfo.m_ProfessionalArray[index];
            [self.m_ProfessionalSection addItem:[self makeItemWithValue:professional last:NO]];
        }
    }
    else
    {
        [self.m_ProfessionalSection addItem:[self makeItemWithValue:nil last:NO]];
    }
    
    if (self.m_ProfessionalSection.items.count >= MAX_ItemCount)
    {
        self.m_AddBtn.enabled = NO;
        [self.m_AddBtn bm_roundedDashRect:4.0f borderWidth:1.0f borderColor:[UIColor grayColor]];
    }

    [self.m_TableView reloadData];
}

- (void)addClick:(UIButton *)btn
{
    if (self.m_ProfessionalSection.items.count < MAX_ItemCount)
    {
        [self.m_ProfessionalSection addItem:[self makeItemWithValue:nil last:NO]];
    
        [self.m_TableView reloadData];
    }
    
    if (self.m_ProfessionalSection.items.count >= MAX_ItemCount)
    {
        self.m_AddBtn.enabled = NO;
        [self.m_AddBtn bm_roundedDashRect:4.0f borderWidth:1.0f borderColor:[UIColor grayColor]];
    }
}

- (void)updateAction:(UIButton *)btn
{
    [self.view endEditing:YES];
    
    [self backAction:nil];
}

@end
