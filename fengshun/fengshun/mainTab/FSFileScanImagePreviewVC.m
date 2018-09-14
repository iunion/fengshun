//
//  FSFileScanImagePreviewVC.m
//  fengshun
//
//  Created by Aiwei on 2018/9/14.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSFileScanImagePreviewVC.h"
#import "FSImageFileModel.h"
#import "FSScrollPageView.h"

@interface FSFileScanImagePreviewVC ()
<
    FSScrollPageViewDelegate,
    FSScrollPageViewDataSource
>
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *m_toolButtons;
@property (weak, nonatomic) IBOutlet UILabel *m_pageContolLabel;

@end

@implementation FSFileScanImagePreviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}
- (void)setupUI
{
    [_m_pageContolLabel bm_roundedRect:13.5];
    self.bm_NavigationShadowHidden  = NO;
    self.bm_NavigationShadowColor   = UI_COLOR_B6;
    [self bm_setNavigationLeftItemTintColor:UI_COLOR_B1];
    [self bm_setNavigationWithTitle:_m_selectedImageFile.m_fileName barTintColor:nil leftItemTitle:@"" leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:@"更多" rightItemImage:nil rightToucheEvent:@selector(moreAction:)];
    [self bm_setNavigationRightItemTintColor:UI_COLOR_BL1];
    [self bm_setNeedsUpdateNavigationBar];
    [self setBm_NavigationBarImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    for (UIButton *toolButton in _m_toolButtons) {
        [toolButton bm_roundedRect:20 borderWidth:0.5 borderColor:UI_COLOR_BL1];
    }
    // 内容视图
    FSScrollPageView *scrollPageView = [[FSScrollPageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH,UI_SCREEN_HEIGHT - UI_NAVIGATION_BAR_HEIGHT - UI_TAB_BAR_HEIGHT - TOOLVIEW_HEIGHT) titleColor:nil selectTitleColor:nil scrollPageSegment:nil isSubViewPageSegment:NO];
    [self.view insertSubview:scrollPageView belowSubview:_m_pageContolLabel];
    scrollPageView.datasource = self;
    scrollPageView.delegate = self;
    [scrollPageView reloadPage];
    [scrollPageView scrollPageWithIndex:[_m_allImageFiles indexOfObject:_m_selectedImageFile]];
    [self refreshUI];
}
- (void)refreshUI
{
    NSUInteger index = [_m_allImageFiles indexOfObject:_m_selectedImageFile];
    NSUInteger total = _m_allImageFiles.count;
    _m_pageContolLabel.text = [NSString stringWithFormat:@"%lu/%lu",index+1,total];
    [self bm_setNavigationBarTitle:_m_selectedImageFile.m_fileName];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - scrollPageView dataSource & delegate
- (void)scrollPageViewChangeToIndex:(NSUInteger)index
{
    self.m_selectedImageFile = [_m_allImageFiles objectAtIndex:index];
    [self refreshUI];
}
- (NSUInteger)scrollPageViewNumberOfPages:(FSScrollPageView *)scrollPageView
{
    return _m_allImageFiles.count;
}


- (id)scrollPageView:(FSScrollPageView *)scrollPageView pageAtIndex:(NSUInteger)index
{
    FSImageFileModel *model = [_m_allImageFiles objectAtIndex:index];
    if ([model bm_isNotEmpty]) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:model.m_image];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        return imageView;
    }
    return nil;
}

- (NSString *)scrollPageView:(FSScrollPageView *)scrollPageView titleAtIndex:(NSUInteger)index {
    return @"";
}

#pragma mark - button action
- (void)moreAction:(id)sender
{
    
}
- (IBAction)toolButtonAction:(UIButton *)sender {
    if (![_m_selectedImageFile bm_isNotEmpty]) {
        return;
    }
    switch (sender.tag) {
            // 分享PDF
        case 0:
            
            break;
            // 分享图片
        case 1:
            break;
            // 保存到相册
        case 2:
            
            break;
            // 文字识别
        case 3:
            
            break;
    }
    
}


@end
