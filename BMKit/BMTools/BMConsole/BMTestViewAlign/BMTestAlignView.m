//
//  BMTestAlignView.m
//  fengshun
//
//  Created by jiang deng on 2018/11/28.
//  Copyright © 2018 FS. All rights reserved.
//

#import "BMTestAlignView.h"
#import "BMSingleLineView.h"

static const CGFloat kImageIconSize = 32.0f;

@interface BMTestAlignView ()

@property (nonatomic, strong) UIImageView *sightImageView;

// 水平线
@property (nonatomic, strong) BMSingleLineView *horizontalLine;
// 垂直线
@property (nonatomic, strong) BMSingleLineView *verticalLine;

// 与SCREEN边框的距离
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UILabel *bottomLabel;

@end


@implementation BMTestAlignView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT);
        self.backgroundColor = [UIColor clearColor];
        self.layer.zPosition = FLT_MAX;
        //self.userInteractionEnabled = NO;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kImageIconSize, kImageIconSize)];
        imageView.image = [UIImage imageNamed:@"testalignsight_icon"];
        //[imageView bm_roundedRect:kImageIconSize*0.5f borderWidth:1 borderColor:[UIColor orangeColor]];
        
        [self addSubview:imageView];
        self.sightImageView = imageView;
        [imageView bm_centerInSuperView];
        
        imageView.userInteractionEnabled = YES;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveSight:)];
        [imageView addGestureRecognizer:pan];
        
        CGRect frame = CGRectMake(0, imageView.bm_centerY-0.25f, self.bm_width, 1.0f);
        BMSingleLineView *singleLineView = [[BMSingleLineView alloc] initWithFrame:frame];
        singleLineView.lineWidth = 1.0f;
        singleLineView.lineColor = [UIColor bm_colorWithHex:0xF01010 alpha:0.6f];
        singleLineView.needGap = NO;
        [self addSubview:singleLineView];
        self.horizontalLine = singleLineView;

        frame = CGRectMake(imageView.bm_centerX-0.25f, 0, 1.0f, self.bm_height);
        singleLineView = [[BMSingleLineView alloc] initWithFrame:frame direction:SingleLineDirectionPortait];
        singleLineView.lineWidth = 1.0f;
        singleLineView.lineColor = [UIColor bm_colorWithHex:0xF01010 alpha:0.6f];
        singleLineView.needGap = NO;
        [self addSubview:singleLineView];
        self.verticalLine = singleLineView;
        
        [self bringSubviewToFront:imageView];

        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = [UIColor bm_colorWithHex:0x666666];
        label.text = [[[NSDecimalNumber alloc] initWithFloat:self.sightImageView.bm_centerX] bm_stringWithNoStyleDecimalNozeroScale:2];
        [self addSubview:label];
        [label sizeToFit];
        label.bm_centerX = self.sightImageView.bm_centerX*0.5f;
        label.bm_top = self.sightImageView.bm_centerY-label.bm_height;
        self.leftLabel = label;
        
        label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = [UIColor bm_colorWithHex:0x666666];
        label.text = [[[NSDecimalNumber alloc] initWithFloat:self.sightImageView.bm_centerY] bm_stringWithNoStyleDecimalNozeroScale:2];
        [self addSubview:label];
        [label sizeToFit];
        label.bm_centerX = self.sightImageView.bm_centerX-label.bm_width*0.5f;
        label.bm_top = self.sightImageView.bm_centerY*0.5f;
        self.topLabel = label;

        label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = [UIColor bm_colorWithHex:0x666666];
        label.text = [[[NSDecimalNumber alloc] initWithFloat:self.bm_width-self.sightImageView.bm_centerX] bm_stringWithNoStyleDecimalNozeroScale:2];
        [self addSubview:label];
        [label sizeToFit];
        label.bm_centerX = self.sightImageView.bm_centerX*1.5f;
        label.bm_top = self.sightImageView.bm_centerY+1.0f;
        self.rightLabel = label;

        label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = [UIColor bm_colorWithHex:0x666666];
        label.text = [[[NSDecimalNumber alloc] initWithFloat:self.bm_height-self.sightImageView.bm_centerY] bm_stringWithNoStyleDecimalNozeroScale:2];
        [self addSubview:label];
        [label sizeToFit];
        label.bm_centerX = self.sightImageView.bm_centerX+label.bm_width*0.5f;
        label.bm_top = self.sightImageView.bm_centerY*1.5f;
        self.bottomLabel = label;
    }
    
    return self;
}

- (void)moveSight:(UIPanGestureRecognizer *)sender
{
    //1、获得拖动位移
    CGPoint offsetPoint = [sender translationInView:sender.view];
    //2、清空拖动位移
    [sender setTranslation:CGPointZero inView:sender.view];
    //3、重新设置控件位置
    UIView *panView = sender.view;
    CGFloat newX = panView.bm_centerX+offsetPoint.x;
    CGFloat newY = panView.bm_centerY+offsetPoint.y;
    
    CGPoint centerPoint = CGPointMake(newX, newY);
    panView.center = centerPoint;
    
    CGRect frame = CGRectMake(0, self.sightImageView.bm_centerY-0.25f, self.bm_width, 1.0f);
    self.horizontalLine.frame = frame;
    
    frame = CGRectMake(self.sightImageView.bm_centerX-0.25f, 0, 1.0f, self.bm_height);
    self.verticalLine.frame = frame;
    
    self.leftLabel.text = [[[NSDecimalNumber alloc] initWithFloat:self.sightImageView.bm_centerX] bm_stringWithNoStyleDecimalNozeroScale:2];
    [self.leftLabel sizeToFit];
    self.leftLabel.bm_centerX = self.sightImageView.bm_centerX*0.5f;
    self.leftLabel.bm_top = self.sightImageView.bm_centerY-self.leftLabel.bm_height;
    
    self.topLabel.text = [[[NSDecimalNumber alloc] initWithFloat:self.sightImageView.bm_centerY] bm_stringWithNoStyleDecimalNozeroScale:2];
    [self.topLabel sizeToFit];
    self.topLabel.bm_centerX = self.sightImageView.bm_centerX-self.topLabel.bm_width*0.5f;
    self.topLabel.bm_top = self.sightImageView.bm_centerY*0.5f;
    
    self.rightLabel.text = [[[NSDecimalNumber alloc] initWithFloat:self.bm_width-self.sightImageView.bm_centerX] bm_stringWithNoStyleDecimalNozeroScale:2];
    [self.rightLabel sizeToFit];
    self.rightLabel.bm_centerX = (self.bm_width+self.sightImageView.bm_centerX)*0.5f;
    self.rightLabel.bm_top = self.sightImageView.bm_centerY+1.0f;
    
    self.bottomLabel.text = [[[NSDecimalNumber alloc] initWithFloat:self.bm_height-self.sightImageView.bm_centerY] bm_stringWithNoStyleDecimalNozeroScale:2];
    [self.bottomLabel sizeToFit];
    self.bottomLabel.bm_centerX = self.sightImageView.bm_centerX+self.bottomLabel.bm_width*0.5f;
    self.bottomLabel.bm_top = (self.bm_height+self.sightImageView.bm_centerY)*0.5f;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(self.sightImageView.frame, point))
    {
        return YES;
    }
    
    return NO;
}

@end
