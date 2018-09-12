//
//  FSH5DemoVC.m
//  fengshun
//
//  Created by best2wa on 2018/9/12.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSH5DemoVC.h"
#import "FSPushVCManager.h"

@interface FSH5DemoVC ()

@end

@implementation FSH5DemoVC
/*
 /document             文书详情
 
 /comment/:courseId          图文详情    例  https://devftlsh5.odrcloud.net/comment/2
 
 /note/:courseId                  帖子详情
 
 /tooIndex             计算器首页
 
 /lawyerFee          律师费计算器
 
 /legalFee            诉讼费计算器
 
 /Interest            利息及违约金计算器
 
 /date                日期天数计算器
 
 /Law                           法规专题
 
 /Law/lawDetail             法规详情
 
 /Law/lawShare             法规分享
 
 /caseDetail                  案件详情
 
 /caseGuide                  指导案例详情
 
 /caseShare                  案件分享
 
 /course                       课堂首页
 
 /imgWordsSeries            图文系列
 
 /hotRecommend              热门推荐
 
 /alllist                            全部
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.m_DataArray = [NSMutableArray arrayWithArray:@[
  @[@"document",@"文书详情"],
  @[@"comment/1",@"图文详情"],
  @[@"note/1",@"帖子详情"],
  @[@"tooIndex",@"计算器首页"],
  @[@"lawyerFee",@"律师费计算器"],
  @[@"legalFee",@"诉讼费计算器"],
  @[@"Interest",@"利息及违约金计算器"],
  @[@"date",@"日期天数计算器"],
  @[@"Law",@"法规专题"],
  @[@"Law/lawDetail",@"法规详情"],
  @[@"Law/lawShare",@"法规分享"],
  @[@"caseGuide",@"案件详情"],
  @[@"caseShare",@"案件分享"],
  @[@"course",@"课堂首页"],
  @[@"imgWordsSeries",@"图文系列"],
  @[@"hotRecommend",@"热门推荐"],
  @[@"alllist",@"全部"]]];
    self.m_TableView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_MAINSCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT - 49);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@=%@",self.m_DataArray[indexPath.row][1],self.m_DataArray[indexPath.row][0]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *url = self.m_DataArray[indexPath.row][0];
    [FSPushVCManager showWebView:self url:[NSString stringWithFormat:@"%@/%@",FS_H5_SERVER,url] title:@""];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
