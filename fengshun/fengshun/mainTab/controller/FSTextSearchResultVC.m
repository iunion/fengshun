//
//  FSTextSearchResultVC.m
//  fengshun
//
//  Created by Aiwei on 2018/9/10.
//  Copyright © 2018 FS. All rights reserved.
//

#import "FSTextSearchResultVC.h"
#import "FSListTextModel.h"

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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _m_textList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSTextListCell * cell  = [tableView dequeueReusableCellWithIdentifier:@"FSTextListCell"];
    FSListTextModel *model =_m_textList[indexPath.row];
    [cell setTextModel:model colors:YES];
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
    [self.m_TableView reloadData];
    return [super succeedLoadedRequestWithDic:requestDic];
}

@end