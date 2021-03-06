//
//  BMAddressTableCell.m
//  fengshun
//
//  Created by jiang deng on 2019/4/3.
//  Copyright © 2019 FS. All rights reserved.
//

#import "BMAddressTableCell.h"
#import "BMAddressModel.h"

@interface BMAddressTableCell ()

@property (nonatomic, strong) BMAddressModel *addressModel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedIcon;

@end

@implementation BMAddressTableCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
    [self makeCellStyle];
}

- (void)makeCellStyle
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.nameLabel.textColor = [UIColor bm_colorWithHex:0x333333];
    self.nameLabel.font = [UIFont systemFontOfSize:15.0f];
}

- (UIColor *)normalColor
{
    if (!_normalColor)
    {
        _normalColor = [UIColor blackColor];
    }
    
    return _normalColor;
}

- (UIColor *)selectColor
{
    if (!_selectColor)
    {
        _selectColor = [UIColor redColor];
    }
    
    return _selectColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawCellWithModel:(BMAddressModel *)model
{
    self.addressModel = model;
    
    self.nameLabel.text = model.name;
    [self.nameLabel sizeToFit];
    
    self.nameLabel.textColor = model.isSelected ? self.selectColor : self.normalColor;

    self.nameLabel.bm_left = 15.0f;
    self.nameLabel.bm_centerY = self.contentView.bm_centerY;
    
    self.selectedIcon.image = [[UIImage imageNamed:@"address_selected"] bm_imageWithTintColor:self.selectColor];
    //self.selectedIcon.tintColor = self.selectColor;
    self.selectedIcon.bm_left = self.nameLabel.bm_right + 4.0f;
    self.selectedIcon.hidden = !model.isSelected;
}


@end
