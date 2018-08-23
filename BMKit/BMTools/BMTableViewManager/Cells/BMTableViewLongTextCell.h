//
//  BMTableViewLongTextCell.h
//  BMTableViewManagerSample
//
//  Created by DennisDeng on 2018/4/20.
//  Copyright © 2018年 DennisDeng. DennisDeng rights reserved.
//

#import "BMTableViewCell.h"
#import "BMPlaceholderTextView.h"

@interface BMTableViewLongTextCell : BMTableViewCell
<
    UITextViewDelegate
>

@property (nonatomic, strong, readonly) BMPlaceholderTextView *textView;

@end
