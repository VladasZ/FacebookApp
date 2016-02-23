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
#import "PhotoViewController.h"
#import "ViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
//#import <QuartzCore/QuartzCore.h>


const CGFloat BackgroundImageScaleFactor = 0.025;
//elements size relative to screen size
const NSUInteger BackgroundImageSize = 5;
const NSUInteger AvatarSize = 3;
const NSUInteger NameLabelSize = 10;
const NSUInteger Intend = 10;
#define RGBCOLOR(r, g, b, a) [UIColor colorWithRed:r/225.0f green:g/225.0f blue:b/225.0f alpha:a]

enum InfoViewSubviews
{
    InfoViewFriendsCountLabel,
    InfoViewMutualFriendsCountLabel,
    InfoViewPhotosCountLabel,
    InfoViewFriendsLabel,
    InfoViewMutualFriendsLabel,
    InfoViewPhotosLabel
};

@interface ProfileViewController () <MFMailComposeViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *topBackgroundImageView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIImageView *scrollBackgroundImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *slidingNameLabel;
@property (nonatomic, strong) UIView *slidingNameView;

@property (nonatomic, strong) NSMutableArray *infoViewSubviews;

@property (nonatomic, weak) VZUser *user;
@property (nonatomic, strong) NSMutableArray *mutualFriends;


@end

@implementation ProfileViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mutualFriends = [self getMutalFriendsArray];
    
    [self createIntefrace];

    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController.interactivePopGestureRecognizer setDelegate:nil];
    
}

- (void)createIntefrace
{
    self.user = [self.parentController.users objectAtIndex:self.userID];
    
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
               -100,
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
    
    [self.avatarImageView setImage:[UIImage imageWithData:self.user.avatar]];
    
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.bounds.size.height / 2;
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.userInteractionEnabled = YES;
    
    [self.avatarImageView addGestureRecognizer:
     [[UITapGestureRecognizer alloc] initWithTarget:self
                                             action:@selector(didTapAvatarImage:)]];

    
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
    
    self.nameLabel.text =
    [NSString stringWithFormat:@"%@ %@", self.user.firstName, self.user.lastName];
    
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
    
    self.infoViewSubviews = [[NSMutableArray alloc] init];
    
    UIView *infoView = [[UIView alloc] initWithFrame:
    CGRectMake(Intend,
               CGRectGetMaxY(self.nameLabel.frame),
               self.view.frame.size.width - Intend * 2,
               self.scrollView.frame.size.height)];
    
    [infoView setBackgroundColor:RGBCOLOR(255, 255, 255, 0.2)];
    
    infoView.layer.cornerRadius = 20;
    infoView.layer.masksToBounds = YES;
    
    
#pragma mark info view count labels
    
    NSUInteger infoSubviewsSize = infoView.frame.size.width / 3;
    
    for (NSUInteger i = 0; i < 3; i++) {
        
        UILabel *countLabel = [[UILabel alloc] initWithFrame:
        CGRectMake(infoSubviewsSize * i + Intend,
                   Intend,
                   infoSubviewsSize - Intend,
                   (infoSubviewsSize - Intend) / 2)];
        
        [countLabel setText:
         [@[[NSString stringWithFormat:@"%lu", (unsigned long)self.user.rlsFriends.count],
            [NSString stringWithFormat:@"%lu", (unsigned long)self.mutualFriends.count],
            @"0"] objectAtIndex:i]
         ];
        
        [self setDefaultStyleToView:countLabel];
        
        [countLabel setTextAlignment:NSTextAlignmentCenter];
        [countLabel setFont:[UIFont systemFontOfSize:50]];
        [countLabel setTextColor:[UIColor whiteColor]];
        
        if (i == InfoViewFriendsCountLabel) {
            
            [countLabel addGestureRecognizer:
             [[UITapGestureRecognizer alloc] initWithTarget:self
                                                     action:@selector(didTapFriendsLabel:)]];

        }
        
        if (i == InfoViewMutualFriendsCountLabel) {
            
            [countLabel addGestureRecognizer:
             [[UITapGestureRecognizer alloc] initWithTarget:self
                                                     action:@selector(didTapMutualLabel:)]];
            
        }
        
        [self.infoViewSubviews addObject:countLabel];
        
    }
    
    
  
    
#pragma mark info view labels
    
    for (NSUInteger i = 0; i < 3; i++) {
        
        UILabel *countLabel = [[UILabel alloc] initWithFrame:
        CGRectMake(infoSubviewsSize * i  + Intend,
                   Intend * 2 + (infoSubviewsSize - Intend) / 2,
                   infoSubviewsSize - Intend,
                   (infoSubviewsSize - Intend) / 3)];
        
        [countLabel setText:
         
         [@[@"Friends", @"Mutual", @"Photos"] objectAtIndex:i]
         
         ];
        
        [self setDefaultStyleToView:countLabel];
        
        [countLabel setTextAlignment:NSTextAlignmentCenter];
        [countLabel setFont:[UIFont systemFontOfSize:20]];
        [countLabel setTextColor:[UIColor whiteColor]];
        
        [self.infoViewSubviews addObject:countLabel];
        
    }
    
//    infoViewFriendsCountLabel,
//    infoViewMutualFriendsCountLabel,
//    infoViewPhotosCountLabel,
//    infoViewFriendsLabel,
//    infoViewMutualFriendsLabel,
//    infoViewPhotosLabel
    
    
#pragma mark phone label
    
    UILabel *lastLabel = [self.infoViewSubviews lastObject];
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:
    CGRectMake(Intend,
               CGRectGetMaxY(lastLabel.frame) + Intend,
               infoView.frame.size.width - Intend * 2,
               50)];
    
    [self setDefaultStyleToView:phoneLabel];
    [phoneLabel setTextColor:[UIColor whiteColor]];
    [phoneLabel setText:self.user.phone];
    [phoneLabel setTextAlignment:NSTextAlignmentCenter];
    [phoneLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                      initWithTarget:self
                                      action:@selector(didPressPhoneLabel:)]];

    
#pragma mark email label
    
    CGRect frame = phoneLabel.frame;
    
    frame.origin.y = CGRectGetMaxY(frame) + Intend;
    
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:frame];
    
    [self setDefaultStyleToView:emailLabel];
    [emailLabel setText:self.user.email];

    [emailLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                      initWithTarget:self
                                      action:@selector(didPressEmailLabel:)]] ;
    
#pragma mark subviews adding
    
    [infoView addSubview:self.infoViewSubviews[InfoViewFriendsCountLabel]];
    [infoView addSubview:self.infoViewSubviews[InfoViewMutualFriendsCountLabel]];
    [infoView addSubview:self.infoViewSubviews[InfoViewPhotosCountLabel]];
    [infoView addSubview:self.infoViewSubviews[InfoViewFriendsLabel]];
    [infoView addSubview:self.infoViewSubviews[InfoViewMutualFriendsLabel]];
    [infoView addSubview:self.infoViewSubviews[InfoViewPhotosLabel]];
    [infoView addSubview:phoneLabel];
    [infoView addSubview:emailLabel];
    
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

#pragma mark - Actions

- (void)didTapAvatarImage:(UITapGestureRecognizer *)sender
{
    PhotoViewController *controller =
    [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([PhotoViewController class])];
    
    UIImageView *imageView = (UIImageView *)sender.view;
    
    controller.avatarImage = imageView.image;
    controller.name = self.nameLabel.text;
    
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didTapFriendsLabel:(UITapGestureRecognizer *)sender
{
    ViewController *controller =
    [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ViewController class])];
    
    controller.users = [self.user.rlsFriends allObjects].mutableCopy;
    
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)didTapMutualLabel:(UITapGestureRecognizer *)sender
{
    ViewController *controller =
    [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ViewController class])];
    
    controller.users = self.mutualFriends;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didPressPhoneLabel:(UITapGestureRecognizer *)sender
{
    UILabel *label = (UILabel *)sender.view;
    
    [[UIApplication sharedApplication]
     openURL:[NSURL URLWithString:
              [NSString stringWithFormat:@"tel:%@", label.text]]];
}

- (void)didPressEmailLabel:(UITapGestureRecognizer *)sender
{
    if([MFMailComposeViewController canSendMail]) {
        
        VZUser *user = [[[DataManager sharedManager] allVZUsersData] objectAtIndex:self.userID];
        
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;
        
        [mailCont setSubject:[NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName]];
        [mailCont setToRecipients:[NSArray arrayWithObject:user.email]];
        [mailCont setMessageBody:@"Hi! How are you?" isHTML:NO];
        
        [self presentViewController:mailCont animated:YES completion:nil];
    }

}

#pragma mark - MFMailComposeViewControllerDelegate implementation

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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

- (NSMutableArray *)getMutalFriendsArray
{
    NSMutableArray *mutualFriendsArray = [[NSMutableArray alloc] init];
    
    VZUser *rootUser = [[[DataManager sharedManager] allVZUsersData] firstObject];
    VZUser *currentUser = [self.parentController.users objectAtIndex:self.userID];
    
    for (VZUser *rootUserFriend in rootUser.rlsFriends) {
        
        for (VZUser *currentUserFriend in currentUser.rlsFriends) {
            
            if (rootUserFriend == currentUserFriend) {
                
                [mutualFriendsArray addObject:currentUserFriend];
                
            }
            
        }
        
    }
    
    return mutualFriendsArray;
}

- (void)setDefaultStyleToView:(UIView *)view
{
    [view setBackgroundColor:RGBCOLOR(0, 0, 100, 0.5)];
    [view setUserInteractionEnabled:YES];

    view.layer.cornerRadius = 20;
    view.layer.masksToBounds = YES;
    
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)view;
        
        [label setTextColor:[UIColor whiteColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
    }

}


@end
