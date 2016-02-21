//
//  ViewController.m
//  FacebookApp
//
//  Created by Vladas Zakrevskis on 19/02/16.
//  Copyright © 2016 Vladas Zakrevskis. All rights reserved.
//

#import "ViewController.h"
#import "VZUser.h"
#import "ProfileViewController.h"
#import "DataManager.h"

@interface ViewController ()    <UITableViewDelegate,
                                UITableViewDataSource,
                                DataManagerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;


@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UIBarButtonItem *btnReload = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(btnReloadPressed:)];
    self.navigationController.topViewController.navigationItem.rightBarButtonItem = btnReload;
    btnReload.enabled=TRUE;
    btnReload.style=UIBarButtonSystemItemRefresh;
    
    [DataManager sharedManager].delegate = self;
    
    [[DataManager sharedManager] generateData:@1];
    
    

    
   // [profileButton addTarget:self action:@selector(didPressProfileButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)btnReloadPressed:(UIButton *)sender
{
    ProfileViewController *controller =
    [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ProfileViewController class])];
    
    controller.userID = 500;
    
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - Table properties

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[DataManager sharedManager] data] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileViewController *controller =
    [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ProfileViewController class])];
    
    controller.userID = indexPath.row;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const CellID = @"Cell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellID];
    
    VZUser *user = [[[DataManager sharedManager] data] objectAtIndex:indexPath.row];
    
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    cell.imageView.image = [UIImage imageWithData:user.avatar];
    
    
    return cell;
}


#pragma mark - FataManager delegate implementation

- (void)dataManagerDidFinishLoadData
{
    [self.tableView reloadData];
}

@end


