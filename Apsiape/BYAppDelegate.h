//
//  BYAppDelegate.h
//  Apsiape
//
//  Created by Dario Lass on 27.02.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYMainViewController;

@interface BYAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) BYMainViewController *viewController;

@end
