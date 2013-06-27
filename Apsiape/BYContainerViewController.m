//  BYContainerViewController.m
//  Apsiape
//
//  Created by Dario Lass on 03.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.

#import "BYContainerViewController.h"
#import "BYMainViewController.h"
#import "UIImage+ImageFromView.h"
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>
#import "BYMapViewController.h"
#import "BYNewExpenseViewController.h"

@interface BYContainerViewController () 

@property (nonatomic, strong) BYMainViewController *mainViewController;
@property (nonatomic, strong) BYNewExpenseViewController *expenseVC;
@property (nonatomic, strong) UINavigationBar *navBar;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic) BOOL mainViewControllerVisible;
@property (nonatomic, strong) BYMapViewController *mapViewController;
@property (nonatomic, strong) UIWindow *backgroundWindow;

- (void)mapButtonTapped;

@end

@implementation BYContainerViewController 

#define HEADER_HEIGHT 44
#define FOOTER_HEIGHT 40
#define SHADOW_HEIGHT 30
#define MAP_HEIGHT 280

+ (BYContainerViewController *)sharedContainerViewController {
    static BYContainerViewController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BYContainerViewController alloc] initWithNibName:nil bundle:nil];
        NSLog(@"SINGLETON: BYContainerViewController now exists.");
    });
    
    return sharedInstance;
}

- (BYMainViewController *)mainViewController {
    if (!_mainViewController) _mainViewController = [[BYMainViewController alloc]init];
    return _mainViewController; 
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    [self addChildViewController:self.mainViewController];
    self.mainViewController.view.frame = CGRectMake(0, HEADER_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - (HEADER_HEIGHT/* + FOOTER_HEIGHT*/));
    [self.view addSubview:self.mainViewController.view];
    [self.mainViewController didMoveToParentViewController:self];
    self.mainViewControllerVisible = YES;
    
    self.navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, HEADER_HEIGHT)];
    [self.view insertSubview:self.navBar aboveSubview:self.mainViewController.view];
    [self.navBar setBackgroundImage:[UIImage imageNamed:@"Layout_0002_NavBar.png"] forBarMetrics:UIBarMetricsDefault];
    self.navBar.tintColor = [UIColor whiteColor];
}

- (void)displayExpenseCreationViewController
{
    self.expenseVC = [[BYNewExpenseViewController alloc]init];
    self.expenseVC.view.frame = self.view.bounds;
    [self.view addSubview:self.expenseVC.view];
    
}

- (void)dismissExpenseCreationViewController
{
    [self.expenseVC.view removeFromSuperview];
    [self.navBar pushNavigationItem:nil animated:YES];
}

- (void)mapButtonTapped
{
    if (self.mainViewControllerVisible) {
        [self displayMapView];
    } else {
        [self dismissMapView];
    }
}

- (void)displayMapView
{
    CGRect mainViewFrame = self.mainViewController.view.frame;
    mainViewFrame.size.height -= MAP_HEIGHT;
    
    if (!self.mapViewController) {
        self.mapViewController = [[BYMapViewController alloc]init];
        self.mapViewController.view.backgroundColor = [UIColor darkGrayColor];
        [self addChildViewController:self.mapViewController];
        self.mapViewController.view.frame = CGRectMake(0, CGRectGetMaxY(self.view.bounds), self.view.frame.size.width, MAP_HEIGHT);
        [self.view addSubview:self.mapViewController.view];
        [self.mapViewController didMoveToParentViewController:self];
    }
    [UIView animateWithDuration:1 animations:^{
        self.mainViewController.view.frame = mainViewFrame;
        self.mainViewController.collectionView.frame = self.mainViewController.view.bounds;
        self.mapViewController.view.frame = CGRectMake(0, CGRectGetMaxY(self.view.bounds) - MAP_HEIGHT, self.view.frame.size.width, MAP_HEIGHT);
        self.mainViewControllerVisible = NO;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissMapView
{
    CGRect mainViewFrame = self.mainViewController.view.frame;
    mainViewFrame.size.height += MAP_HEIGHT;
    
    [UIView animateWithDuration:1 animations:^{
        self.mainViewController.view.frame = mainViewFrame;
        self.mainViewController.collectionView.frame = self.mainViewController.view.bounds;
        self.mapViewController.view.frame = CGRectMake(0, CGRectGetMaxY(self.view.bounds), self.view.frame.size.width, MAP_HEIGHT);
        self.mainViewControllerVisible = YES;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)splitAnimationOverlayViewDidFinishOpeningAnimation
{
    
}
- (void)splitAnimationOverlayViewDidFinishClosingAnimation
{
    
}

@end
