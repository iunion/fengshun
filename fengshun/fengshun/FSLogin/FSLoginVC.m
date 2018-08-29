//
//  FSLoginVC.m
//  fengshun
//
//  Created by jiang deng on 2018/8/29.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSLoginVC.h"
#import "FSAppInfo.h"

@interface FSLoginVC ()

@property (strong, nonatomic) BMTableViewSection *m_Section;

@property (strong, nonatomic) BMTextItem *m_PhoneItem;

@end

@implementation FSLoginVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.bm_NavigationBarStyle = UIBarStyleDefault;
    self.bm_NavigationBarBgTintColor = FS_VIEW_BGCOLOR;
    self.bm_NavigationItemTintColor = UI_COLOR_B2;
    
    [self bm_setNavigationWithTitle:@"" barTintColor:nil leftItemTitle:nil leftItemImage:@"navigationbar_close_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];

}

- (BOOL)needKeyboardEvent
{
    return YES;
}

- (void)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(loginClosedWithProgressState:)])
        {
            [self.delegate loginClosedWithProgressState:FSLoginProgress_LoginPhone];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)interfaceSettings
{
    [super interfaceSettings];
    
    self.m_Section = [BMTableViewSection section];
    
    self.m_PhoneItem = [BMTextItem itemWithTitle:nil value:nil placeholder:@"手机号码"];
    self.m_PhoneItem.keyboardType = UIKeyboardTypeNumberPad;
    self.m_PhoneItem.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.m_PhoneItem.underLineDrawType = BMTableViewCell_UnderLineDrawType_SeparatorAllLeftInset;

    // 获取预留电话号码
    self.m_PhoneItem.value = [FSAppInfo getCurrentPhoneNum];
    self.m_PhoneItem.charactersLimit = FSPHONENUMBER_LENGTH;
//    self.m_PhoneItem.onChangeCharacterInRange = ^BOOL(BMInputItem *item, NSRange range, NSString *replacementString) {
//
//        if (range.length == 1)
//        {
//            return YES;
//        }
//        if (item.value.length > FSPHONENUMBER_LENGTH - 1)
//        {
//            return NO;
//        }
//        
//        return YES;
//    };
    
    [self.m_Section addItem:self.m_PhoneItem];
    [self.m_TableManager addSection:self.m_Section];
    
    [self.m_TableView reloadData];
}

@end
