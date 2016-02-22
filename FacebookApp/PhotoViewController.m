//
//  PhotoViewController.m
//  FacebookApp
//
//  Created by Vladas Zakrevskis on 22/02/16.
//  Copyright © 2016 Vladas Zakrevskis. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()


@end

@implementation PhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:
    CGRectMake(0,
               self.view.frame.size.height / 2 - self.view.frame.size.width / 2,
               self.view.frame.size.width,
               self.view.frame.size.width)];
    
    [avatarImageView setImage:self.avatarImage];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:
    CGRectMake(0,
               0,
               self.view.frame.size.width,
               50)];
    
    [nameLabel setFont:[UIFont systemFontOfSize:30]];
    [nameLabel setTextColor:[UIColor whiteColor]];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [nameLabel setText:self.name];
    
    
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    [self.view addSubview:nameLabel];
    
    [self.view addSubview:avatarImageView];
}



@end
