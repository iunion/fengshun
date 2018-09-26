//
//  FSTextDetailVC.m
//  fengshun
//
//  Created by Aiwei on 2018/9/26.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSTextDetailVC.h"

@interface FSTextDetailVC ()

@end

@implementation FSTextDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize buttonSize = CGSizeMake(115, 41);
    UIButton *dowloadButton = [[UIButton alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH - buttonSize.width, UI_SCREEN_HEIGHT -UI_NAVIGATION_BAR_HEIGHT- UI_STATUS_BAR_HEIGHT -buttonSize.height -45, buttonSize.width, buttonSize.height)];
    dowloadButton.backgroundColor = UI_COLOR_BL1;
    dowloadButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [dowloadButton setImage:[UIImage imageNamed:@"text_dowload"] forState:UIControlStateNormal];
    [dowloadButton setTitle:@"下载范本" forState:UIControlStateNormal];
    [dowloadButton addTarget:self action:@selector(downloadFile) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:dowloadButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)downloadFile
{
    if ([_m_fileId bm_isNotEmpty]) {
        NSString *url = [NSString stringWithFormat:@"%@%@%@",FS_URL_SERVER,FS_FILE_ADRESS,_m_fileId];
        url = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication  sharedApplication]openURL:[NSURL URLWithString:url]];
    }
}

@end
