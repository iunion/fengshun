//
//  MDTMeetingListViewController.m
//  ODR
//
//  Created by DH on 2018/9/5.
//  Copyright © 2018年 DH. All rights reserved.
//

#import "MDTMeetingListViewController.h"
#import "MDTMeetingListView.h"
#import "MDTMeetingListModel.h"
#import "VideoCallController.h"
#import "MDTVideoRecordViewController.h"

@interface MDTMeetingListViewController ()

@end

@implementation MDTMeetingListViewController
//
//+ (instancetype)vcWithCaseId:(NSInteger)caseId {
//    MDTMeetingListViewController *vc = [MDTMeetingListViewController new];
//    MDTMeetingListViewModel *vm = [MDTMeetingListViewModel new];
//    vm.caseId = caseId;
//    vc.viewModel = vm;
//    return vc;
//}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.title = @"调解列表";
//    [self initLoadingView];
//    [self initTableViewWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self loadData];
//    [self setupRefreshHeader];
//}
//
//#pragma mark - MDTCaseMeetingCellDelegate
//- (void)caseMeetingCell:(MDTCaseMeetingCell *)cell btnClickWithIndex:(NSInteger)index {
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//    MDTMeetingListViewModel *vm = (id)self.viewModel;
//    MDTMeetingListModel *model = [vm modelAtIndexPath:indexPath];
//    switch (index) {
//        case 0: {
//            NSLog(@"进入会议");
//            [self enterMeetingVideoWithIndexPath:indexPath];
//        } break;
//
//        case 1: {
//            NSLog(@"视频记录");
//            MDTVideoRecordViewController *vc = [MDTVideoRecordViewController VCWithMeetingId:model.id];
//            [self.navigationController pushViewController:vc animated:YES];
//        } break;
//
//        case 2: {
//            NSLog(@"笔录");
//            MediationRecordVC *vc = [MediationRecordVC vcWithMeetingID:model.id CaseID:model.lawCaseId];
//            [self.navigationController pushViewController:vc animated:YES];
//        } break;
//
//        default:
//            break;
//    }
//}
//
//
//- (void)enterMeetingVideoWithIndexPath:(NSIndexPath *)indexPath {
//    MDTMeetingListModel *model = [self.viewModel modelAtIndexPath:indexPath];
//    VideoCallController *vc = [VideoCallController VCWithRoomId:model.meetingVideoId caseId:model.lawCaseId meetingId:model.id];
//    HomeNavController *nav = [[HomeNavController alloc] initWithRootViewController:vc];
//    [self presentViewController:nav animated:YES completion:nil];
//}

@end


@implementation MDTMeetingListViewModel
//- (void)loadDataComplete:(void (^)(NSError *))handler {
//    NSMutableDictionary *params = @{}.mutableCopy;
//    [params setObject:@(_caseId) forKey:@"caseId"];
//    [[RequestClient sharedClient] POST:@"mastiff/caseMeeting/queryMeetingList" parameters:params configurationHandler:nil completeBlock:^(NSError *error, id result, BOOL isFromCache, NSURLSessionTask *task) {
//        if (!error) {
//            NSLog(@"%@", result);
//            NSArray *array = [NSArray yy_modelArrayWithClass:[MDTMeetingListModel class] json:result[@"data"]];
//            [self convertModelArray:array];
//            if (!array.count) {
//                error = noMoreDataError;
//            }
//        } else {
//            NSLog(@"%@", error);
//        }
//        handler(error);
//    }];
//}
//
//- (void)convertModelArray:(NSArray *)dataArray {
//    NSMutableArray *groups = @[].mutableCopy;
//    for (int i = 0; i < dataArray.count; i ++) {
//        CellDeployGroupItem *group = [CellDeployGroupItem new];
//        group.footerH = 10;
//        MDTMeetingListModel *model = dataArray[i];
//        CellDeployItem *item = [CellDeployItem new];
//        item.model = model;
//        item.className = NSStringFromClass([MDTCaseMeetingCell class]);
//        group.items = @[item].mutableCopy;
//        [groups addObject:group];
//    }
//    self.groups = groups;
//}

@end
