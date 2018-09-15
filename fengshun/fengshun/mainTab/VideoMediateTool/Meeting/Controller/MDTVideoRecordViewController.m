//
//  MDTVideoRecordViewController.m
//  ODR
//
//  Created by DH on 2018/9/12.
//  Copyright © 2018年 DH. All rights reserved.
//

#import "MDTVideoRecordViewController.h"
#import "MDTVideoRecordView.h"
#import "VideoPlayerViewController.h"

@interface MDTVideoRecordViewController () <MDTVideoRecordCellDelegate>

@end

@implementation MDTVideoRecordViewController
+ (instancetype)VCWithMeetingId:(NSInteger)meetingId {
    MDTVideoRecordViewController *vc = [MDTVideoRecordViewController new];
    MDTVideoRecordViewModel *vm = [MDTVideoRecordViewModel new];
    vm.meetingId = meetingId;
//    vc.viewModel = vm;
    return vc;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视频记录";
//    [self initLoadingView];
//    [self initTableViewWithFrame:CGRectZero style:UITableViewStyleGrouped];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.bottom.equalTo(self.view);
//    }];
//    self.tableView.separatorColor = kLineColor;
//    self.tableView.separatorInset = UIEdgeInsetsZero;
//    [self loadData];
}

#pragma mark - MDTVideoRecordCellDelegate
//- (void)videoRecordCell:(MDTVideoRecordCell *)cell playBtnDidClick:(UIButton *)btn {
//    MDTVideoRecordModel *model = [self.viewModel modelAtIndexPath:[self.tableView indexPathForCell:cell]];
//    if (!model.download.length) {
//        showError(@"播放路径为空", self.view);
//        return;
//    }
//    VideoPlayerViewController *vc = [[VideoPlayerViewController alloc] initWithVideoUrl:model.download];
//    [self.navigationController pushViewController:vc animated:YES];
//}

@end

@implementation MDTVideoRecordViewModel
//- (void)loadDataComplete:(void (^)(NSError *))handler {
//    NSDictionary *params = @{@"meetingId":@(_meetingId)};
//    [[RequestClient sharedClient] POST:@"mastiff/caseMeeting/getVideoList" parameters:params configurationHandler:nil completeBlock:^(NSError * _Nullable error, id  _Nullable result, BOOL isFromCache, NSURLSessionTask * _Nullable task) {
//        if (!error) {
//            NSArray *array = [NSArray yy_modelArrayWithClass:[MDTVideoRecordModel class] json:result[@"data"]];
//            if (!array.count) {
//                error = noMoreDataError;
//            } else {
//                [self convertModels:array];
//            }
//            NSLog(@"%@", result);
//        } else {
//            NSLog(@"%@", error);
//        }
//        handler(error);
//    }];
//}
//
//- (void)convertModels:(NSArray *)array {
//    NSMutableArray *groups = @[].mutableCopy;
//    [array enumerateObjectsUsingBlock:^(MDTVideoRecordModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        CellDeployGroupItem *group = [CellDeployGroupItem new];
//        group.headerH = 10;
//        CellDeployItem *item = [CellDeployItem new];
//        item.className = NSStringFromClass([MDTVideoRecordCell class]);
//        item.model = obj;
//        item.rowH = 85;
//        group.items = @[item].mutableCopy;
//        [groups addObject:group];
//    }];
//    self.groups = groups;
//}


@end

