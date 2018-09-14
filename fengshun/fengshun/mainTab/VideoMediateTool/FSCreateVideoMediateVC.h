//
//  FSCreateVideoMediateVC.h
//  fengshun
//
//  Created by ILLA on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSSuperVC.h"
#import "FSTableViewVC.h"

typedef void(^createVideoMediateSuccessBlock)(void);

@interface FSCreateVideoMediateVC : FSTableViewVC

@property (nonatomic, copy) createVideoMediateSuccessBlock successBlock;

@end
