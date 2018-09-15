//
//  MDTMeetingListView.h
//  ODR
//
//  Created by DH on 2018/9/5.
//  Copyright © 2018年 DH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MDTMeetingListModel;
@protocol MDTCaseMeetingCellDelegate;
@interface MDTCaseMeetingCell : UITableViewCell
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *middleView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel *timeLabel; ///< 时间
@property (nonatomic, strong) UIImageView *meetingTypeImgView; ///< 会议类型
@property (nonatomic, strong) UIView *topLine; ///< 上线

@property (nonatomic, strong) UILabel *attendeesLabel; ///< 参会者
@property (nonatomic, strong) UILabel *meetingNameLabel; ///< 会议名
@property (nonatomic, strong) UILabel *contentLabel; ///< 内容
@property (nonatomic, strong) UIView *middleLine; ///< 中线

@property (nonatomic, strong) NSArray *btns; ///< 按钮

@property (nonatomic, strong) MDTMeetingListModel *model;
@property (nonatomic, weak) id <MDTCaseMeetingCellDelegate> delegate;
@end

@protocol MDTCaseMeetingCellDelegate <NSObject>
- (void)caseMeetingCell:(MDTCaseMeetingCell *)cell btnClickWithIndex:(NSInteger)index;
@end
