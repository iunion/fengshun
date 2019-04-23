//
//  BMAddressChooseView.m
//  BMBaseKit
//
//  Created by jiang deng on 2019/4/1.
//  Copyright © 2019 BM. All rights reserved.
//

#import "BMAddressChooseView.h"
#import "BMSingleLineView.h"

#define addressBtnTag   1000

static CGFloat const addressItemMargin = 20.0f;

@interface BMAddressChooseView ()

@property (nonatomic, strong) NSMutableArray *btnArray;

@property (nonatomic, assign) NSUInteger level;
@property (nonatomic, assign) NSUInteger maxLevel;

@property (nonatomic, strong) BMSingleLineView *separateLine;

@end

@implementation BMAddressChooseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
        [self makeView];
    }
    
    return self;
}

- (void)initialize
{
    self.btnArray = [[NSMutableArray alloc] initWithCapacity:3];
    
    self.level = 0;
    self.maxLevel = 1;
}

- (void)makeView
{
    self.backgroundColor = [UIColor whiteColor];
    
    for (NSUInteger i=0; i<3; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        btn.tag = addressBtnTag+i;
        [btn addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.btnArray addObject:btn];
        
        [self addSubview:btn];
    }
    
    // 下边线
    BMSingleLineView *bottomLine = [[BMSingleLineView alloc] initWithFrame:CGRectMake(0, self.bm_height-1, self.bm_width, 1) direction:SingleLineDirectionLandscape];
    bottomLine.lineColor = UI_DEFAULT_LINECOLOR;
    bottomLine.needGap = YES;
    [self addSubview:bottomLine];
    
    BMSingleLineView *separateLine = [[BMSingleLineView alloc] initWithFrame:CGRectMake(0, self.bm_height-1, 1, 1) direction:SingleLineDirectionLandscape];
    separateLine.lineColor = [UIColor redColor];
    separateLine.needGap = YES;
    [self addSubview:separateLine];
    self.separateLine = separateLine;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    for (UIButton *btn in self.btnArray)
    {
        btn.hidden = YES;
        btn.selected = NO;
        self.maxLevel = 1;
    }
    
    //if (self.chooseAddress)
    {
        UIButton *btn1 = self.btnArray[0];
        UIButton *btn2 = self.btnArray[1];
        UIButton *btn3 = self.btnArray[2];
        
        btn1.hidden = NO;
        if ([self.chooseAddress.province.name bm_isNotEmpty])
        {
            self.maxLevel = 2;
             [btn1 setTitle:self.chooseAddress.province.name forState:UIControlStateNormal];
            
            [btn1 sizeToFit];
            btn1.bm_centerY = self.bm_height * 0.5f;
            btn1.bm_left = 15.0f;

            btn2.hidden = NO;
            if ([self.chooseAddress.city.name bm_isNotEmpty])
            {
                self.maxLevel = 3;
                [btn2 setTitle:self.chooseAddress.city.name forState:UIControlStateNormal];
                
                [btn2 sizeToFit];
                btn2.bm_centerY = self.bm_height * 0.5f;
                btn2.bm_left = btn1.bm_right + addressItemMargin;

                btn3.hidden = NO;
                if ([self.chooseAddress.area.name bm_isNotEmpty])
                {
                    [btn3 setTitle:self.chooseAddress.area.name forState:UIControlStateNormal];
                    
                    [btn3 sizeToFit];
                    btn3.bm_centerY = self.bm_height * 0.5f;
                    btn3.bm_left = btn2.bm_right + addressItemMargin;
                }
                else
                {
                    [btn3 setTitle:@"请选择" forState:UIControlStateNormal];
                    
                    [btn3 sizeToFit];
                    btn3.bm_centerY = self.bm_height * 0.5f;
                    btn3.bm_left = btn2.bm_right + addressItemMargin;
                }
            }
            else
            {
                [btn2 setTitle:@"请选择" forState:UIControlStateNormal];
                
                [btn2 sizeToFit];
                btn2.bm_centerY = self.bm_height * 0.5f;
                btn2.bm_left = btn1.bm_right + addressItemMargin;
            }
        }
        else
        {
            [btn1 setTitle:@"请选择" forState:UIControlStateNormal];
            
            [btn1 sizeToFit];
            btn1.bm_centerY = self.bm_height * 0.5f;
            btn1.bm_left = 15.0f;
        }
    }
    
    UIButton *btn = self.btnArray[self.level];
    btn.selected = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.separateLine.bm_left = btn.bm_left;
        self.separateLine.bm_width = btn.bm_width;
    }];
}

- (void)clicked:(UIButton *)btn
{
    NSUInteger btnIndex = btn.tag - addressBtnTag;
    
    if (btnIndex == self.level)
    {
        return;
    }
    
    self.level = btnIndex;
    
    [self setNeedsDisplay];
    
    if (self.addressClicked)
    {
        self.addressClicked(self.chooseAddress, self.level);
    }
}

- (void)setChooseAddress:(BMChooseAddressModel *)chooseAddress
{
    _chooseAddress = chooseAddress;
    
    [self setNeedsDisplay];
}

- (void)setChooseAddress:(BMChooseAddressModel *)chooseAddress level:(NSUInteger)level
{
    self.level = level;
    self.chooseAddress = chooseAddress;
}

@end
