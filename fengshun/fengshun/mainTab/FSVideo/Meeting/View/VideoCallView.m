//
//  MDTViewCallView.m
//  ODR
//
//  Created by DH on 2018/8/10.
//  Copyright © 2018年 DH. All rights reserved.
//

#import "VideoCallView.h"
#import "UIButton+BMContentRect.h"
#import "VideoCallModel.h"
#import "UIView+BMBadge.h"

static CGFloat scale = 1.33;
static CGFloat margin = 10;

@implementation VideoCallPackView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)adjustLayout {
    // 计算并设置每一个渲染视图的frame
    NSInteger count = self.subviews.count;
    if (!count) return;
    if (count == 1) { //居中
        [self layoutForEqual1];
    }
    if (count == 2) { //居中
        [self layoutForEqual2];
    }

    if (count == 3) { //居中
        [self layoutForEqual3];
    }

    if (count == 4) { //居中
        [self layoutForEqual4];
    }

    if (count == 5) { //居中
        [self layoutForEqual5];
    }
    if (count == 6) { //居中
        [self layoutForEqual6];
    }

    if (count == 7) { //居中
        [self layoutForEqual7];
    }
    if (count == 8) { //居中
        [self layoutForEqual8];
    }
    
    
}


- (void)layoutForEqual1 {
    VideoCallVideoView *view = [self.subviews firstObject];
    CGFloat w = self.bm_width - 100;
    CGFloat h = w * scale;
    CGFloat x = (self.bm_width - w) * 0.5;
    CGFloat y = (self.bm_height - h) * 0.5;
    view.frame = CGRectMake(x, y, w, h);
}

- (void)layoutForEqual2 {
    CGFloat w = (self.bm_width - margin * 3) * 0.5;
    CGFloat h = w * scale;
    {
        VideoCallVideoView *one = self.subviews[0];
        CGFloat x = margin;
        CGFloat y = margin;
        one.frame = CGRectMake(x, y, w, h);
    }
    {
        VideoCallVideoView *two = self.subviews[1];
        CGFloat x = margin * 2 + w;
        CGFloat y = margin;
        two.frame = CGRectMake(x, y, w, h);
    }
}

- (void)layoutForEqual3 {
    [self layoutForEqual2];
    
    CGFloat w = (self.bm_width - margin * 3) * 0.5;
    CGFloat h = w * scale;
    
    VideoCallVideoView *three = self.subviews[2];
    CGFloat x = (self.bm_width - w) * 0.5;
    CGFloat y = margin * 2 + h;
    three.frame = CGRectMake(x, y, w, h);
}

- (void)layoutForEqual4 {
    CGFloat w = (self.bm_width - margin * 3) * 0.5;
    CGFloat h = w * scale;
    [self layoutForEqual2];
    {
        VideoCallVideoView *three = self.subviews[2];
        CGFloat x = margin;
        CGFloat y = margin * 2 + h;
        three.frame = CGRectMake(x, y, w, h);
    }
    {
        VideoCallVideoView *four = self.subviews[3];
        CGFloat x = margin * 2 + w;
        CGFloat y = margin * 2 + h;
        four.frame = CGRectMake(x, y, w, h);
    }
}

- (void)layoutForEqual5 {
    CGFloat w = (self.bm_width - margin * 4) / 3;
    CGFloat h = w * scale;
    for (int i = 0; i < 3; i ++) {
        VideoCallVideoView *view = self.subviews[i];
        CGFloat x = margin * (i + 1) + i * w;
        CGFloat y = margin;
        view.frame = CGRectMake(x, y, w, h);
    }
    CGFloat tempMargin = (self.bm_width - w * 2 - margin) * 0.5;
    {
        VideoCallVideoView *four = self.subviews[3];
        CGFloat x = tempMargin;
        CGFloat y = margin * 2 + h;
        four.frame = CGRectMake(x, y, w, h);
    }
    {
        VideoCallVideoView *five = self.subviews[4];
        CGFloat x = tempMargin + w + margin;
        CGFloat y = margin * 2 + h;
        five.frame = CGRectMake(x, y, w, h);
    }
}

- (void)layoutForEqual6 {
    CGFloat w = (self.bm_width - margin * 4) / 3;
    CGFloat h = w * scale;
    for (int i = 0; i < 6; i ++) {
        NSInteger row = i / 3;
        NSInteger clomn = i % 3;
        VideoCallVideoView *view = self.subviews[i];
        CGFloat x = margin * (clomn + 1) + clomn * w;
        CGFloat y = margin * (row + 1) + h * row;
        view.frame = CGRectMake(x, y, w, h);
    }
}

- (void)layoutForEqual7 {
    [self layoutForEqual6];
    CGFloat w = (self.bm_width - margin * 4) / 3;
    CGFloat h = w * scale;
    VideoCallVideoView *seven = self.subviews[6];
    CGFloat x = (self.bm_width - w) * 0.5;
    CGFloat y = h * 2 + margin * 3;
    seven.frame = CGRectMake(x, y, w, h);
}
- (void)layoutForEqual8 {
    [self layoutForEqual6];
    CGFloat w = (self.bm_width - margin * 4) / 3;
    CGFloat h = w * scale;
    CGFloat tempMargin = (self.bm_width - w * 2 - margin) * 0.5;
    {
        VideoCallVideoView *seven = self.subviews[6];
        CGFloat x = tempMargin;
        CGFloat y = margin * 3 + h * 2;
        seven.frame = CGRectMake(x, y, w, h);
    }
    {
        VideoCallVideoView *eight = self.subviews[7];
        CGFloat x = tempMargin + w + margin;
        CGFloat y = margin * 3 + h * 2;
        eight.frame = CGRectMake(x, y, w, h);
    }

}

- (VideoCallVideoView *)elementForUserId:(NSString *)useId {
    VideoCallVideoView *videoView = nil;
    for (int i = 0; i < self.subviews.count; i ++) {
        VideoCallVideoView *view = self.subviews[i];
        if ([view.model.memberId isEqualToString:useId]) {
            videoView = view;
            break;
        }
    }
    return videoView;
}

@end


@implementation VideoCallVideoView
- (instancetype)initWithRenderView:(ILiveRenderView *)renderView model:(VideoCallMemberModel *)model {
    if (self = [super init]) {
        self.layer.cornerRadius = 5;
        self.layer.cornerRadius = 2;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor bm_colorWithHex:0x313b47];
        _model = model;
        
        _renderView = ({
            _userId = renderView.identifier;
            [self addSubview:renderView];
            renderView;
        });

        _videoClosedView = ({
            UIImageView *v = [UIImageView new];
            v.contentMode = UIViewContentModeScaleToFill;
            v.image = [UIImage imageNamed:@"videocall_default_head"];
            [self addSubview:v];
            [v mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(self.mas_width).multipliedBy(0.5).priorityHigh();
                make.height.mas_equalTo(v.mas_width).multipliedBy(1.1);
                make.centerX.equalTo(self);
                make.centerY.equalTo(self).offset(-12);
            }];
            v;
        });

        _avPackView = ({
            UIView *v = [UIView new];
            UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avPackViewDidTap)];
            [v addGestureRecognizer:gr];
            [self addSubview:v];
            [v mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(self);
                make.height.offset(35);
                make.width.offset(60);
            }];
            v;
        });
        
        _audioBtn = ({
            UIButton *btn = [UIButton new];
            btn.userInteractionEnabled = NO;
            [btn setImage:[UIImage imageNamed:@"videocall_open_audio"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"videocall_close_audio"] forState:UIControlStateSelected];
            [_avPackView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_avPackView);
                make.right.equalTo(_avPackView.mas_centerX).offset(-2);
            }];
            btn;
        });
        
        _videoBtn = ({
            UIButton *btn = [UIButton new];
            btn.userInteractionEnabled = NO;
            [btn setImage:[UIImage imageNamed:@"videocall_open_video"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"videocall_close_video"] forState:UIControlStateSelected];
            [_avPackView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_avPackView);
                make.left.equalTo(_avPackView.mas_centerX).offset(2);
            }];
            btn;
        });
        
        // 这个版本小程序不支持私聊
//        _pirChatBtn = ({
//            UIButton *btn = [UIButton new];
//            [btn setImage:[UIImage imageNamed:@"videocall_privte_chat"] forState:UIControlStateNormal];
//            [btn addTarget:self action:@selector(priChatBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
//            [self addSubview:btn];
//            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(_avPackView);
//                make.right.equalTo(self).offset(-5);
//            }];
//            btn;
//        });
//
//        _redPointImgView = ({
//            UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"videocall_red_dot"]];
//            img.hidden = YES;
//            [_pirChatBtn addSubview:img];
//            [img mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.equalTo(_pirChatBtn).offset(-2);
//                make.top.equalTo(_pirChatBtn).offset(2);
//            }];
//            img;
//        });
        
        _shadowView = ({
            UIView *v = [UIView new];
            v.alpha = 0.5;
            v.backgroundColor = [UIColor blackColor];
            [self addSubview:v];
            [v mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(30);
                make.left.right.equalTo(self);
                make.bottom.equalTo(self);
            }];
            v;
        });
        
        _nameLabel = ({
            UILabel *l = [UILabel new];
            l.font = UI_FONT_13;
            l.textColor = [UIColor whiteColor];
            l.textAlignment = NSTextAlignmentCenter;
            [_shadowView addSubview:l];
            [l mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.top.equalTo(_shadowView);
            }];
            l;
        });
        [self reloadData];
    }
    return self;
}

- (void)reloadData {
    _nameLabel.text = _model.memberName;
    _audioBtn.selected = !_model.memberVoiceStatus;
    _videoBtn.selected = !_model.memberVideoStatus;

//    if ([_model.memberType isEqualToString:@"MEDIATOR"]) {
//        _pirChatBtn.hidden = YES;
//    } else {
//        _pirChatBtn.hidden = NO;
//    }
    
    _videoClosedView.hidden = _model.memberVideoStatus;
    _renderView.hidden = !_model.memberVideoStatus;
}

- (void)isShowRedPoint:(BOOL)isShow {
    _redPointImgView.hidden = !isShow;
}

- (void)setFrame:(CGRect)frame {
    NSInteger x = frame.origin.x;
    NSInteger y = frame.origin.y;
    NSInteger w = frame.size.width;
    NSInteger h = frame.size.height;
    [super setFrame:CGRectMake(x, y, w, h)];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.renderView.frame = self.bounds;

}

- (void)priChatBtnDidClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(videoCallVideoView:priChatBtnDidClick:)]) {
        [self.delegate videoCallVideoView:self priChatBtnDidClick:_model];
    }
}

- (void)avPackViewDidTap {
    if ([self.delegate respondsToSelector:@selector(videoCallVideoView:avPackViewDidTap:)]) {
        [self.delegate videoCallVideoView:self avPackViewDidTap:_model];
    }
}

@end

@implementation VideoCallTopBar
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];

        NSArray * data = @[@[@"开始录制",@"结束录制",@"videocall_start_record",@"videocall_end_record"],
                           @[@"识别语音",@"识别语音",@"videocall_voice_off", @"videocall_voice_open"],
                           @[@"翻转",@"翻转",@"videocall_camera_switch",@"videocall_camera_switch"]];
        CGFloat left = 30;
        CGFloat width = (UI_SCREEN_WIDTH - left*2)/data.count;
        for (int i = 0; i < data.count; i ++) {
            UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            topBtn.frame = CGRectMake(left + width*i, 0, width, 70);
            topBtn.tag = 1+i;
            topBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [topBtn addTarget:self action:@selector(topBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
            [topBtn bm_setTitleColor:[UIColor whiteColor]];
            [topBtn setTitle:data[i][0] forState:UIControlStateNormal];
            [topBtn setTitle:data[i][1] forState:UIControlStateSelected];
            [topBtn setImage:[UIImage imageNamed:data[i][2]] forState:UIControlStateNormal];
            [topBtn setImage:[UIImage imageNamed:data[i][3]] forState:UIControlStateSelected];
            [topBtn bm_layoutButtonWithEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageTop imageTitleGap:3];
            [self addSubview:topBtn];
        }
        
        UIButton *backBtn = [UIButton bm_buttonWithFrame:CGRectMake(0, 10, 44, 50) image:[UIImage imageNamed:@"video_back_btn"]];
        [backBtn addTarget:self action:@selector(topBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        backBtn.tag = 0;
        [self addSubview:backBtn];

    }
    return self;
}

- (void)topBtnClickAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(videoCallTopBarDidClick:index:)]) {
        [self.delegate videoCallTopBarDidClick:self index:sender.tag];
    }
}

- (void)setBtnIsSelected:(BOOL)isSelected index:(NSInteger)index {
    if ([self viewWithTag:index] != nil) {
        UIButton *btn = [self viewWithTag:index];
        [btn setSelected:isSelected];
    }
}
- (BOOL)getBtnSelectedStatusWithIndex:(NSInteger)index {
    UIButton *btn = [self viewWithTag:index];
    return btn.selected;
}

@end

@implementation VideoCallBottomBar
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        NSMutableArray *dataArr = [NSMutableArray array];
        [dataArr addObjectsFromArray:@[@[@"对话消息",@"video_bottom_message"],
                                       @[@"邀请",@"video_invite"],
                                       @[@"结束视频",@"video_bottom_endbtn"]]];
        CGFloat left = 30;
        CGFloat width = (UI_SCREEN_WIDTH - left*2)/dataArr.count;
        for (int i = 0; i < dataArr.count; i ++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(left+ width*i, 0, width , 49);
            [button setTitle:dataArr[i][0] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            [button setImage:[UIImage imageNamed:dataArr[i][1]] forState:UIControlStateNormal];
            [button bm_layoutButtonWithEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageTop imageTitleGap:3];
            [button addTarget:self action:@selector(bottomBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:UI_COLOR_B4 forState:UIControlStateNormal];
            button.tag = i;
            [self addSubview:button];
        }
    }
    return self;
}

- (void)bottomBtnClickAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoCallBottomBar:index:)]) {
        [self.delegate videoCallBottomBar:self index:sender.tag];
    }
}

@end




