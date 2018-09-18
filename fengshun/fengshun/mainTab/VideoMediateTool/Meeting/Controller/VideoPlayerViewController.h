//
//  HomeVideoPlayerViewController.h
//  ODR
//
//  Created by DH on 2018/7/5.
//  Copyright © 2018年 DH. All rights reserved.
//

#import "FSSuperNetVC.h"

@interface VideoPlayerViewController : FSSuperNetVC

@property (nonatomic, strong) NSString *videoUrl;

- (instancetype)initWithVideoUrl:(NSString *)url;

@end
