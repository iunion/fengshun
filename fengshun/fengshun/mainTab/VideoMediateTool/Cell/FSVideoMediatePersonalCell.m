//
//  FSVideoMediatePersonalCell.m
//  fengshun
//
//  Created by ILLA on 2018/9/13.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSVideoMediatePersonalCell.h"
#import "FSMeetingPersonnelItem.h"

#define kMarginLeft 16
#define kCellHeight 70

@interface FSVideoMediatePersonalCell ()

@property (nonatomic, strong) FSMeetingPersonnelItem *item;

@property (nonatomic, strong) UIButton *m_SelectButton;
@property (nonatomic, strong) UILabel *m_FamilyNameLabel;
@property (nonatomic, strong) UILabel *m_FullNameLable;
@property (nonatomic, strong) UILabel *m_PhoneLabel;

@end

@implementation FSVideoMediatePersonalCell
@synthesize item = _item;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier selectEnable:(BOOL)enable
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    if (self) {
        self.selectEnable = enable;
        [self build];
    }
    
    return self;
}

- (void)cellDidLoad
{
    [super cellDidLoad];
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.selectEnable = YES;
    [self build];
}

- (void)build
{
    CGFloat left = kMarginLeft;
    if (self.selectEnable) {
        self.m_SelectButton = [[UIButton alloc] initWithFrame:CGRectMake(kMarginLeft - 5, (kCellHeight-28)/2, 28, 28)];
        [_m_SelectButton addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_m_SelectButton];
        left = 44;
    }

    self.m_FamilyNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, (kCellHeight-34)/2, 34, 34)];
    self.m_FullNameLable = [[UILabel alloc] initWithFrame:CGRectMake(left + 52, kCellHeight/2 - 17, UI_SCREEN_WIDTH - 96 - kMarginLeft, 20)];
    self.m_PhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(left + 52, kCellHeight/2 ,  UI_SCREEN_WIDTH - 96 - kMarginLeft, 20)];

    [_m_FamilyNameLabel bm_circleView];
    _m_FamilyNameLabel.textColor = [UIColor whiteColor];
    _m_FamilyNameLabel.font = UI_FONT_16;
    _m_FamilyNameLabel.backgroundColor = UI_COLOR_BL1;
    _m_FamilyNameLabel.textAlignment = NSTextAlignmentCenter;
    
    _m_FullNameLable.textColor = UI_COLOR_B1;
    _m_FullNameLable.font = UI_FONT_14;

    _m_PhoneLabel.textColor = UI_COLOR_B4;
    _m_PhoneLabel.font = UI_FONT_12;

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(kMarginLeft, kCellHeight - 0.5, UI_SCREEN_WIDTH - kMarginLeft, 0.5)];
    line.backgroundColor = UI_COLOR_B6;
    
    [self.contentView addSubview:line];
    [self.contentView addSubview:_m_FamilyNameLabel];
    [self.contentView addSubview:_m_FullNameLable];
    [self.contentView addSubview:_m_PhoneLabel];    
}

- (void)cellWillAppear
{
    [super cellWillAppear];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self setModel:self.item.personModel];
}

- (void)setModel:(FSMeetingPersonnelModel *)model
{
    _model = model;
    _m_FamilyNameLabel.text = [model.userName substringWithRange:NSMakeRange(0, 1)];
    _m_FullNameLable.text = model.userName;
    _m_PhoneLabel.text = model.mobilePhone;
    
    if (self.selectEnable)
    {
        if ([_model isMediatorPerson])
        {
            [_m_SelectButton setImage:[UIImage imageNamed:@"video_unselect"] forState:UIControlStateNormal] ;
            _m_SelectButton.userInteractionEnabled = NO;
        }
        else
        {
            _m_SelectButton.userInteractionEnabled = YES;
            if (_model.selectState == 0)
            {
                [_m_SelectButton setImage:[UIImage imageNamed:@"video_not_selected"] forState:UIControlStateNormal] ;
            }
            else
            {
                [_m_SelectButton setImage:[UIImage imageNamed:@"video_selected"] forState:UIControlStateNormal] ;
            }
        }
    }
}

- (void)selectAction
{
    if (_model.selectState == 0)
    {
        _model.selectState = 1;
        [_m_SelectButton setImage:[UIImage imageNamed:@"video_selected"] forState:UIControlStateNormal] ;
    }
    else if (_model.selectState == 1)
    {
        _model.selectState = 0;
        [_m_SelectButton setImage:[UIImage imageNamed:@"video_not_selected"] forState:UIControlStateNormal] ;
    }
}

@end

