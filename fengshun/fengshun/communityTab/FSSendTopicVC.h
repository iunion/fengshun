//
//  FSSendPostViewController.h
//  fengshun
//
//  Created by best2wa on 2018/9/4.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "ZSSRichTextEditor.h"

@interface FSSendTopicVC : ZSSRichTextEditor
// isEdited = YES relateId:帖子id  /isEdited = NO relateId：板块id
- (instancetype)initWithIsEdited:(BOOL)isEdited relateId:(NSInteger )relateId;

@property (nonatomic , copy)void (^sendPostsCallBack)(id );

@end
