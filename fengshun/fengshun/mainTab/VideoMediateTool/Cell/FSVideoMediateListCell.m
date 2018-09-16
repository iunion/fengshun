//
//  VideoMediateListCell.m
//  fengshun
//
//  Created by ILLA on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSVideoMediateListCell.h"

#define kMarginLeft 16

@interface FSVideoMediateListCell ()
@property (nonatomic, strong) UILabel *meetingNameLabel;        // 会议名称
@property (nonatomic, strong) UILabel *meetingStatusLabel;      // 会议状态
@property (nonatomic, strong) UILabel *meetingTypeLabel;        //会议类型
@property (nonatomic, strong) UILabel *startTimeLabel;          // 会议开始时间
@property (nonatomic, strong) UILabel *meetingPersonnelLabel;   // 参会人员
@end

@implementation FSVideoMediateListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor bm_colorWithHex:0xF4F4F4];
    if (self) {
        [self build];
    }
    
    return self;
}

- (void)build {
    self.m_BGView = [[UIView alloc] initWithFrame:CGRectMake(0, 9, UI_SCREEN_WIDTH, 126)];
    _m_BGView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_m_BGView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(kMarginLeft, 52, _m_BGView.bm_width - kMarginLeft, 0.5)];
    line.backgroundColor = UI_COLOR_B6;
    [_m_BGView addSubview:line];

    _meetingTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginLeft, 20, 40, 20)];
    _meetingTypeLabel.textAlignment = NSTextAlignmentCenter;
    _meetingTypeLabel.font = UI_FONT_12;
    [_meetingTypeLabel bm_roundedRect:10];
    [_m_BGView addSubview:_meetingTypeLabel];

    _meetingStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - kMarginLeft - 60, 20, 60, 20)];
    _meetingStatusLabel.backgroundColor = [UIColor clearColor];
    _meetingStatusLabel.textAlignment = NSTextAlignmentRight;
    _meetingStatusLabel.font = UI_FONT_12;
    _meetingStatusLabel.textColor = UI_COLOR_B1;
    [_m_BGView addSubview:_meetingStatusLabel];

    _meetingNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 8, UI_SCREEN_WIDTH - 120, 44)];
    _meetingNameLabel.textColor =  UI_COLOR_B1;
    _meetingNameLabel.font = UI_FONT_18;
    [_m_BGView addSubview:_meetingNameLabel];
    
    UIImageView *personImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMarginLeft, 69, 16, 13)];
    personImageView.image = [UIImage imageNamed:@"video_person_icon"];
    [_m_BGView addSubview:personImageView];

    UIImageView *timeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMarginLeft, 94, 13, 13)];
    timeImageView.image = [UIImage imageNamed:@"video_time_icon"];
    [_m_BGView addSubview:timeImageView];

    _meetingPersonnelLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 65, UI_SCREEN_WIDTH - 38 - kMarginLeft, 20)];
    _meetingPersonnelLabel.textColor =  UI_COLOR_B4;
    _meetingPersonnelLabel.font = UI_FONT_14;
    [_m_BGView addSubview:_meetingPersonnelLabel];
    
    _startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 90, UI_SCREEN_WIDTH - 38 - kMarginLeft, 20)];
    _startTimeLabel.textColor =  UI_COLOR_B4;
    _startTimeLabel.font = UI_FONT_14;
    [_m_BGView addSubview:_startTimeLabel];
}

-(void)setModel:(FSMeetingDetailModel *)model
{
    _model = model;
    
    self.meetingNameLabel.text = model.meetingName;
    self.meetingTypeLabel.text = [FSMeetingDataForm getValueForKey:model.meetingType type:FSMeetingDataType_AllMeetingType];
    
    if ([model.meetingType isEqualToString:@"MEETING_MEDIATE"]) {
        _meetingTypeLabel.backgroundColor = [UIColor bm_colorWithHex:0xE5ECFD];
        _meetingTypeLabel.textColor = UI_COLOR_BL1;
    } else
    {
        _meetingTypeLabel.backgroundColor = [UIColor bm_colorWithHex:0xFFF1DA];
        _meetingTypeLabel.textColor = [UIColor bm_colorWithHex:0xFF9F17];
    }
    
    self.meetingStatusLabel.text = [FSMeetingDataForm getValueForKey:model.meetingStatus type:FSMeetingDataType_AllMeetingStatus];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.startTime*0.001];
    NSString *realDate = [date bm_stringWithFormat:@"yyyy-MM-dd HH:mm"];
    self.startTimeLabel.text = [NSString stringWithFormat:@"预约时间：%@",realDate];
    NSMutableAttributedString *dAttributedString =[[NSMutableAttributedString alloc] initWithString:self.startTimeLabel.text];
    [dAttributedString addAttribute:NSForegroundColorAttributeName value:UI_COLOR_B1 range:NSMakeRange(self.startTimeLabel.text.length - realDate.length, realDate.length)];
    self.startTimeLabel.attributedText = dAttributedString;

    
    NSString *realPerson = model.getMeetingPersonnelNameList;
    self.meetingPersonnelLabel.text = [NSString stringWithFormat:@"参与人员：%@",realPerson];
    NSMutableAttributedString *pAttributedString =[[NSMutableAttributedString alloc] initWithString:self.meetingPersonnelLabel.text];
    [pAttributedString addAttribute:NSForegroundColorAttributeName value:UI_COLOR_B1 range:NSMakeRange(self.meetingPersonnelLabel.text.length - realPerson.length, realPerson.length)];
    self.meetingPersonnelLabel.attributedText = pAttributedString;
}

@end
