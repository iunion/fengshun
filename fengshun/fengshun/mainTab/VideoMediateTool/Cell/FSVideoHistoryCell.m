//
//  FSVideoHistoryCell.m
//  fengshun
//
//  Created by ILLA on 2018/9/15.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSVideoHistoryCell.h"
#import "VideoPlayerViewController.h"
#import "FSTableViewVC.h"

@implementation FSVideoHistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    _lineView = [UIView new];
    _lineView.backgroundColor = UI_COLOR_B6;
    [self.contentView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.height.offset(0.5);
        make.top.equalTo(self.contentView).offset(33);
    }];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 1, UI_SCREEN_WIDTH - 28, 32)];
    _titleLabel.textColor = UI_COLOR_B2;
    _titleLabel.font = UI_FONT_14;
    [self.contentView addSubview:_titleLabel];
    
    UILabel *timeTitle = [[UILabel alloc] initWithFrame:CGRectMake(14, 34, UI_SCREEN_WIDTH - 28, 49)];
    timeTitle.textColor = UI_COLOR_B2;
    timeTitle.font = UI_FONT_14;
    [self.contentView addSubview:timeTitle];
    timeTitle.text = @"上传时间：";
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(86, 34, UI_SCREEN_WIDTH - 14 - 86, 49)];
    _timeLabel.textColor = UI_COLOR_B2;
    _timeLabel.font = UI_FONT_14;
    [self.contentView addSubview:_timeLabel];
    
    UIButton *playBtn = [[UIButton alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 14 - 73, 43, 73, 30)];
    [playBtn setImage:[UIImage imageNamed:@"video_history_play"] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:playBtn];
}

- (void)onClick:(id)sender {
    
    if (!_model.download.length) {
        FSTableViewVC *vc = (FSTableViewVC *)self.bm_viewController;
        [vc.m_ProgressHUD showAnimated:YES withText:@"播放路径为空" delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
        return;
    }
    VideoPlayerViewController *vc = [[VideoPlayerViewController alloc] initWithVideoUrl:_model.download];
    [self.bm_viewController.navigationController pushViewController:vc animated:YES];
}

- (void)setModel:(FSVideoRecordModel *)model {
    _model = model;
    _timeLabel.text = [NSDate bm_stringFromTs:model.uploadTime * 0.001 formatter:@"yyyy-MM-dd HH:mm:ss"];
    _titleLabel.text = [NSString stringWithFormat:@"参会人：%@", model.joinUser];
}

@end
