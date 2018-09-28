//
//  FSScrollPageSegment.m
//  match
//
//  Created by dengjiang on 15/9/22.
//  Copyright (c) 2015年 SCD. All rights reserved.
//

#import "FSScrollPageSegment.h"
#import "BMSingleLineView.h"


#define BUTTON_LEFTGAP 0.0f
#define BUTTON_GAP 30.0f
#define BUTTON_FONTSIZE 16.0f
#define BUTTON_MINWIDTH 30.0f

#define GAPLINE_INDENT 10.0f
#define GAPLINE_WIDTH 2.0f
#define SEGMENT_LINE_COLOR UI_COLOR_B6

#define BUTTON_START_TAG 100
#define CIRCLE_RADIUS 10.0f


@interface
FSScrollPageSegment ()
{
    NSUInteger s_CurrentIndex;
    
    CGFloat leftGap;
}

// 存储btn
@property (nonatomic, strong) NSMutableArray *m_BtnArray;
// 存储分割线
@property (nonatomic, strong) NSMutableArray *m_gaplineArray;

// 整体的滚动View
@property (nonatomic, strong) UIScrollView *m_BackScrollView;

@property (nonatomic, strong) BMSingleLineView *m_UnderLineView;

// 可滚动的线
@property (nonatomic, strong) UIView *m_MoveLine;

// 是否平分segment
@property (nonatomic, assign) BOOL m_IsEqualDivide;

// 是否显示分割线
@property (nonatomic, assign) BOOL m_ShowGapline;

// 是否显示顶部线条
@property (nonatomic, assign) BOOL m_ShowTopline;

@end


@implementation FSScrollPageSegment


#pragma mark - init Method

+(instancetype)attachedSegmentWithFrame:(CGRect)frame showUnderLine:(BOOL)showUnderLine showTopline:(BOOL)showTopline moveLineFrame:(CGRect)moveLineFrame isEqualDivide:(BOOL)isEqualDivide showGapline:(BOOL)showGapline
{
    return [[self alloc]initWithFrame:frame titles:nil titleColor:nil selectTitleColor:nil showUnderLine:showUnderLine moveLineFrame:moveLineFrame isEqualDivide:isEqualDivide fresh:NO showTopline:showTopline showGapline:showGapline];
}
- (instancetype)initWithTitles:(NSArray *)titles titleColor:(UIColor *)titleColor selectTitleColor:(UIColor *)selectTitleColor
{
    return [self initWithTitles:titles titleColor:titleColor selectTitleColor:selectTitleColor isEqualDivide:NO];
}

- (instancetype)initWithTitles:(NSArray *)titles titleColor:(UIColor *)titleColor selectTitleColor:(UIColor *)selectTitleColor isEqualDivide:(BOOL)isEqualDivide
{
    return [self initWithTitles:titles titleColor:titleColor selectTitleColor:selectTitleColor titleFontSize:BUTTON_FONTSIZE isEqualDivide:isEqualDivide];
}

- (instancetype)initWithTitles:(NSArray *)titles titleColor:(UIColor *)titleColor selectTitleColor:(UIColor *)selectTitleColor titleFontSize:(CGFloat)fontSize isEqualDivide:(BOOL)isEqualDivide
{
    CGRect frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, FSScrollPageSegment_Height);

    return [self initWithFrame:frame titles:titles titleColor:titleColor selectTitleColor:selectTitleColor showUnderLine:YES moveLineFrame:CGRectZero isEqualDivide:isEqualDivide fresh:YES];
}

- (instancetype)initWithFrame:(CGRect)frame moveLineFrame:(CGRect)moveLineFrame isEqualDivide:(BOOL)isEqualDivide
{
    return [self initWithFrame:frame titles:nil titleColor:nil selectTitleColor:nil showUnderLine:NO moveLineFrame:moveLineFrame isEqualDivide:isEqualDivide fresh:NO];
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles titleColor:(UIColor *)titleColor selectTitleColor:(UIColor *)selectTitleColor showUnderLine:(BOOL)showUnderLine moveLineFrame:(CGRect)moveLineFrame isEqualDivide:(BOOL)isEqualDivide fresh:(BOOL)fresh
{
    return [self initWithFrame:frame titles:titles titleColor:titleColor selectTitleColor:selectTitleColor showUnderLine:showUnderLine moveLineFrame:moveLineFrame isEqualDivide:isEqualDivide fresh:fresh showTopline:NO showGapline:YES];
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles titleColor:(UIColor *)titleColor selectTitleColor:(UIColor *)selectTitleColor showUnderLine:(BOOL)showUnderLine moveLineFrame:(CGRect)moveLineFrame isEqualDivide:(BOOL)isEqualDivide fresh:(BOOL)fresh showTopline:(BOOL)showTopline showGapline:(BOOL)showGapline
{
    self = [super initWithFrame:frame];
    if (self)
    {
        s_CurrentIndex = 0;

        self.m_BtnArray = [NSMutableArray arrayWithCapacity:0];
        self.m_gaplineArray = [NSMutableArray array];

        self.backgroundColor = [UIColor clearColor];

        self.m_IsEqualDivide = isEqualDivide;

        self.m_ShowTopline = showTopline;
        self.m_ShowGapline = showGapline;

        // 添加顶部线条
        if (showTopline)
        {
            BMSingleLineView *topline = [[BMSingleLineView alloc]initWithFrame:CGRectMake(0, 0, self.bm_width, 1) direction:SingleLineDirectionLandscape];
            topline.lineColor = SEGMENT_LINE_COLOR;
            [self addSubview:topline];
        }
        //add xl 添加下划线
        CGRect underLineFrame          = CGRectMake(0, self.bm_height - 1, self.bm_width, 1);
        self.m_UnderLineView           = [[BMSingleLineView alloc] initWithFrame:underLineFrame];
        self.m_UnderLineView.lineColor = SEGMENT_LINE_COLOR;
        [self addSubview:self.m_UnderLineView];
        // 默认隐藏下划线
        self.m_UnderLineView.hidden = !showUnderLine;

        // Btn的滚动背景
        self.m_BackScrollView                                = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bm_width, self.bm_height)];
        self.m_BackScrollView.backgroundColor                = [UIColor clearColor];
        self.m_BackScrollView.scrollEnabled                  = NO;
        self.m_BackScrollView.showsHorizontalScrollIndicator = NO;
        self.m_BackScrollView.scrollsToTop                   = NO;
        [self addSubview:self.m_BackScrollView];
        self.m_BackScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

        // 滚动线
        if (CGRectIsEmpty(moveLineFrame))
        {
            moveLineFrame = CGRectMake(0, self.bm_height - 2, 10, 2);
        }
        self.m_MoveLine                 = [[UIView alloc] initWithFrame:moveLineFrame];
        self.m_MoveLine.backgroundColor = UI_COLOR_R1;
        [self.m_BackScrollView addSubview:self.m_MoveLine];

        if (fresh)
        {
            [self freshButtonWithTitles:titles titleColor:titleColor selectTitleColor:selectTitleColor];
        }
    }

    return self;
}


- (void)freshButtonWithTitles:(NSArray *)titleArray titleColor:(UIColor *)titleColor selectTitleColor:(UIColor *)selectTitleColor
{
    [self freshButtonWithTitles:titleArray titleColor:titleColor selectTitleColor:selectTitleColor titleFontSize:BUTTON_FONTSIZE];
}

- (void)freshButtonWithTitles:(NSArray *)titleArray titleColor:(UIColor *)titleColor selectTitleColor:(UIColor *)selectTitleColor titleFontSize:(CGFloat)fontSize
{
    // 移除Btn
    for (UIButton *btn in self.m_BtnArray)
    {
        if (btn.superview)
        {
            [btn removeFromSuperview];
        }
    }

    [self.m_BtnArray removeAllObjects];
    // 移除分割线
    for (UIView *line in self.m_gaplineArray)
    {
        if (line.subviews)
        {
            [line removeFromSuperview];
        }
    }
    [self.m_BtnArray removeAllObjects];
    CGFloat x           = 0;
    CGFloat buttonWidth = 0;
    if (self.m_IsEqualDivide)
    {
        buttonWidth = (self.bm_width - titleArray.count + 1) / titleArray.count;
        if (buttonWidth < BUTTON_MINWIDTH)
        {
            buttonWidth = BUTTON_MINWIDTH;
        }

        for (NSUInteger i = 0; i < titleArray.count; i++)
        {
            NSString *title = titleArray[i];
            CGRect    frame = CGRectMake(x, 0, buttonWidth, self.bm_height);
            x += buttonWidth;

            UIButton *btn       = [[UIButton alloc] initWithFrame:frame];
            btn.backgroundColor = [UIColor clearColor];
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn.exclusiveTouch = YES;
            [btn setTitle:title forState:UIControlStateNormal];
            [btn setTitleColor:titleColor forState:UIControlStateNormal];
            [btn setTitleColor:selectTitleColor forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
            //[btn.titleLabel sizeToFit];
            btn.tag = i + BUTTON_START_TAG;

            [self.m_BackScrollView addSubview:btn];
            [self.m_BtnArray addObject:btn];
            if (self.m_ShowGapline&&i != titleArray.count-1) {
                [self addGaplineWithStartX:x];
            }
        }

        self.m_BackScrollView.contentSize = CGSizeMake(x, self.m_BackScrollView.bm_height);
    }
    else
    {
        x = BUTTON_LEFTGAP;
        // 创建Btn
        for (NSUInteger i = 0; i < titleArray.count; i++)
        {
            NSString *title = titleArray[i];

            CGSize btnSize = [title sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]}];
            buttonWidth    = btnSize.width + BUTTON_GAP;

            CGRect frame = CGRectMake(x, 0, buttonWidth, self.bm_height);
            x += buttonWidth;

            UIButton *btn       = [[UIButton alloc] initWithFrame:frame];
            btn.backgroundColor = [UIColor clearColor];
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn.exclusiveTouch = YES;
            [btn setTitle:title forState:UIControlStateNormal];
            [btn setTitleColor:titleColor forState:UIControlStateNormal];
            [btn setTitleColor:selectTitleColor forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
            //[btn.titleLabel sizeToFit];
            btn.tag = i + BUTTON_START_TAG;
    
            [self.m_BackScrollView addSubview:btn];
            [self.m_BtnArray addObject:btn];
            if (self.m_ShowGapline&&i != titleArray.count-1) {
                [self addGaplineWithStartX:x];
            }
        }
        self.m_BackScrollView.contentSize = CGSizeMake(x + BUTTON_GAP / 2, self.m_BackScrollView.bm_height);
    }
}

- (void)addGaplineWithStartX:(CGFloat)startX
{
    BMSingleLineView *gapline = [[BMSingleLineView alloc]initWithFrame:CGRectMake(startX, GAPLINE_INDENT, GAPLINE_WIDTH, self.bm_height - 2*GAPLINE_INDENT) direction:SingleLineDirectionPortait];
    gapline.lineColor = SEGMENT_LINE_COLOR;
    gapline.needGap = NO;
    gapline.lineWidth = GAPLINE_WIDTH;
    [self.m_BackScrollView addSubview:gapline];
    [self.m_gaplineArray addObject:gapline];
}

- (void)setMoveLineColor:(UIColor *)movelineColor
{
    if (movelineColor)
    {
        self.m_MoveLine.backgroundColor = movelineColor;
    }
    else
    {
        self.m_MoveLine.backgroundColor = UI_COLOR_Y1;
    }
}

- (void)setM_TextColor:(UIColor *)textColor
{
    if (textColor == nil)
    {
        textColor = [UIColor whiteColor];
    }

    for (UIButton *btn in self.m_BtnArray)
    {
        [btn setTitleColor:textColor forState:UIControlStateNormal];
    }
}

- (void)setM_SelectTextColor:(UIColor *)selectTextColor
{
    if (selectTextColor == nil)
    {
        selectTextColor = [UIColor redColor];
    }

    for (UIButton *btn in self.m_BtnArray)
    {
        [btn setTitleColor:selectTextColor forState:UIControlStateSelected];
    }
}

- (void)setM_TextFontSize:(CGFloat)textFontSize
{
    if (!self.m_IsEqualDivide)
    {
        return;
    }
    
    if (textFontSize < 8.0f)
    {
        textFontSize = 8.0f;
    }
    
    for (UIButton *btn in self.m_BtnArray)
    {
        btn.titleLabel.font = [UIFont systemFontOfSize:textFontSize];
    }
}

- (void)setM_IsHiddenUnderLine:(BOOL)isHiddenUnderLine
{
    self.m_UnderLineView.hidden = isHiddenUnderLine;
}

#pragma mark - public Method

// 滚动完成之后调用：调整Btn显示
- (void)selectBtnAtIndex:(NSUInteger)index
{
    if (index < self.m_BtnArray.count)
    {
        UIButton *btn = self.m_BtnArray[index];
        [self selectBtn:btn];
    }
}

/*
// 滚动之中调用：调整line位置和大小
- (void)scrollLineFromIndex:(NSInteger)fromIndex relativeOffsetX:(CGFloat)relativeOffsetX
{
    BOOL isLeft = relativeOffsetX < 0 ? YES : NO;
    NSInteger toIndex = 0;
 
    for (NSInteger i=1; i<self.m_BtnArray.count; i++)
    {
        if (i >= fabs(relativeOffsetX))
        {
            toIndex = isLeft ? (fromIndex - i) : (fromIndex + i);
            break;
        }
    }
 
//        LLog(@"fromIndex %ld", (long)fromIndex);
//        LLog(@"toIndex %ld", (long)toIndex);
//        LLog(@"relativeOffsetX %f", relativeOffsetX);
 
    if (toIndex != fromIndex && toIndex >=0 && toIndex < self.m_BtnArray.count)
    {
        UIButton *toBtn = self.m_BtnArray[toIndex];
 
        //self.m_MoveView.centerX = toBtn.centerX;
        //[self.m_MoveView centerInRect:toBtn.frame];
    }
}

- (void)scrollLineFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    if (toIndex != fromIndex && toIndex >=0 && toIndex < self.m_BtnArray.count)
    {
        UIButton *toBtn = self.m_BtnArray[toIndex];
 
        //self.m_MoveView.centerX = toBtn.centerX;
        //[self.m_MoveView centerInRect:toBtn.frame];
    }
}
*/

// 判断是否通过点击btn出发的滚动
- (BOOL)isClickBtnWithScroll:(NSUInteger)index
{
    if (index < self.m_BtnArray.count)
    {
        UIButton *currentBtn = self.m_BtnArray[index];
        return !currentBtn.userInteractionEnabled;
    }

    return NO;
}


#pragma mark - private Method

// 点击某个Btn
- (void)selectBtn:(UIButton *)btn
{
    if (s_CurrentIndex < self.m_BtnArray.count)
    {
        UIButton *currentBtn = self.m_BtnArray[s_CurrentIndex];
        currentBtn.selected  = NO;
    }

    btn.userInteractionEnabled = NO;
    btn.selected               = YES;
    s_CurrentIndex             = btn.tag - BUTTON_START_TAG;

    [self scrollLine:btn];
}

- (void)clickBtn:(UIButton *)btn
{
    [self selectBtn:btn];

    if ([self.delegate respondsToSelector:@selector(scrollSegment:selectedButtonAtIndex:)])
    {
        [self.delegate scrollSegment:self selectedButtonAtIndex:s_CurrentIndex];
    }
}

// 滚动Line
- (void)scrollLine:(UIButton *)btn
{
    CGFloat x = btn.bm_centerX;
    CGFloat lineW;
    if (self.m_IsEqualDivide)
    {
        lineW = btn.bm_width;
    }
    else
    {
        lineW = [btn.titleLabel.text bm_widthToFitHeight:btn.bm_height withFont:[UIFont systemFontOfSize:BUTTON_FONTSIZE]];
    }

    [UIView animateWithDuration:0.25
        animations:^{

            self.m_MoveLine.bm_width   = lineW;
            self.m_MoveLine.bm_centerX = x;

        }
        completion:^(BOOL finished) {
            if (finished)
            {
                btn.userInteractionEnabled = YES;

                [self scrollBack:btn];
            }
        }];
}

// 调整背景位置
- (void)scrollBack:(UIButton *)btn
{
    // 如果当前显示的最右侧一个Btn超出右边界
    if (self.m_BackScrollView.contentOffset.x + self.m_BackScrollView.bm_width < btn.bm_right)
    {
        // 向左滚动视图，显示完整Btn
        [self.m_BackScrollView setContentOffset:CGPointMake(btn.bm_right - self.m_BackScrollView.bm_width, 0) animated:YES];
    }
    // 如果当前显示的最左侧一个Btn超出左边界
    else if (self.m_BackScrollView.contentOffset.x > btn.bm_left)
    {
        // 向右滚动视图，显示完整Btn
        [self.m_BackScrollView setContentOffset:CGPointMake(btn.bm_left, 0) animated:YES];
    }
}

@end
