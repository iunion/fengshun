//
//  BMTestNetFlowCell.m
//  fengshun
//
//  Created by jiang deng on 2018/12/13.
//  Copyright © 2018 FS. All rights reserved.
//

#import "BMTestNetFlowCell.h"
#import "BMSingleLineView.h"

@interface BMTestNetFlowCell ()

@property (nonatomic, strong) BMTestNetFlowHttpModel *httpModel;

@property (weak, nonatomic) IBOutlet UILabel *urlLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *flowLabel;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@end

@implementation BMTestNetFlowCell

+ (CGFloat)cellHeightWithModel:(BMTestNetFlowHttpModel *)model
{
    NSString *urlString = model.url;
    if ([urlString bm_isNotEmpty])
    {
        CGSize size = [urlString bm_sizeToFitWidth:UI_SCREEN_WIDTH-30.0f withFont:[UIFont systemFontOfSize:15.0f]];
        CGFloat height = size.height;
        if (height > 64.0f)
        {
            height = 64.0f;
        }
        return height+74.0f+24.0f;
    }

    return 162.0f;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
    [self makeCellStyle];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)makeCellStyle
{
    [self.typeLabel bm_roundedRect:self.typeLabel.bm_height*0.5];
    
    self.arrowImageView.image = [[UIImage imageNamed:@"BMTableView_arrows_rightBlack"] bm_imageWithTintColor:[UIColor bm_colorWithHex:0x666666]];
}

- (void)drawCellWithModel:(BMTestNetFlowHttpModel *)model
{
    self.httpModel = model;
    
    NSString *urlString = model.url;
    if ([urlString bm_isNotEmpty])
    {
        self.urlLabel.text = urlString;
        CGSize size = [self.urlLabel sizeThatFits:CGSizeMake(UI_SCREEN_WIDTH-30.0f, CGFLOAT_MAX)];
        CGFloat height = size.height;
        if (height > 64.0f)
        {
            height = 64.0f;
        }
        self.urlLabel.bm_height = height;
    }

    self.typeLabel.hidden = YES;
    self.stateLabel.hidden = YES;

    NSString *method = model.method;
    NSString *status = model.statusCode;

    CGFloat left = 0;
    if ([method bm_isNotEmpty])
    {
        NSString *mineType = model.mineType;
        if ([mineType bm_isNotEmpty])
        {
            self.typeLabel.text = [NSString stringWithFormat:@"  %@ > %@  ", method, mineType];
        }
        else
        {
            self.typeLabel.text = [NSString stringWithFormat:@"  %@  ", method];
        }
        [self.typeLabel sizeToFit];
        left = self.typeLabel.bm_right + 8.0f;
        self.typeLabel.bm_height = 24.0f;
        self.typeLabel.hidden = NO;
    }

    if ([status bm_isNotEmpty])
    {
        self.stateLabel.text = [NSString stringWithFormat:@"[%@]", status];
        [self.stateLabel sizeToFit];
        self.stateLabel.bm_left = left;
        self.stateLabel.bm_height = 24.0f;
        if ([status isEqualToString:@"200"])
        {
            self.stateLabel.textColor = [UIColor blackColor];
        }
        else
        {
            self.stateLabel.textColor = [UIColor redColor];
        }
        self.stateLabel.hidden = NO;
    }
    
    NSString *startTime = [NSDate bm_stringFromTs:model.startTime];
    NSString *time = model.totalDuration;
    self.startTimeLabel.text = startTime;
    [self.startTimeLabel sizeToFit];
    left = self.startTimeLabel.bm_right + 8.0f;

    self.timeLabel.text = [NSString stringWithFormat:@"%@:%@", @"耗时", time];
    [self.timeLabel sizeToFit];
    self.timeLabel.bm_left = left;
    
    NSString *uploadFlow = model.uploadFlow;
    NSString *downFlow = model.downFlow;
    if ([uploadFlow bm_isNotEmpty] || [downFlow bm_isNotEmpty])
    {
        NSMutableString *netflow = [NSMutableString string];
        NSUInteger uploadFlowLength = 0;
        NSUInteger downFlowLength = 0;
        if ([uploadFlow bm_isNotEmpty])
        {
            NSString *str = [NSString stringWithFormat:@"↑ %@ ", uploadFlow];
            uploadFlowLength = str.length;
            [netflow appendString:str];
        }
        if ([downFlow bm_isNotEmpty])
        {
            NSString *str = [NSString stringWithFormat:@"↓ %@", downFlow];
            downFlowLength = str.length;
            [netflow appendString:str];
        }
        
        NSMutableAttributedString *netflowAttr = [[NSMutableAttributedString alloc] initWithString:netflow];
        [netflowAttr bm_setFont:[UIFont systemFontOfSize:12.0f]];
        [netflowAttr bm_setTextColor:[UIColor redColor] range:NSMakeRange(0, uploadFlowLength)];
        [netflowAttr bm_setTextColor:[UIColor greenColor] range:NSMakeRange(uploadFlowLength, downFlowLength)];

        self.flowLabel.attributedText = netflowAttr;
    }
}

@end
