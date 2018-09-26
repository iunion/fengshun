//
//  FSTextSearchResultVC.m
//  fengshun
//
//  Created by Aiwei on 2018/9/10.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSTextSearchResultVC.h"
#import "FSTextModel.h"

@interface FSTextSearchResultVC ()
@property(nonatomic, strong)NSArray <FSListTextModel *>* m_textList;

@end

@implementation FSTextSearchResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FSListTextModel *model =_m_textList[indexPath.row];
    [FSPushVCManager pushToTextDetail:self url:model.m_previewUrl withFileId:model.m_fileId];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _m_textList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSTextCell * cell  = [tableView dequeueReusableCellWithIdentifier:@"FSTextCell"];
    FSListTextModel *model =_m_textList[indexPath.row];
    [cell setTextModel:model colors:self.m_keyword];
    return cell;
}

# pragma mark - NetWorking
- (NSMutableURLRequest *)setLoadDataRequest
{
    return [FSApiRequest searchTextWithKeyword:_m_keyword];
}
- (BOOL)succeedLoadedRequestWithDic:(NSDictionary *)requestDic
{
    NSArray *textList = [FSListTextModel modelsWithDataArray:[requestDic bm_arrayForKey:@"documentList"]];
    self.m_textList = textList;
    if (self.m_searchsucceed) {
        self.m_searchsucceed(textList);
    }
    self.m_DataArray = [_m_textList mutableCopy];
    [self.m_TableView reloadData];
    return [super succeedLoadedRequestWithDic:requestDic];
}

@end
