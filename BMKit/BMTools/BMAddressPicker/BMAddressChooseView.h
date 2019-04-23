//
//  BMAddressChooseView.h
//  BMBaseKit
//
//  Created by jiang deng on 2019/4/1.
//  Copyright © 2019 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMAddressModel.h"


NS_ASSUME_NONNULL_BEGIN

typedef void(^chooseAddressClicked)(BMChooseAddressModel *chooseAddress, NSUInteger level);

@interface BMAddressChooseView : UIView

@property (nonatomic, strong) BMChooseAddressModel *chooseAddress;

@property (nonatomic, assign, readonly) NSUInteger level;
@property (nonatomic, assign, readonly) NSUInteger maxLevel;

@property (nonatomic, copy) chooseAddressClicked addressClicked;

- (void)setChooseAddress:(BMChooseAddressModel *)chooseAddress level:(NSUInteger)level;

@end

NS_ASSUME_NONNULL_END
