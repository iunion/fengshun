//
//  FSCreateVideoMediateHeader.m
//  fengshun
//
//  Created by ILLA on 2018/9/13.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSCreateVideoMediateHeader.h"
#import "FSEditVideoMediateView.h"
#import "FSVideoMediateSheetVC.h"
#import "BMDatePicker.h"

@interface FSCreateVideoMediateHeader ()
{
    NSInteger __Hour;
    NSInteger __Minute;
}

@property (nonatomic, strong) FSEditVideoMediateImageView *m_MeetingTypeView;   // 会议类型
@property (nonatomic, strong) FSEditVideoMediateImageView *m_TimeTypeView;      // 时间类型
@property (nonatomic, strong) FSEditVideoMediateImageView *m_selectTimeView;    // 预约时间起始时间
@property (nonatomic, strong) FSEditVideoMediateImageView *m_TimeLengthView;    // 时长

@property (nonatomic, strong) UIView *m_underTimeView;
@property (nonatomic, strong) BMDatePicker *m_DatePicker;

@end

@implementation FSCreateVideoMediateHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self buildUI];
    }
    
    return self;
}

- (void)buildUI
{
    BMWeakSelf
    
    FSEditVideoMediateTextView *nameView = [[FSEditVideoMediateTextView alloc] initWithFrame:CGRectMake(0, 9, self.bm_width, 0)];
    nameView.titleLabel.text = @"名称";
    nameView.desLabel.attributedPlaceholder = [self placeHolderAttributedWithString:@"请输入名称"];
    [self addSubview:nameView];
    nameView.textChangeHandle = ^(FSEditVideoMediateTextView *editView) {
        BMStrongSelf
        self.m_Model.meetingName = editView.desLabel.text;
    };

    _m_MeetingTypeView = [[FSEditVideoMediateImageView alloc] initWithFrame:CGRectMake(0, nameView.bm_bottom, self.bm_width, 0) imageName:@"BMTableView_arrows_rightBlack"];
    _m_MeetingTypeView.titleLabel.text = @"类型";
    _m_MeetingTypeView.desLabel.text = @"调解";
    [self addSubview:_m_MeetingTypeView];
    [_m_MeetingTypeView setEditEnabled:NO];
    _m_MeetingTypeView.tapHandle = ^(FSEditVideoMediateBaseView *editView) {

        FSVideoMediateSheetVC *sheetVC = [[FSVideoMediateSheetVC alloc] initWithTitleArray:@[@"调解",@"调查"]];
        sheetVC.modalPresentationStyle = UIModalPresentationCustom;
        sheetVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [weakSelf.bm_viewController presentViewController:sheetVC animated:YES completion:nil];
        
        sheetVC.m_ActionSheetDoneBlock = ^(NSInteger index, NSString *title) {
            weakSelf.m_MeetingTypeView.desLabel.text = title;
            if (index == 0) {
                weakSelf.m_Model.meetingType = @"MEETING_MEDIATE";
            } else {
                weakSelf.m_Model.meetingType = @"MEETING_SURVEY";
            }
        };
    };
    
    FSEditVideoMediateImageView *timeView = [[FSEditVideoMediateImageView alloc] initWithFrame:CGRectMake(0, _m_MeetingTypeView.bm_bottom, self.bm_width, 0) imageName:@"BMTableView_arrows_rightBlack"];
    timeView.titleLabel.text = @"时间";
    timeView.desLabel.text = @"立即开始";
    self.m_TimeTypeView = timeView;
    [self addSubview:timeView];
    [timeView setEditEnabled:NO];
    timeView.tapHandle = ^(FSEditVideoMediateBaseView *editView) {
        FSVideoMediateSheetVC *sheetVC = [[FSVideoMediateSheetVC alloc] initWithTitleArray:@[@"立即开始",@"预约时间"]];
        sheetVC.modalPresentationStyle = UIModalPresentationCustom;
        sheetVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [weakSelf.bm_viewController presentViewController:sheetVC animated:YES completion:nil];

        sheetVC.m_ActionSheetDoneBlock = ^(NSInteger index, NSString *title) {
            weakSelf.m_TimeTypeView.desLabel.text = title;
            if (index == 0) {
                [weakSelf setSelectTimeViewHidden:YES];
            } else {
                [weakSelf setSelectTimeViewHidden:NO];
            }
        };
    };

    FSEditVideoMediateImageView *startView = [[FSEditVideoMediateImageView alloc] initWithFrame:CGRectMake(0, timeView.bm_bottom, self.bm_width, 0) imageName:@"BMTableView_arrows_rightBlack"];
    startView.titleLabel.text = @"选择时间";
    startView.desLabel.attributedPlaceholder = [self placeHolderAttributedWithString:@"请选择"];
    [self addSubview:startView];
    [startView setEditEnabled:NO];
    startView.tapHandle = ^(FSEditVideoMediateBaseView *editView) {
        NSLog(@"startView.tapHandle");
        [weakSelf didClickTimePickerButton];
    };
    startView.hidden = YES;
    self.m_selectTimeView = startView;
    
    self.m_underTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, _m_selectTimeView.bm_top, self.bm_width, 0)];
    [self addSubview:_m_underTimeView];
    
    _m_TimeLengthView = [[FSEditVideoMediateImageView alloc] initWithFrame:CGRectMake(0, 0, self.bm_width, 0) imageName:@"BMTableView_arrows_rightBlack"];
    _m_TimeLengthView.titleLabel.text = @"时长";
    _m_TimeLengthView.desLabel.attributedPlaceholder = [self placeHolderAttributedWithString:@"请选择"];
    _m_TimeLengthView.line.hidden = YES;
    [_m_underTimeView addSubview:_m_TimeLengthView];
    [_m_TimeLengthView setEditEnabled:NO];
    _m_TimeLengthView.tapHandle = ^(FSEditVideoMediateBaseView *editView) {
        [weakSelf didClickHoursAndMinutesButton];
    };

    FSEditVideoMediateContentView *content = [[FSEditVideoMediateContentView alloc] initWithFrame:CGRectMake(0, _m_TimeLengthView.bm_bottom+9, self.bm_width, 0)];
    content.titleLabel.text = @"内容";
    content.contentText.placeholder = @"请输入内容";
    content.line.hidden = YES;
    [_m_underTimeView addSubview:content];
    [content.contentText addTextDidChangeHandler:^(ORDTextView *textView) {
        weakSelf.m_Model.meetingContent = textView.text;
    }];

    _m_underTimeView.bm_height = content.bm_bottom;
    self.bm_height = _m_underTimeView.bm_bottom;
}

- (void)setSelectTimeViewHidden:(BOOL)hidden
{
    _m_selectTimeView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        if (hidden) {
            _m_underTimeView.bm_top = _m_selectTimeView.bm_top;
        } else {
            _m_underTimeView.bm_top = _m_selectTimeView.bm_bottom;
        }
        self.bm_height = _m_underTimeView.bm_bottom;
    } completion:^(BOOL finished) {
        _m_selectTimeView.hidden = hidden;
    }];
}

- (void)didClickTimePickerButton {
    [self resignFirstResponder];
    if (_m_DatePicker == nil) {
        BMDatePicker *datePicker = [[BMDatePicker alloc] initWithPickerStyle:PickerStyle_YearMonthDayHourMinute completeBlock:^(NSDate * _Nonnull date, BOOL isDone) {
            self.m_Model.startTime = [date timeIntervalSince1970]*1000;
            self.m_selectTimeView.desLabel.text = [date bm_stringWithFormat:@"yyyy-MM-dd HH:mm"];
        }];
        self.m_DatePicker = datePicker;
    }
}

- (void)didClickHoursAndMinutesButton {
    [self resignFirstResponder];
}

- (NSAttributedString *)placeHolderAttributedWithString:(NSString *)string
{
    return [[NSAttributedString alloc] initWithString:string
                                           attributes:@{NSForegroundColorAttributeName:UI_COLOR_B10,
                                                        NSFontAttributeName:UI_FONT_16
                                                        }];
}

@end
