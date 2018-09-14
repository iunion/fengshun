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
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
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

    UIButton *btn = [UIButton bm_buttonWithFrame:CGRectMake(UI_SCREEN_WIDTH - 40 - 4, 0, 40, 24) image:[UIImage imageNamed:@"video_delete_btn"]];
    [btn addTarget:self action:@selector(deleteFromSuperView) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];

    
    FSEditVideoMediateTextView *nameView = [[FSEditVideoMediateTextView alloc] initWithFrame:CGRectMake(0, 24, UI_SCREEN_WIDTH, 0)];
    nameView.titleLabel.text = @"姓名";
    nameView.desLabel.attributedPlaceholder = [nameView placeHolderAttributedWithString:@"请输入姓名"];
    [self.contentView addSubview:nameView];
    self.m_NameView = nameView;
    nameView.textChangeHandle = ^(FSEditVideoMediateTextView *editView) {
        weakSelf.m_Model.userName = editView.desLabel.text;
    };

    FSEditVideoMediateTextView *phoneView = [[FSEditVideoMediateTextView alloc] initWithFrame:CGRectMake(0, nameView.bm_bottom, UI_SCREEN_WIDTH, 0)];
    phoneView.titleLabel.text = @"手机号";
    phoneView.desLabel.keyboardType = UIKeyboardTypeNumberPad;
    phoneView.desLabel.attributedPlaceholder = [phoneView placeHolderAttributedWithString:@"请输入手机号"];
    [self.contentView addSubview:phoneView];
    self.m_PhoneView = phoneView;
    phoneView.textChangeHandle = ^(FSEditVideoMediateTextView *editView) {
        weakSelf.m_Model.mobilePhone = editView.desLabel.text;
    };

    FSEditVideoMediateImageView *identify = [[FSEditVideoMediateImageView alloc] initWithFrame:CGRectMake(0, phoneView.bm_bottom, UI_SCREEN_WIDTH, 0) imageName:@"BMTableView_arrows_rightBlack"];
    identify.titleLabel.text = @"身份";
    identify.desLabel.attributedPlaceholder = [identify placeHolderAttributedWithString:@"请选择"];
    [self.contentView addSubview:identify];
    self.m_IdentifyView = identify;
    identify.line.hidden = YES;
    [identify setEditEnabled:NO];
    identify.tapHandle = ^(FSEditVideoMediateBaseView *editView) {
        [weakSelf endEditing:NO];

        FSVideoMediateSheetVC *sheetVC = [[FSVideoMediateSheetVC alloc] initWithTitleArray:[FSMeetingDataForm getMeetingDataAllValuesWithType:FSMeetingDataType_PersonIdentityType]];
        sheetVC.modalPresentationStyle = UIModalPresentationCustom;
        sheetVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [weakSelf.bm_viewController presentViewController:sheetVC animated:YES completion:nil];

        sheetVC.m_ActionSheetDoneBlock = ^(NSInteger index, NSString *title) {
            weakSelf.m_IdentifyView.desLabel.text = title;
            weakSelf.m_Model.meetingIdentityTypeEnums = [FSMeetingDataForm getKeyForVlaue:title type:FSMeetingDataType_PersonIdentityType];
        };
    };
}

- (void)setM_Model:(FSMeetingPersonnelModel *)model
{
    _m_Model = model;
    _m_NameView.desLabel.text = model.userName;
    _m_PhoneView.desLabel.text = model.mobilePhone;
    _m_IdentifyView.desLabel.text = [FSMeetingDataForm getValueForKey:model.meetingIdentityTypeEnums type:FSMeetingDataType_PersonIdentityType];
}

- (void)deleteFromSuperView
{
    if (self.deleteBlock) {
        self.deleteBlock(self);
    }
}

@end
