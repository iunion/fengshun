//
//  PLDictionaryTableViewController.m
//  PListNavigator
//
//  Created by Jungho Bang on 13. 7. 30..
//  Copyright (c) 2013년 Bangtoven. All rights reserved.
//

#import "PLDictionaryTableViewController.h"
#import "PLArrayTableViewController.h"

#import "MBProgressHUD.h"

@interface PLDictionaryTableViewController ()
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, weak, readonly) NSArray *keys, *values;

@property (nonatomic, strong) MBProgressHUD *m_ProgressHUD;
@end

@implementation PLDictionaryTableViewController

- (id)initWithDictionary:(NSDictionary *)data {
    if (self = [super init]) {
        self.data = data;
    }
    return self;
}

#pragma mark - Properties

- (NSArray*)keys {
    return [self.data allKeys];
}

- (NSArray*)values {
    return [self.data allValues];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.m_ProgressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    //self.m_ProgressHUD.animationType = MBProgressHUDAnimationFade;
    [self.view addSubview:self.m_ProgressHUD];
    [self.m_ProgressHUD bm_bringToFront];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Dictionary Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[self.keys objectAtIndex:indexPath.row] description];
    
    id item = [self.values objectAtIndex:indexPath.row];
    if ([item isKindOfClass:[NSDictionary class]]) {
        cell.detailTextLabel.text = @"(dictionary)";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if ([item isKindOfClass:[NSArray class]]) {
        cell.detailTextLabel.text = @"(array)";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.detailTextLabel.text = [item description];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
        
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewController *nextViewController;
    
    id item = [self.values objectAtIndex:indexPath.row];
    if ([item isKindOfClass:[NSDictionary class]]) {
        nextViewController = [[PLDictionaryTableViewController alloc] initWithDictionary:item];
    } else if ([item isKindOfClass:[NSArray class]]) {
        nextViewController = [[PLArrayTableViewController alloc] initWithArray:item];
    } else {
        NSString *content = [item description];
        if ([content bm_isNotEmpty])
        {
            [self.m_ProgressHUD showAnimated:YES withDetailText:[item description] delay:PROGRESSBOX_DEFAULT_HIDE_DELAY];
            [[UIPasteboard generalPasteboard] setString:[item description]];
        }
        return;
    }
    
    nextViewController.title = [self.keys objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:nextViewController animated:YES];
}

@end
