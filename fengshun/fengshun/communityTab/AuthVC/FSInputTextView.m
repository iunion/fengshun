//
//  FSInputTextView.m
//  fengshun
//
//  Created by BeSt2wa on 2018/12/21.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSInputTextView.h"

@interface FSInputTextView()

@property (weak, nonatomic) IBOutlet UILabel *m_TitleLab;

@property (weak, nonatomic) IBOutlet UITextField *m_contentTextfield;
@property (weak, nonatomic) IBOutlet UIView *m_BottomLine;



@end

@implementation FSInputTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title content:(NSString *)content placeHolder:(NSString *)placeholder
{
    self = [[NSBundle mainBundle]loadNibNamed:@"FSInputTextView" owner:self options:nil].firstObject;
    if (self) {
        self.frame = frame;
        self.m_Title = title;
        self.m_Content = content;
        self.m_PlaceHolder = placeholder;
        
        self.m_TitleLab.text = title;
        self.m_contentTextfield.text = content;
        self.m_contentTextfield.placeholder = placeholder;
    }
    return self;
}

- (void)setM_IsShowBottomLine:(BOOL)m_IsShowBottomLine
{
    self.m_BottomLine.hidden = !m_IsShowBottomLine;
}

- (NSString *)m_Title
{
    return _m_TitleLab.text;
}

- (void)setM_Title:(NSString *)m_Title
{
    _m_TitleLab.text = m_Title;
}

- (void)setM_PlaceHolder:(NSString *)m_PlaceHolder
{
    _m_contentTextfield.placeholder = m_PlaceHolder;
}

- (NSString *)m_Content
{
    return _m_contentTextfield.text;
}

- (void)setM_Content:(NSString *)m_Content
{
    _m_contentTextfield.text = m_Content;
}

@end
