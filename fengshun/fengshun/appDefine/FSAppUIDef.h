//
//  FSAppUIDef.h
//  fengshun
//
//  Created by jiang deng on 2018/8/25.
//  Copyright © 2018年 FS. All rights reserved.
//

#ifndef FSAppUIDef_h
#define FSAppUIDef_h

#import "UIColor+BMCategory.h"
#import "UIFont+BMCategory.h"

#pragma mark - Color

#define UI_COLOR_R1_VALU        0xE8373D

#define UI_COLOR_Y1             [UIColor bm_colorWithHex:0xFBD973]
#define UI_COLOR_Y2             [UIColor bm_colorWithHex:0xECC85A]
#define UI_COLOR_Y3             [UIColor bm_colorWithHex:0xF9DF4D]
#define UI_COLOR_Y4             [UIColor bm_colorWithHex:0xF39025]
#define UI_COLOR_Y5             [UIColor bm_colorWithHex:0xF4830B]
#define UI_COLOR_Y6             [UIColor bm_colorWithHex:0xFFF6DB]

#define UI_COLOR_R1             [UIColor bm_colorWithHex:UI_COLOR_R1_VALU]
#define UI_COLOR_R1_1           [UIColor bm_colorWithHex:UI_COLOR_R1_VALU alpha:0.5]
#define UI_COLOR_R2             [UIColor bm_colorWithHex:0xDA2626]

#define UI_COLOR_B1             [UIColor bm_colorWithHex:0x333333]
#define UI_COLOR_B2             [UIColor bm_colorWithHex:0x666666]
#define UI_COLOR_B3             [UIColor bm_colorWithHex:0x888888]
#define UI_COLOR_B4             [UIColor bm_colorWithHex:0x999999]
#define UI_COLOR_B5             [UIColor bm_colorWithHex:0xCCCCCC]
#define UI_COLOR_B6             [UIColor bm_colorWithHex:0xE6E6E6]
#define UI_COLOR_B7             [UIColor bm_colorWithHex:0xF8F8F8]
#define UI_COLOR_B8             [UIColor bm_colorWithHex:0xFFFFFF]

#define UI_COLOR_BL1            [UIColor bm_colorWithHex:0x0099CC]
#define UI_COLOR_BL2            [UIColor bm_colorWithHex:0x8DC8FE]
#define UI_COLOR_BL3            [UIColor bm_colorWithHex:0x77CDEA]
#define UI_COLOR_BL4            [UIColor bm_colorWithHex:0x54C2E7]

#define UI_COLOR_G1             [UIColor bm_colorWithHex:0x8ADA30]

#define UI_COLOR_P1             [UIColor bm_colorWithHex:0xDE9BFD]


#pragma mark - Font

#define UI_FSFONT_MAKE(FontName, FontSize)  [UIFont fontForFontName:FontName size:FontSize]

#pragma mark -
#pragma mark systemFont

#define UI_FONT_9           [UIFont systemFontOfSize:9.0f]

#define UI_FONT_10          [UIFont systemFontOfSize:10.0f]
#define UI_FONT_12          [UIFont systemFontOfSize:12.0f]
#define UI_FONT_13          [UIFont systemFontOfSize:13.0f]
#define UI_FONT_14          [UIFont systemFontOfSize:14.0f]
#define UI_FONT_15          [UIFont systemFontOfSize:15.0f]
#define UI_FONT_16          [UIFont systemFontOfSize:16.0f]
#define UI_FONT_18          [UIFont systemFontOfSize:18.0f]

#define UI_FONT_20          [UIFont systemFontOfSize:20.0f]
#define UI_FONT_22          [UIFont systemFontOfSize:22.0f]
#define UI_FONT_24          [UIFont systemFontOfSize:24.0f]

#define UI_FONT_30          [UIFont systemFontOfSize:30.0f]
#define UI_FONT_32          [UIFont systemFontOfSize:32.0f]
#define UI_FONT_36          [UIFont systemFontOfSize:36.0f]

#define UI_FONT_40          [UIFont systemFontOfSize:40.0f]
#define UI_FONT_50          [UIFont systemFontOfSize:50.0f]
#define UI_FONT_70          [UIFont systemFontOfSize:70.0f]


#pragma mark -
#pragma mark boldSystemFont

#define UI_BOLDFONT_9       [UIFont boldSystemFontOfSize:9.0f]

#define UI_BOLDFONT_10      [UIFont boldSystemFontOfSize:10.0f]
#define UI_BOLDFONT_12      [UIFont boldSystemFontOfSize:12.0f]
#define UI_BOLDFONT_13      [UIFont boldSystemFontOfSize:13.0f]
#define UI_BOLDFONT_14      [UIFont boldSystemFontOfSize:14.0f]
#define UI_BOLDFONT_15      [UIFont boldSystemFontOfSize:15.0f]
#define UI_BOLDFONT_16      [UIFont boldSystemFontOfSize:16.0f]
#define UI_BOLDFONT_18      [UIFont boldSystemFontOfSize:18.0f]

#define UI_BOLDFONT_20      [UIFont boldSystemFontOfSize:20.0f]
#define UI_BOLDFONT_22      [UIFont boldSystemFontOfSize:22.0f]
#define UI_BOLDFONT_24      [UIFont boldSystemFontOfSize:24.0f]

#define UI_BOLDFONT_30      [UIFont boldSystemFontOfSize:30.0f]
#define UI_BOLDFONT_32      [UIFont boldSystemFontOfSize:32.0f]
#define UI_BOLDFONT_36      [UIFont boldSystemFontOfSize:36.0f]

#define UI_BOLDFONT_40      [UIFont boldSystemFontOfSize:40.0f]
#define UI_BOLDFONT_50      [UIFont boldSystemFontOfSize:50.0f]
#define UI_BOLDFONT_70      [UIFont boldSystemFontOfSize:70.0f]


#pragma mark -
#pragma mark numberFont

//#define UI_NUMBER_FONT          @"HelveticaNeue-Bold"
#define UI_NUMBER_FONT(fontSize)    UI_FSFONT_MAKE(FontNameHelveticaNeueBold, fontSize)

#define UI_NUMFONT_9        UI_NUMBER_FONT(9.0f)

#define UI_NUMFONT_10       UI_NUMBER_FONT(10.0f)
#define UI_NUMFONT_12       UI_NUMBER_FONT(12.0f)
#define UI_NUMFONT_13       UI_NUMBER_FONT(13.0f)
#define UI_NUMFONT_14       UI_NUMBER_FONT(14.0f)
#define UI_NUMFONT_15       UI_NUMBER_FONT(15.0f)
#define UI_NUMFONT_16       UI_NUMBER_FONT(16.0f)
#define UI_NUMFONT_18       UI_NUMBER_FONT(18.0f)

#define UI_NUMFONT_20       UI_NUMBER_FONT(20.0f)
#define UI_NUMFONT_22       UI_NUMBER_FONT(22.0f)
#define UI_NUMFONT_24       UI_NUMBER_FONT(24.0f)

#define UI_NUMFONT_30       UI_NUMBER_FONT(30.0f)
#define UI_NUMFONT_32       UI_NUMBER_FONT(32.0f)
#define UI_NUMFONT_36       UI_NUMBER_FONT(36.0f)

#define UI_NUMFONT_40       UI_NUMBER_FONT(40.0f)
#define UI_NUMFONT_50       UI_NUMBER_FONT(50.0f)
#define UI_NUMFONT_70       UI_NUMBER_FONT(70.0f)


// View背景颜色
#define FS_VIEW_BGCOLOR                     UI_COLOR_B7

// 导航条背景颜色
#define FS_NAVIGATION_BGCOLOR_VALUE         UI_COLOR_R1_VALU
#define FS_NAVIGATION_BGCOLOR               [UIColor bm_colorWithHex:UI_NAVIGATION_BGCOLOR_VALUE]

// 工具条背景颜色
#define FS_BAR_BGCOLOR                      UI_COLOR_B6
#define FS_BAR_TEXTNORMALCOLOR              UI_COLOR_B2
#define FS_BAR_TEXTSELECTCOLOR              UI_COLOR_R1

// 文本颜色
#define FS_TITLE_TEXTCOLOR                  UI_COLOR_B1
#define FS_CONTENT_TEXTCOLOR                UI_COLOR_B2
#define FS_DETAIL_TEXTCOLOR                 UI_COLOR_B2
#define FS_COUNT_TEXTCOLOR                  UI_COLOR_R1
#define FS_OTHER_TEXTCOLOR                  UI_COLOR_B2

// Cell背景颜色
#define FS_TABLECELL_BGCOLOR                UI_COLOR_B8
// Cell选中状态背景颜色
#define UI_TABLECELL_SELECTBGCOLOR          UI_COLOR_B5
#define UI_TABLECELL_HIGHLIGHTBGCOLOR       UI_COLOR_R1

// 分割线颜色
#define FS_LINECOLOR                        UI_COLOR_B6


#endif /* FSAppUIDef_h */
