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
    
    [self.tableView setBackgroundColor:[UIColor blackColor]];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor grayColor]];

    if (self == [self.navigationController.viewControllers firstObject]) {
        
        [DataManager sharedManager].delegate = self;
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"haveData"] == NO) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"haveData"];
            
            [[DataManager sharedManager] generateData:@100];
            
            NSLog(@"Data generation");
        }
        
        [[DataManager sharedManager] loadVZUsersFromDatabase];
        
        [[DataManager sharedManager] createRandomRelationships];
        
        
        self.users = [[DataManager sharedManager] allVZUsersData].mutableCopy;
        
        ProfileViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ProfileViewController class])];
        
        controller.parentController = self;
        controller.userID = 0;
        
        [self.navigationController pushViewController:controller animated:NO];

    }

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
    return self.users.count;
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
    controller.parentController = self;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.selectionStyle != UITableViewCellSelectionStyleNone) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const CellID = @"Cell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellID];
    
    VZUser *user = [self.users objectAtIndex:indexPath.row];
    
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    cell.imageView.image = [UIImage imageWithData:user.avatar];
    
    
    return cell;
}


#pragma mark - FataManager delegate implementation

- (void)dataManagerDidFinishLoadData
{
    [self.tableView reloadData];
}

#pragma mark - Another methods


@end


