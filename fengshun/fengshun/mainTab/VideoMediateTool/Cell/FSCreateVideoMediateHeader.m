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
#import "FSTableViewVC.h"

@interface FSCreateVideoMediateHeader () <UIPickerViewDelegate, UIPickerViewDataSource >

@property (nonatomic, assign) BOOL m_IsStartImmediately;
@property (nonatomic, assign) NSInteger m_Hour;
@property (nonatomic, assign) NSInteger m_Minute;

@property (nonatomic, strong) FSEditVideoMediateImageView *m_MeetingTypeView;   // 会议类型
@property (nonatomic, strong) FSEditVideoMediateImageView *m_TimeTypeView;      // 时间类型
@property (nonatomic, strong) FSEditVideoMediateImageView *m_selectTimeView;    // 预约时间起始时间
@property (nonatomic, strong) FSEditVideoMediateImageView *m_TimeLengthView;    // 时长

@property (nonatomic, strong) UIView *m_underTimeView;
@property (nonatomic, strong) BMDatePicker *m_DatePicker;
@property (nonatomic, strong) UIPickerView *m_PickerView;

@end

@implementation FSCreateVideoMediateHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self buildUI];
    }
    
    return self;
}

- (void)buildUI
{
    BMWeakSelf
    
    FSEditVideoMediateTextView *nameView = [[FSEditVideoMediateTextView alloc] initWithFrame:CGRectMake(0, 9, self.bm_width, 0)];
    nameView.titleLabel.text = @"名称";
    nameView.desLabel.attributedPlaceholder = [nameView placeHolderAttributedWithString:@"请输入名称"];
    [self addSubview:nameView];
    nameView.textChangeHandle = ^(FSEditVideoMediateTextView *editView) {
        weakSelf.m_Model.meetingName = editView.desLabel.text;
    };

    _m_MeetingTypeView = [[FSEditVideoMediateImageView alloc] initWithFrame:CGRectMake(0, nameView.bm_bottom, self.bm_width, 0) imageName:@"BMTableView_arrows_rightBlack"];
    _m_MeetingTypeView.titleLabel.text = @"类型";
    _m_MeetingTypeView.desLabel.text = @"调解";
    [self addSubview:_m_MeetingTypeView];
    [_m_MeetingTypeView setEditEnabled:NO];
    _m_MeetingTypeView.tapHandle = ^(FSEditVideoMediateBaseView *editView) {
        [weakSelf endEditing:NO];

        FSVideoMediateSheetVC *sheetVC = [[FSVideoMediateSheetVC alloc] initWithTitleArray:[FSMeetingDataForm getMeetingDataAllValuesWithType:FSMeetingDataType_MeetingType]];
        sheetVC.modalPresentationStyle = UIModalPresentationCustom;
        sheetVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [weakSelf.bm_viewController presentViewController:sheetVC animated:YES completion:nil];
        
        sheetVC.m_ActionSheetDoneBlock = ^(NSInteger index, NSString *title) {
            weakSelf.m_MeetingTypeView.desLabel.text = title;
            weakSelf.m_Model.meetingType = [FSMeetingDataForm getKeyForVlaue:title type:FSMeetingDataType_MeetingType];
        };
    };
    
    _m_TimeTypeView = [[FSEditVideoMediateImageView alloc] initWithFrame:CGRectMake(0, _m_MeetingTypeView.bm_bottom, self.bm_width, 0) imageName:@"BMTableView_arrows_rightBlack"];
    _m_TimeTypeView.titleLabel.text = @"时间";
    _m_TimeTypeView.desLabel.text = @"立即开始";
    self.m_IsStartImmediately = YES;
    [self addSubview:_m_TimeTypeView];
    [_m_TimeTypeView setEditEnabled:NO];
    _m_TimeTypeView.tapHandle = ^(FSEditVideoMediateBaseView *editView) {
        [weakSelf endEditing:NO];

        FSVideoMediateSheetVC *sheetVC = [[FSVideoMediateSheetVC alloc] initWithTitleArray:@[@"立即开始",@"预约时间"]];
        sheetVC.modalPresentationStyle = UIModalPresentationCustom;
        sheetVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [weakSelf.bm_viewController presentViewController:sheetVC animated:YES completion:nil];

        sheetVC.m_ActionSheetDoneBlock = ^(NSInteger index, NSString *title) {
            if (index == 0) {
                [weakSelf setSelectTimeViewHidden:YES];
            } else {
                [weakSelf setSelectTimeViewHidden:NO];
            }
            weakSelf.m_TimeTypeView.desLabel.text = title;
        };
    };

    _m_selectTimeView = [[FSEditVideoMediateImageView alloc] initWithFrame:CGRectMake(0, _m_TimeTypeView.bm_bottom, self.bm_width, 0) imageName:@"BMTableView_arrows_rightBlack"];
    [self addSubview:_m_selectTimeView];
    _m_selectTimeView.desLabel.attributedPlaceholder = [_m_selectTimeView placeHolderAttributedWithString:@"请选择"];
    _m_selectTimeView.titleLabel.text = @"开始时间";
    _m_selectTimeView.desLabel.inputView = self.m_DatePicker;
    _m_selectTimeView.hidden = YES;
    _m_selectTimeView.tapHandle = ^(FSEditVideoMediateBaseView *editView) {
        [weakSelf.m_selectTimeView.desLabel becomeFirstResponder];
    };
    
    self.m_underTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, _m_selectTimeView.bm_top, self.bm_width, 0)];
    [self addSubview:_m_underTimeView];
    
    _m_TimeLengthView = [[FSEditVideoMediateImageView alloc] initWithFrame:CGRectMake(0, 0, self.bm_width, 0) imageName:@"BMTableView_arrows_rightBlack"];
    _m_TimeLengthView.titleLabel.text = @"时长";
    _m_TimeLengthView.desLabel.attributedPlaceholder = [_m_TimeLengthView placeHolderAttributedWithString:@"请选择"];
    _m_TimeLengthView.line.hidden = YES;
    [_m_underTimeView addSubview:_m_TimeLengthView];
    _m_TimeLengthView.desLabel.inputView = self.m_PickerView;
    _m_TimeLengthView.tapHandle = ^(FSEditVideoMediateBaseView *editView) {
        if (weakSelf.m_Hour == 0) {
            weakSelf.m_Hour = 1;
            weakSelf.m_TimeLengthView.desLabel.text = [NSString stringWithFormat:@"%ld小时%ld分钟", weakSelf.m_Hour,  weakSelf.m_Minute];
        }
        [weakSelf.m_TimeLengthView.desLabel becomeFirstResponder];
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

-(void)setM_Model:(FSMeetingDetailModel *)model
{
    _m_Model = model;
    self.m_Model.meetingType = [FSMeetingDataForm getKeyForVlaue:_m_MeetingTypeView.desLabel.text type:FSMeetingDataType_MeetingType];
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    self.m_Model.startTime = time * 1000;
}

-(void)setM_IsStartImmediately:(BOOL)startImmediately
{
    _m_IsStartImmediately = startImmediately;
    if (startImmediately) {
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        self.m_Model.startTime = time * 1000;
    } else {
        self.m_Model.startTime = [self.m_DatePicker.pickerDate timeIntervalSince1970] * 1000;
    }
}

- (void)setSelectTimeViewHidden:(BOOL)hidden
{
    self.m_IsStartImmediately = hidden;
    _m_selectTimeView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        if (hidden) {
            _m_underTimeView.bm_top = _m_selectTimeView.bm_top;
        } else {
            _m_underTimeView.bm_top = _m_selectTimeView.bm_bottom;
        }
        self.bm_height = _m_underTimeView.bm_bottom;
        
        [[[self bm_tableviewController] m_TableView] reloadData];
        
    } completion:^(BOOL finished) {
        _m_selectTimeView.hidden = hidden;
    }];
}

- (FSTableViewVC *)bm_tableviewController
{
    if ([self.bm_viewController isKindOfClass:[FSTableViewVC class]]) {
        return (FSTableViewVC *)self.bm_viewController;
    }
    
    return nil;
}

- (UIPickerView *)m_PickerView
{
    if (_m_PickerView == nil) {
        _m_PickerView = [[UIPickerView alloc] init];
        _m_PickerView.backgroundColor = [UIColor whiteColor];
        _m_PickerView.delegate = self;
        _m_PickerView.dataSource = self;
    }
    
    return _m_PickerView;
}
-(BMDatePicker *)m_DatePicker
{
    if (_m_DatePicker == nil) {
        BMWeakSelf
        BMDatePicker *datePicker = [[BMDatePicker alloc] initWithPickerStyle:PickerStyle_YearMonthDayHourMinute completeBlock:^(NSDate * _Nonnull date, BOOL isDone) {
            weakSelf.m_Model.startTime = [date timeIntervalSince1970]*1000;
            weakSelf.m_selectTimeView.desLabel.text = [date bm_stringWithFormat:@"yyyy-MM-dd HH:mm"];
            if (isDone) {
                [weakSelf.m_selectTimeView.desLabel resignFirstResponder];
            }
        }];
        _m_DatePicker = datePicker;
    }

    _m_DatePicker.minLimitDate = [NSDate date];
    return _m_DatePicker;
}

#pragma mark UIPickerViewDataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return 8;
    }
    return 2;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [NSString stringWithFormat:@"%ld小时",row+1];
    }
    
    if (row == 0) {
        return @"0分钟";
    }

    return @"30分钟";
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        _m_Hour = row+1;
    } else {
        if (row == 1) {
            _m_Minute = 30;
        } else {
            _m_Minute = 0;
        }
    }
    
    self.m_TimeLengthView.desLabel.text = [NSString stringWithFormat:@"%ld小时%ld分钟", _m_Hour,  _m_Minute];
}

- (BOOL)validMeetingInfo
{
    if (![self.m_Model.meetingName bm_isNotEmpty]) {
        [[self bm_tableviewController].m_ProgressHUD showAnimated:YES withDetailText:@"请输入名称" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        return NO;
    }

    if (!_m_IsStartImmediately && self.m_Model.startTime == 0) {
        [[self bm_tableviewController].m_ProgressHUD showAnimated:YES withDetailText:@"请选择开始时间" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        return NO;
    }

    if (_m_Hour == 0) {
        [[self bm_tableviewController].m_ProgressHUD showAnimated:YES withDetailText:@"请选择会议时长" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        return NO;
    }
    
    self.m_Model.orderHour = [NSString stringWithFormat:@"%ld",self.m_Hour];

    return YES;
}

@end
