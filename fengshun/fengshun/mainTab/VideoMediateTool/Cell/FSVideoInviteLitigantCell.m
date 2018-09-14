//
//  FSVideoInviteLitigantCell.m
//  fengshun
//
//  Created by ILLA on 2018/9/13.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSVideoInviteLitigantCell.h"
#import "FSEditVideoMediateView.h"
#import "FSVideoMediateSheetVC.h"

@interface FSVideoInviteLitigantCell ()

@property (nonatomic, strong) FSEditVideoMediateTextView *m_NameView;
@property (nonatomic, strong) FSEditVideoMediateTextView *m_PhoneView;
@property (nonatomic, strong) FSEditVideoMediateImageView *m_IdentifyView;

@end

@implementation FSVideoInviteLitigantCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self) {
        [self build];
    }
    
    return self;
}

- (void)build
{
    BMWeakSelf
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 100, 24)];
    label.text = @"当事人信息";
    label.textColor = UI_COLOR_B4;
    label.font = UI_FONT_12;
    [self.contentView addSubview:label];

    FSEditVideoMediateTextView *nameView = [[FSEditVideoMediateTextView alloc] initWithFrame:CGRectMake(0, 24, UI_SCREEN_WIDTH, 0)];
    nameView.titleLabel.text = @"姓名";
    nameView.desLabel.attributedPlaceholder = [nameView placeHolderAttributedWithString:@"请输入姓名"];
    [self.contentView addSubview:nameView];
    self.m_NameView = nameView;
    nameView.textChangeHandle = ^(FSEditVideoMediateTextView *editView) {
        BMStrongSelf
        self.m_Model.userName = editView.desLabel.text;
    };

    FSEditVideoMediateTextView *phoneView = [[FSEditVideoMediateTextView alloc] initWithFrame:CGRectMake(0, nameView.bm_bottom, UI_SCREEN_WIDTH, 0)];
    phoneView.titleLabel.text = @"手机号";
    phoneView.desLabel.attributedPlaceholder = [phoneView placeHolderAttributedWithString:@"请输入手机号"];
    [self.contentView addSubview:phoneView];
    self.m_PhoneView = phoneView;
    phoneView.textChangeHandle = ^(FSEditVideoMediateTextView *editView) {
        BMStrongSelf
        self.m_Model.mobilePhone = editView.desLabel.text;
    };

    FSEditVideoMediateImageView *identify = [[FSEditVideoMediateImageView alloc] initWithFrame:CGRectMake(0, phoneView.bm_bottom, UI_SCREEN_WIDTH, 0) imageName:@"BMTableView_arrows_rightBlack"];
    identify.titleLabel.text = @"身份";
    [self.contentView addSubview:identify];
    self.m_IdentifyView = identify;
    identify.line.hidden = YES;
    [identify setEditEnabled:NO];
    identify.tapHandle = ^(FSEditVideoMediateBaseView *editView) {
        
        NSArray *array1 = @[@"APPLICAT_GENERAL_AGENT",
                            @"APPLICAT_ESPECIALLY_IMPOWER_AGENTAPPLICAT",
                            @"APPLICAT",
                            @"RESPONDENT",
                            @"RESPONDENT_GENERAL_AGENT",
                            @"RESPONDENT_ESPECIALLY_IMPOWER_AGENT",
                            @"MEDIATOR"];
        NSArray *array2 = @[@"申请人一般代理人",
                            @"申请人特别授权代理人",
                            @"申请人",
                            @"被申请人",
                            @"被申请人一般代理人",
                            @"被申请人特别授权代理人",
                            @"调解员"];
        
        FSVideoMediateSheetVC *sheetVC = [[FSVideoMediateSheetVC alloc] initWithTitleArray:array2];
        sheetVC.modalPresentationStyle = UIModalPresentationCustom;
        sheetVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [weakSelf.bm_viewController presentViewController:sheetVC animated:YES completion:nil];

        sheetVC.m_ActionSheetDoneBlock = ^(NSInteger index, NSString *title) {
            weakSelf.m_IdentifyView.desLabel.text = title;
            weakSelf.m_Model.meetingIdentityTypeEnums = array1[index];
        };
    };
}

-(void)setM_Model:(MeetingPersonnelModel *)model
{
    _m_Model = model;
    _m_NameView.desLabel.text = model.userName;
    _m_PhoneView.desLabel.text = model.mobilePhone;
    _m_IdentifyView.desLabel.text = model.meetingIdentityTypeEnums;
}

@end
