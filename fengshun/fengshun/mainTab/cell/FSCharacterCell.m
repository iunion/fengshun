//
//  FSCharacterCell.m
//  fengshun
//
//  Created by 龚旭杰 on 2019/4/1.
//  Copyright © 2019年 FS. All rights reserved.
//

#import "FSCharacterCell.h"

@interface FSCharacterCell()

@property (weak, nonatomic) IBOutlet UIImageView *m_ImgView;
@property (weak, nonatomic) IBOutlet UILabel *m_NickNameLab;
@property (weak, nonatomic) IBOutlet UILabel *m_IdentyLab;


@end

@implementation FSCharacterCell

+ (CGFloat)cellHeight
{
    return 86.f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.m_ImgView bm_roundedRect:42/2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showWithModel:(FSColumModel *)model
{
    [self.m_ImgView sd_setImageWithURL:[NSURL URLWithString:model.m_HeaderUrl] placeholderImage:[UIImage imageNamed:@"default_avatariconlarge"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    self.m_NickNameLab.text = model.m_NikeName;
    self.m_IdentyLab.text = [NSString stringWithFormat:@"%@  %@",model.m_Organization,model.m_Position];
}

@end
