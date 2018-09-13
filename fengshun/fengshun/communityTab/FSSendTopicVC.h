//
//  FSSendPostViewController.h
//  fengshun
//
//  Created by best2wa on 2018/9/4.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "ZSSRichTextEditor.h"


@interface FSSendTopicVC : ZSSRichTextEditor

@property (nonatomic , copy)void (^sendPostsCallBack)(id );

@end
