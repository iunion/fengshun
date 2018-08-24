//
//  BMSearchViewController.m
//  fengshun
//
//  Created by jiang deng on 2018/8/23.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "BMSearchViewController.h"

#define SearchBarGap    10.0f

@interface BMSearchViewController ()

@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic, weak) UITextField *searchTextField;

@end

@implementation BMSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bm_NavigationShadowHidden = YES;
    
    self.bm_NavigationItemTintColor = [UIColor whiteColor];
    UIView *searchBarBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_NAVIGATION_BAR_HEIGHT)];
    searchBarBgView.backgroundColor = [UIColor clearColor];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10.0f, SearchBarGap, UI_SCREEN_WIDTH-20.0f, UI_NAVIGATION_BAR_HEIGHT-SearchBarGap*2)];
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [searchBarBgView addSubview:searchBar];
    searchBar.placeholder = @"查找...";
    [self bm_setNavigationWithTitleView:searchBarBgView barTintColor:[UIColor redColor] leftItemTitle:nil leftItemImage:@"navigationbar_back_icon" leftToucheEvent:@selector(backAction:) rightItemTitle:nil rightItemImage:nil rightToucheEvent:nil];
    self.searchTextField = (UITextField *)[searchBar bm_viewOfClass:[UITextField class]];
    self.searchTextField.font = [UIFont systemFontOfSize:12.0f];
    self.searchTextField.backgroundColor = [UIColor yellowColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 80, 40)];
    [btn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor blueColor];
}

- (void)backAction:(id)sender
{
    //if ([self shouldPopOnBackButton])
    {
        [self.view endEditing:YES];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)next:(id)sender
{
    [self.navigationController pushViewController:[[UIViewController alloc] init] animated:YES];
}

- (void)setSearchBarCornerRadius:(CGFloat)searchBarCornerRadius
{
    _searchBarCornerRadius = searchBarCornerRadius;
    
    for (UIView *subView in self.searchTextField.subviews)
    {
        if ([NSStringFromClass([subView class]) isEqualToString:@"_UISearchBarSearchFieldBackgroundView"])
        {
            subView.layer.cornerRadius = searchBarCornerRadius;
            subView.clipsToBounds = YES;
            break;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
