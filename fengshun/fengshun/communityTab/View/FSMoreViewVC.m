//
//  FSMoreViewVC.m
//  fengshun
//
//  Created by best2wa on 2018/9/17.
//  Copyright © 2018年 FS. All rights reserved.
//

#import "FSMoreViewVC.h"
#import "UIButton+BMContentRect.h"

#define MORE_VIEW_HEIGHT 238

@interface
FSMoreViewVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewBottomConstraint;

@end

@implementation FSMoreViewVC


+ (void)showMore:(UIViewController *)presentVC  delegate:(id)delegate
{
    FSMoreViewVC *moreVC = [[FSMoreViewVC alloc]init];
    moreVC.delegate = delegate;
    presentVC.definesPresentationContext = YES;
    moreVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [presentVC.navigationController presentViewController:moreVC animated:NO completion:^{
        [UIView animateWithDuration:.3
                         animations:^{
                             moreVC.bgViewBottomConstraint.constant = 0;
                             [moreVC.view layoutIfNeeded];
                         }];
    }];
    moreVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    for (int i = 0; i < 10; i++)
    {
        UIButton *btn = [self.view viewWithTag:(i + 100)];
        if (btn)
        {
            [btn bm_layoutButtonWithEdgeInsetsStyle:BMButtonEdgeInsetsStyleImageTop imageTitleGap:5];
            [btn addTarget:self action:@selector(moreViewAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)moreViewAction:(UIButton *)sender
{
    BMLog(@"%ld", sender.tag);
    if (self.delegate && [self.delegate respondsToSelector:@selector(moreViewClickWithType:)]) {
        [self.delegate moreViewClickWithType:sender.tag - 100];
    }
}

- (IBAction)cancelAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
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
