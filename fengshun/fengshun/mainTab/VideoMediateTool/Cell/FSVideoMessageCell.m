//
//  FSVideoMessageCell.m
//  fengshun
//
//  Created by ILLA on 2018/9/15.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSVideoMessageCell.h"

@implementation FSVideoMessageCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor bm_colorWithHex:0xF4F4F4];
    if (self) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 20, UI_SCREEN_WIDTH - 16, 20)];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.textAlignment = NSTextAlignmentRight;
        _messageLabel.font = UI_FONT_12;
        _messageLabel.textColor = UI_COLOR_B1;
        [self.contentView addSubview:_messageLabel];
    }
    
    return self;
}

@end
