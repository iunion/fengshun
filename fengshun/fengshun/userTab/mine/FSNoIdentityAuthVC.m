//
//  FSNoIdentityAuthVC.m
//  fengshun
//
//  Created by 龚旭杰 on 2019/4/22.
//  Copyright © 2019年 FS. All rights reserved.
//

#import "FSNoIdentityAuthVC.h"
#import "FSNoIdentityAuthCell.h"

@interface FSNoIdentityAuthVC ()

@property (nonatomic,strong) NSMutableArray *m_dataList;

@end

@implementation FSNoIdentityAuthVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self bm_setNavigationWithTitle:@"我的专栏" barTintColor:nil leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];
    
    [self createUI];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)createUI
{
    [self.m_TableView registerNib:[UINib nibWithNibName:@"FSNoIdentityAuthCell" bundle:nil] forCellReuseIdentifier:@"FSNoIdentityAuthCell"];
    self.m_TableView.bm_height -= 48.f;
    self.m_TableView.bounces = NO;
    self.m_TableView.showsVerticalScrollIndicator = NO;
    
    UIButton *applyBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.m_TableView.bm_bottom, UI_SCREEN_WIDTH, 48.f)];
    applyBtn.backgroundColor = [UIColor bm_colorWithHex:0x4E7CF6];
    applyBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [applyBtn setTitle:@"申请身份认证，开通专栏" forState:UIControlStateNormal];
    [applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [applyBtn addTarget:self action:@selector(applyIdentityAuth) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:applyBtn];
    
    FSNoIdentityAuthModel *step1 = [FSNoIdentityAuthModel new];
    step1.m_Title = @"个人专栏是什么";
    step1.m_Content = @"在枫调理顺用户可拥有自己的个人专栏，专栏将为用户提供个人风格持续创作的写作工具。";
    step1.m_ImageName = @"";
    step1.m_keyWords = @[@"个人专栏",@"写作工具"];
    
    FSNoIdentityAuthModel *step2 = [FSNoIdentityAuthModel new];
    step2.m_Title = @"如何开通专栏";
    step2.m_Content = @"开通专栏需要完成身份认证";
    step2.m_ImageName = @"";
    step2.m_keyWords = @[@"身份认证"];
    
    FSNoIdentityAuthModel *step3 = [FSNoIdentityAuthModel new];
    step3.m_Title = @"专栏的内容方向";
    step3.m_Content = @"枫调理顺致力于为中国调解员搭建的一个工作、生活交流的互联网平台，专栏内容应与调解工作相关。我们接受但不限于以下内容方向:调解案例、调解技巧、法律及司法相关。";
    step3.m_ImageName = @"";
    step3.m_keyWords = @[@"调解案例、调解技巧、法律及司法相关。"];
    
    
    self.m_dataList = [NSMutableArray arrayWithArray:@[step1,step2,step3]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 16.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.m_dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSNoIdentityAuthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSNoIdentityAuthCell"];
    [cell showWithModel:self.m_dataList[indexPath.section]];
    return cell;
}

- (void)applyIdentityAuth
{
    
}


@end
