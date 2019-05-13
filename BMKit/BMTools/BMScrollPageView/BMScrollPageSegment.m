//
//  BMScrollPageSegment.m
//  BMBaseKit
//
//  Created by jiang deng on 2019/1/31.
//  Copyright © 2019 BM. All rights reserved.
//

#import "BMScrollPageSegment.h"
#import "BMSingleLineView.h"

#define LINE_COLOR          UI_DEFAULT_LINECOLOR

#define BUTTON_START_TAG    100
#define BUTTON_MINWIDTH     30.0f
#define BUTTON_GAP          30.0f
#define BUTTON_FONTSIZE     16.0f

#define GAPLINE_INDENT      10.0f
#define GAPLINE_WIDTH       2.0f

@interface BMScrollPageSegment ()

// 标题数据
@property (nonatomic, strong) NSMutableArray *titleArray;

// 当前位置index
@property (nonatomic, assign) NSUInteger currentIndex;

// 存储btn
@property (nonatomic, strong) NSMutableArray *btnArray;
// 存储分割线
@property (nonatomic, strong) NSMutableArray *gaplineArray;

@property (nonatomic, strong) UIScrollView *itemScrollView;

// 标记线
@property (nonatomic, strong) UIView *moveLine;

// 上边线
@property (nonatomic, strong) BMSingleLineView *topLine;
// 下边线
@property (nonatomic, strong) BMSingleLineView *bottomLine;

// 编辑按钮
@property (nonatomic, strong) UIButton *moreBtn;

@end

@implementation BMScrollPageSegment


#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    
    return self;
}

- (void)initialize
{
    self.currentIndex = 0;
    
    self.btnArray = [NSMutableArray arrayWithCapacity:0];
    self.gaplineArray = [NSMutableArray array];

    self.titleColor = [UIColor blackColor];
    self.titleSelectedColor = [UIColor redColor];
    self.titleFont = [UIFont systemFontOfSize:16.0f];
    
    self.topLineColor = LINE_COLOR;
    self.showTopLine = NO;
    self.bottomLineColor = LINE_COLOR;
    self.showBottomLine = YES;
    
    self.gapLineColor = LINE_COLOR;
    self.showGapLine = YES;
    
    self.showMore = NO;

    self.equalDivide = YES;

    [self makeView];
}


#pragma mark -
#pragma mark makeView

- (void)makeView
{
    //self.backgroundColor = [UIColor clearColor];

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bm_width, self.bm_height)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.scrollEnabled = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    [self addSubview:scrollView];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.itemScrollView = scrollView;

    // 上边线
    BMSingleLineView *topLine = [[BMSingleLineView alloc] initWithFrame:CGRectMake(0, 0, self.bm_width, 1) direction:SingleLineDirectionLandscape];
    topLine.lineColor = LINE_COLOR;
    topLine.needGap = NO;
    topLine.hidden = YES;
    [self addSubview:topLine];
    self.topLine = topLine;

    // 下边线
    BMSingleLineView *bottomLine = [[BMSingleLineView alloc] initWithFrame:CGRectMake(0, self.bm_height-1, self.bm_width, 1) direction:SingleLineDirectionLandscape];
    bottomLine.lineColor = LINE_COLOR;
    bottomLine.needGap = YES;
    [self addSubview:bottomLine];
    self.bottomLine = bottomLine;

    // 标记线
    UIView *moveLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.bm_height-2, 20, 2)];
    moveLine.backgroundColor = [UIColor redColor];
    [self.itemScrollView addSubview:moveLine];
    self.moveLine = moveLine;
    
    // 编辑按钮
    UIButton *moreBtn = [UIButton bm_buttonWithFrame:CGRectMake(self.bm_width-self.bm_height, 0, self.bm_height, self.bm_height) imageName:@"segmentmore"];
    [moreBtn addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
    moreBtn.hidden = YES;
    [self addSubview:moreBtn];
    self.moreBtn = moreBtn;
}


#pragma mark -
#pragma mark setter / getter

- (void)setTitleColor:(UIColor *)titleColor
{
    if (titleColor == nil)
    {
        titleColor = [UIColor blackColor];
    }

    _titleColor = titleColor;
    
    for (UIButton *btn in self.btnArray)
    {
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
    }
}

- (void)setTitleSelectedColor:(UIColor *)titleSelectedColor
{
    if (titleSelectedColor == nil)
    {
        titleSelectedColor = [UIColor redColor];
    }
    
    _titleSelectedColor = titleSelectedColor;
    
    for (UIButton *btn in self.btnArray)
    {
        [btn setTitleColor:titleSelectedColor forState:UIControlStateSelected];
    }
}

- (void)setTitleFont:(UIFont *)titleFont
{
    if (titleFont == nil)
    {
        titleFont = [UIFont systemFontOfSize:16.0f];
    }
    
    _titleFont = titleFont;
    
    if (self.equalDivide)
    {
        for (UIButton *btn in self.btnArray)
        {
            btn.titleLabel.font = titleFont;
        }
    }
    else
    {
        [self freshItems];
    }
}

- (void)setMoveLineColor:(UIColor *)moveLineColor
{
    if (moveLineColor == nil)
    {
        moveLineColor = [UIColor redColor];
    }
    
    _moveLineColor = moveLineColor;
    
    self.moveLine.backgroundColor = moveLineColor;
}

- (void)setShowMoveLine:(BOOL)showMoveLine
{
    _showMoveLine = showMoveLine;
    self.moveLine.hidden = !showMoveLine;
}

- (void)setTopLineColor:(UIColor *)topLineColor
{
    if (topLineColor == nil)
    {
        topLineColor = LINE_COLOR;
    }
    
    _topLineColor = topLineColor;
    
    self.topLine.lineColor = topLineColor;
}

- (void)setShowTopLine:(BOOL)showTopLine
{
    _showTopLine = showTopLine;
    self.topLine.hidden = !showTopLine;
}

- (void)setBottomLineColor:(UIColor *)bottomLineColor
{
    if (bottomLineColor == nil)
    {
        bottomLineColor = LINE_COLOR;
    }
    
    _bottomLineColor = bottomLineColor;
    
    self.bottomLine.lineColor = bottomLineColor;
}

- (void)setShowBottomLine:(BOOL)showBottomLine
{
    _showBottomLine = showBottomLine;
    self.bottomLine.hidden = !showBottomLine;
}

- (void)setMoreImage:(NSString *)moreImage
{
    UIImage *image = [UIImage imageNamed:moreImage];
    if (!image)
    {
        image = [UIImage imageNamed:@"segmentmore"];
    }
    [self.moreBtn setImage:image forState:UIControlStateNormal];
}

- (void)setShowMore:(BOOL)showMore
{
    if (_showMore == showMore)
    {
        return;
    }
    
    _showMore = showMore;
    self.moreBtn.hidden = !showMore;
    
    if (showMore)
    {
        self.itemScrollView.bm_width = self.bm_width - self.moreBtn.bm_width;
    }
    else
    {
        self.itemScrollView.bm_width = self.bm_width;
    }
    
    [self freshItems];
}

- (void)setGapLineColor:(UIColor *)gapLineColor
{
    if (gapLineColor == nil)
    {
        gapLineColor = LINE_COLOR;
    }
    
    _gapLineColor = gapLineColor;
    
    for (BMSingleLineView *gapLine in self.gaplineArray)
    {
        gapLine.lineColor = gapLineColor;
    }
}

- (void)setShowGapLine:(BOOL)showGapLine
{
    _showGapLine = showGapLine;
    for (BMSingleLineView *gapLine in self.gaplineArray)
    {
        gapLine.hidden = !showGapLine;
    }
}

- (void)setTitleArray:(NSMutableArray *)titleArray
{
    _titleArray = titleArray;
    
    [self freshItems];
}

- (void)setEqualDivide:(BOOL)equalDivide
{
    if (_equalDivide == equalDivide)
    {
        return;
    }
    
    _equalDivide = equalDivide;
    self.itemScrollView.scrollEnabled = !equalDivide;

    [self freshItems];
}

#pragma mark -
#pragma mark freshView

- (UIButton *)makeSegmentItemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor titleSelectedColor:(UIColor *)titleSelectedColor titleFont:(UIFont *)titleFont
{
    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.exclusiveTouch = YES;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setTitleColor:titleSelectedColor forState:UIControlStateSelected];
    btn.titleLabel.font = titleFont;
    
    return btn;
}

- (BMSingleLineView *)makeGaplineWithStartX:(CGFloat)startX
{
    BMSingleLineView *gapline = [[BMSingleLineView alloc] initWithFrame:CGRectMake(startX, GAPLINE_INDENT, GAPLINE_WIDTH, self.bm_height - 2*GAPLINE_INDENT) direction:SingleLineDirectionPortait];
    gapline.lineColor = LINE_COLOR;
    gapline.needGap = NO;
    gapline.lineWidth = GAPLINE_WIDTH;
    
    return gapline;
}

- (void)freshItemsWithTitles:(NSArray *)titleArray
{
    self.titleArray = [NSMutableArray arrayWithArray:titleArray];
}

- (void)freshItemsWithTitles:(NSArray *)titleArray titleColor:(UIColor *)titleColor titleSelectedColor:(UIColor *)titleSelectedColor titleFont:(UIFont *)titleFont
{
    self.titleColor = titleColor;
    self.titleSelectedColor = titleSelectedColor;
    self.titleFont = titleFont;

    self.titleArray = [NSMutableArray arrayWithArray:titleArray];
}

- (void)freshItems
{
    // 移除Btn
    for (UIButton *btn in self.btnArray)
    {
        if (btn.superview)
        {
            [btn removeFromSuperview];
        }
    }
    [self.btnArray removeAllObjects];
    
    // 移除分割线
    for (UIView *line in self.gaplineArray)
    {
        if (line.subviews)
        {
            [line removeFromSuperview];
        }
    }
    [self.gaplineArray removeAllObjects];
    
    if (![self.titleArray bm_isNotEmpty])
    {
        return;
    }
    
    CGFloat x = 0;
    CGFloat buttonWidth = self.itemScrollView.bm_width / self.titleArray.count;
    if (buttonWidth < BUTTON_MINWIDTH)
    {
        buttonWidth = BUTTON_MINWIDTH;
    }
        
    for (NSUInteger i = 0; i < self.titleArray.count; i++)
    {
        NSString *title = self.titleArray[i];
        
        UIButton *btn = [self makeSegmentItemWithTitle:title titleColor:self.titleColor titleSelectedColor:self.titleSelectedColor titleFont:self.titleFont];
        if (!self.equalDivide)
        {
            CGSize btnSize = [title sizeWithAttributes:@{NSFontAttributeName : self.titleFont}];
            buttonWidth = btnSize.width + BUTTON_GAP;
        }
        
        CGRect frame = CGRectMake(x, 0, buttonWidth, self.bm_height);
        x += buttonWidth;

        btn.frame = frame;
        btn.tag = i + BUTTON_START_TAG;

        [self.itemScrollView addSubview:btn];
        [self.btnArray addObject:btn];
        
        if (self.showGapLine && i != self.titleArray.count-1)
        {
            BMSingleLineView *gapline = [self makeGaplineWithStartX:x];
            
            [self.itemScrollView addSubview:gapline];
            [self.gaplineArray addObject:gapline];
        }
    }
    
    self.itemScrollView.contentSize = CGSizeMake(x, self.itemScrollView.bm_height);
}


#pragma mark - private Method

- (void)moreClick:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollSegmentSetSegments:)])
    {
        [self.delegate scrollSegmentSetSegments:self];
    }
}

// 点击事件，会联动响应
- (void)itemClick:(UIButton *)btn
{
    [self itemselected:btn];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollSegment:selectedItemAtIndex:)])
    {
        [self.delegate scrollSegment:self selectedItemAtIndex:self.currentIndex];
    }
}

// 调整定位
- (void)itemselected:(UIButton *)btn
{
    if (self.currentIndex < self.btnArray.count)
    {
        UIButton *currentBtn = self.btnArray[self.currentIndex];
        currentBtn.selected  = NO;
    }
    
    //btn.userInteractionEnabled = NO;
    btn.selected = YES;
    self.currentIndex = btn.tag - BUTTON_START_TAG;
    
    [self scrollMoveLineWithItem:btn];
}

// 滚动moveLine
- (void)scrollMoveLineWithItem:(UIButton *)btn
{
    CGFloat x = btn.bm_centerX;
    CGFloat lineWidth;
    if (self.equalDivide)
    {
        lineWidth = btn.bm_width;
    }
    else
    {
        lineWidth = [btn.titleLabel.text bm_widthToFitHeight:btn.bm_height withFont:[UIFont systemFontOfSize:BUTTON_FONTSIZE]];
    }
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         
                         self.moveLine.bm_width = lineWidth;
                         self.moveLine.bm_centerX = x;
                         
                     }
                     completion:^(BOOL finished) {
                         if (finished)
                         {
                             //btn.userInteractionEnabled = YES;
                             
                             [self scrollToShowItem:btn];
                         }
                     }];
}

// 调整背景位置
- (void)scrollToShowItem:(UIButton *)btn
{
    if (self.equalDivide)
    {
        return;
    }
    
    // 如果当前显示的最右侧一个Btn超出右边界
    if (self.itemScrollView.contentOffset.x + self.itemScrollView.bm_width < btn.bm_right)
    {
        // 向左滚动视图，显示完整Btn
        [self.itemScrollView setContentOffset:CGPointMake(btn.bm_right - self.itemScrollView.bm_width, 0) animated:YES];
    }
    // 如果当前显示的最左侧一个Btn超出左边界
    else if (self.itemScrollView.contentOffset.x > btn.bm_left)
    {
        // 向右滚动视图，显示完整Btn
        [self.itemScrollView setContentOffset:CGPointMake(btn.bm_left, 0) animated:YES];
    }
}


#pragma mark - public Method

// 只调整定位，不联动
- (void)selectItemAtIndex:(NSUInteger)index
{
    if (index < self.btnArray.count)
    {
        UIButton *btn = self.btnArray[index];
        [self itemselected:btn];
    }
}

@end
