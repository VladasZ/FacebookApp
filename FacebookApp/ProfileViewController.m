//
//  ProfileViewController.m
//  FacebookApp
//
//  Created by Vladas Zakrevskis on 21/02/16.
//  Copyright © 2016 Vladas Zakrevskis. All rights reserved.
//

#import "ProfileViewController.h"
#import "DataManager.h"
#import "VZUser.h"
//#import <QuartzCore/QuartzCore.h>


const CGFloat BackgroundImageScaleFactor = 0.025;
//elements size relative to screen size
const NSUInteger BackgroundImageSize = 5;
const NSUInteger AvatarSize = 3;
const NSUInteger NameLabelSize = 10;
const NSUInteger Intend = 10;
#define RGBCOLOR(r, g, b, a) [UIColor colorWithRed:r/225.0f green:g/225.0f blue:b/225.0f alpha:a]

@interface ProfileViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *topBackgroundImageView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UIImageView *scrollBackgroundImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *slidingNameLabel;
@property (nonatomic, strong) UIView *slidingNameView;


@end

@implementation ProfileViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createIntefrace];

    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController.interactivePopGestureRecognizer setDelegate:nil];
    
}

- (void)createIntefrace
{
    VZUser *user = [[DataManager sharedManager].data objectAtIndex:self.userID];
    
    //CGRect frame = self.scrollView.frame;
    
    NSLog(@"%f, %f", self.scrollView.frame.origin.x, self.scrollView.frame.origin.y);
    
    
    
#pragma mark top background image init
    
    self.topBackgroundImageView = [[UIImageView alloc] initWithFrame:
                                   CGRectMake(0,
                                              0,
                                              self.view.frame.size.width,
                                              self.view.frame.size.height / BackgroundImageSize)];
    
    [self.topBackgroundImageView setImage:[UIImage imageNamed:@"background.jpg"]];
    [self.topBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.topBackgroundImageView setClipsToBounds:YES];
    
    
    [self.scrollView setContentSize:
     CGSizeMake(self.view.frame.size.width,
                self.view.frame.size.height * 2)];
    
    CGRect scrollBackgroundFrame = self.scrollBackgroundImageView.frame;
    
    scrollBackgroundFrame.size.height = self.scrollView.contentSize.height;
    
    self.scrollBackgroundImageView.frame = scrollBackgroundFrame;
    
#pragma mark background image init
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:
    CGRectMake(0,
               -50,
               self.scrollView.contentSize.width,
               self.scrollView.contentSize.height + 500)];
    
    [backgroundImageView setImage:[UIImage imageNamed:@"1.jpg"]];
    [backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    

    
#pragma mark avatar image init
    
    NSUInteger avatarSize = self.view.frame.size.width / AvatarSize;
    
    self.avatarImageView = [[UIImageView alloc] initWithFrame:
                            CGRectMake(self.view.frame.size.width / 2 - avatarSize / 2,
                                       CGRectGetMaxY(self.topBackgroundImageView.frame) - avatarSize / 2,
                                       avatarSize,
                                       avatarSize)];
    
    [self.avatarImageView setImage:[UIImage imageWithData:user.avatar]];
    
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.bounds.size.height / 2;
    self.avatarImageView.layer.masksToBounds = YES;
    


    
#pragma mark name label init
    
    NSUInteger nameLabelHeight = self.view.frame.size.height / NameLabelSize;
    
    self.nameLabel = [[UILabel alloc] initWithFrame:
                      CGRectMake(0,
                                 CGRectGetMaxY(self.avatarImageView.frame),
                                 self.view.frame.size.width,
                                 nameLabelHeight)];
    
    [self.nameLabel setFont:[self.nameLabel.font fontWithSize:30]];
    [self.nameLabel setTextColor:[UIColor whiteColor]];
    [self.nameLabel setTextAlignment:NSTextAlignmentCenter];
    //[self.nameLabel setBackgroundColor:[UIColor blueColor]];
    
    self.nameLabel.text =
    [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    
    
    
#pragma mark sliding name label init
    
    self.slidingNameLabel = [self deepLabelCopy:self.nameLabel];
    
    self.slidingNameView = [[UIView alloc] initWithFrame:
                            CGRectMake(0,
                                       0,
                                       self.view.frame.size.width,
                                       self.view.frame.size.height / NameLabelSize)];
    
    [self.slidingNameView setBackgroundColor:[UIColor blackColor]];
    [self.slidingNameView.layer setZPosition:1];
    [self.slidingNameView setAlpha:0];
    
    [self.view addSubview:self.slidingNameView];

#pragma mark info view
    
    UIView *infoView = [[UIView alloc] initWithFrame:
    CGRectMake(Intend,
               CGRectGetMaxY(self.nameLabel.frame),
               self.view.frame.size.width - Intend * 2,
               self.scrollView.frame.size.height)];
    
    [infoView setBackgroundColor:RGBCOLOR(255, 255, 255, 0.2)];
    
    infoView.layer.cornerRadius = 20;
    infoView.layer.masksToBounds = YES;
    
    
    [self.scrollView addSubview:backgroundImageView];
    [self.scrollView addSubview:self.topBackgroundImageView];
    [self.slidingNameView addSubview:self.slidingNameLabel];
    [self.scrollView addSubview:self.avatarImageView];
    [self.scrollView addSubview:self.nameLabel];
    [self.scrollView addSubview:infoView];

}

#pragma mark - UIScrollViewDelegate implementation

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%f", scrollView.contentOffset.y);
    
#pragma mark background image animation
    
    if (scrollView.contentOffset.y < -20) {
        
        CGAffineTransform transform =
        CGAffineTransformMakeScale(1 - (scrollView.contentOffset.y + 20) * BackgroundImageScaleFactor,
                                   1 - (scrollView.contentOffset.y + 20) * BackgroundImageScaleFactor);
        
        [self.topBackgroundImageView setTransform:transform];
    }
    
#pragma mark sliding text animation
    
    NSUInteger nameLabelHeight = self.view.frame.size.height / NameLabelSize;
    
    if (scrollView.contentOffset.y < CGRectGetMaxY(self.nameLabel.frame) - nameLabelHeight) {
        [self.slidingNameView setAlpha:0];
    }
    
    if (scrollView.contentOffset.y >= CGRectGetMinY(self.nameLabel.frame) - nameLabelHeight &&
        scrollView.contentOffset.y <= CGRectGetMaxY(self.nameLabel.frame) - nameLabelHeight) {
        
        [self.slidingNameView setAlpha:
         (CGFloat)NameLabelSize / (CGFloat)((CGRectGetMaxY(self.nameLabel.frame) - nameLabelHeight) - scrollView.contentOffset.y)];
        
        
        self.slidingNameLabel.frame =
        [self.scrollView convertRect:self.nameLabel.frame toView:self.slidingNameView];
        
    }
    
    if (scrollView.contentOffset.y > CGRectGetMaxY(self.nameLabel.frame) - nameLabelHeight) {
        [self.slidingNameView setAlpha:1];
        
        CGRect frame = self.slidingNameLabel.frame;
        frame.origin = CGPointMake(0, 0);
        self.slidingNameLabel.frame = frame;
        
    }
    
    
}

#pragma mark - Another methods

- (UILabel *)deepLabelCopy:(UILabel *)label
{
    UILabel *duplicateLabel = [[UILabel alloc] initWithFrame:label.frame];
    duplicateLabel.text = label.text;
    duplicateLabel.textColor = label.textColor;
    duplicateLabel.font = label.font;
    duplicateLabel.textAlignment = label.textAlignment;
        
    return duplicateLabel;
}


@end
