//
//  HomeVideoPlayerViewController.m
//  ODR
//
//  Created by DH on 2018/7/5.
//  Copyright © 2018年 DH. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "ZFPlayer.h"
#import "ZFPlayerController.h"
#import "ZFPlayerControlView.h"
#import "ZFAVPlayerManager.h"

@interface VideoPlayerViewController ()
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, assign) BOOL isNavigationBarHidden;

@end

@implementation VideoPlayerViewController

- (instancetype)initWithVideoUrl:(NSString *)url
{
    self = [super init];

    if (self)
    {
        self.videoUrl = url;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];


    _player = ({
        ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
        ZFPlayerController *player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.view];
        player.controlView = [ZFPlayerControlView new];
        player.assetURL = [NSURL URLWithString:_videoUrl];
        player;
    });

    _backBtn = ({
        UIButton *btn = [UIButton new];
        [btn setImage:[UIImage imageNamed:@"video_back_btn"] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(40);
            make.left.equalTo(self.view).offset(15);
        }];
        [btn addTarget:self action:@selector(backBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });

    [_player playTheIndex:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)backBtnDidClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
