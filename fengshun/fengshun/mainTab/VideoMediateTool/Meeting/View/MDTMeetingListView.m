//
//  MDTMeetingListView.m
//  ODR
//
//  Created by DH on 2018/9/5.
//  Copyright © 2018年 DH. All rights reserved.
//

#import "MDTMeetingListView.h"

#import "MDTMeetingListModel.h"
//#import "NSDate+XQAdd.h"

@implementation MDTCaseMeetingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _topView = [UIView new];
        [self.contentView addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.contentView);
            make.height.offset(30);
        }];
        [self setupTopViewSubviews];
        
        _middleView = [UIView new];
        [self.contentView addSubview:_middleView];
        [_middleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.topView.mas_bottom);
        }];
        [self setupMiddleViewSubViews];
        [_middleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentLabel).offset(8);
        }];
        
        _bottomView = [UIView new];
        [self.contentView addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.middleView.mas_bottom);
            make.height.offset(50);
            make.bottom.equalTo(self.contentView);
        }];
        [self setupBottomSubViews];
    }
    return self;
}

- (void)setupTopViewSubviews {
    
    _timeLabel = [UILabel new];
    _timeLabel.font = UI_FONT_14;
    _timeLabel.textColor = UI_COLOR_B1;
    [_topView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView).offset(12);
        make.centerY.equalTo(self.topView);
    }];
    
    _meetingTypeImgView = [UIImageView new];
    [_topView addSubview:_meetingTypeImgView];
    [_meetingTypeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView).offset(-12);
        make.centerY.equalTo(self.topView);
    }];
    
    _topLine = [UIView new];
    _topLine.backgroundColor = UI_COLOR_R2;
    [_topView addSubview:_topLine];
    [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.topView);
        make.height.offset(0.5);
    }];
    
}

- (void)setupMiddleViewSubViews {
    _attendeesLabel = [UILabel new];
    _attendeesLabel.textColor = UI_COLOR_B1;
    _attendeesLabel.font = UI_FONT_14;
    [_middleView addSubview:_attendeesLabel];
    [_attendeesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.middleView).offset(12);
        make.right.equalTo(self.middleView).offset(-12);
        make.top.equalTo(self.middleView).offset(8);
    }];
    
    _meetingNameLabel = [UILabel new];
    _meetingNameLabel.font = UI_FONT_14;
    [_middleView addSubview:_meetingNameLabel];
    [_meetingNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.middleView).offset(12);
        make.right.equalTo(self.middleView).offset(-12);
        make.top.equalTo(self.attendeesLabel.mas_bottom).offset(8);
    }];
    
    _contentLabel = [UILabel new];
    _contentLabel.font = UI_FONT_14;
    [_middleView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.middleView).offset(12);
        make.right.equalTo(self.middleView).offset(-12);
        make.top.equalTo(self.meetingNameLabel.mas_bottom).offset(8);
    }];
    
    _middleLine = [UIView new];
    _middleLine.backgroundColor = UI_COLOR_R2;
    [_middleView addSubview:_middleLine];
    [_middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.middleView);
        make.height.offset(0.5);
    }];
    
}

- (void)setupBottomSubViews {
    NSMutableArray *btns = @[].mutableCopy;
    NSArray *titles = @[@"进入调解", @"视频记录", @"笔录"];
    for (int i = 0; i < 3; i ++) {
        UIButton *btn = [UIButton new];
        btn.tag = i;
        [btn setTitleColor:UI_COLOR_BL1 forState:UIControlStateNormal];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_border_normal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_border_disable"] forState:UIControlStateDisabled];
        btn.titleLabel.font = UI_FONT_13;
        [btn addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:btn];
        [btns addObject:btn];
    }
    _btns = btns.copy;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat w = 100;
    CGFloat h = 30;
    CGFloat margin = 20;
    CGFloat padding = (self.contentView.bm_width - w * 3 - margin * 2) * 0.5;
    CGFloat y = 10;
    for (int i = 0; i < _btns.count; i ++) {
        UIButton *btn = _btns[i];
        CGFloat x = margin + (padding + w) * i;
        btn.frame = CGRectMake(x, y, w, h);
    }
}

- (void)btnDidClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(caseMeetingCell:btnClickWithIndex:)]) {
        [self.delegate caseMeetingCell:self btnClickWithIndex:sender.tag];
    }
}

- (void)setModel:(MDTMeetingListModel *)model {
    _model = model;
    _attendeesLabel.text = [NSString stringWithFormat:@"参会者：%@", model.joinUserName];
    _meetingNameLabel.text = [NSString stringWithFormat:@"调解名称：%@", model.meetingName];
    _contentLabel.text = [NSString stringWithFormat:@"内 容：%@", model.meetingContent];
    {
        NSTimeInterval time = model.orderTime * 0.001;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
//        yyyy/MM/dd HH:mm
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"yyyy/MM/dd HH:mm";
        NSString *timeStr = [format stringFromDate:date];
        _timeLabel.text = [NSString stringWithFormat:@"时间：%@", timeStr];
    }
    if (model.meetingType == MeetingTypeSurvey) { // 调查
        [_btns[2] setTitle:@"调解笔录" forState:UIControlStateNormal];
        _meetingTypeImgView.image = [UIImage imageNamed:@"meeting_survey"];
    } else if (model.meetingType == MeetingTypeMediate) {
        _meetingTypeImgView.image = [UIImage imageNamed:@"meeting_mediate"];
        [_btns[2] setTitle:@"调查笔录" forState:UIControlStateNormal];

    } else {
        NSAssert(NO, @"error");
    }
}

@end
