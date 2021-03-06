//
//  BYExpenseCreationViewController.m
//  Apsiape
//
//  Created by Dario Lass on 28.05.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "BYExpenseCreationViewController.h"
#import "UIImage+Adjustments.h"
#import "BYQuickShotView.h"
#import "BYExpenseKeyboard.h"
#import "Expense.h"
#import "BYStorage.h"
#import "BYCursorLabel.h"
#import "BYPullScrollView.h"
#import "BYTableViewController.h"
#import "BYLocalizer.h"

@interface BYExpenseCreationViewController () <BYQuickShotViewDelegate, BYExpenseKeyboardDelegate, BYPullScrollViewDelegate>

@property (nonatomic, strong) BYQuickShotView *quickShotView;
@property (nonatomic, strong) NSMutableString *expenseValueRawString;
@property (nonatomic, strong) BYCursorLabel *expenseValueLabel;
@property (nonatomic, strong) UILabel *photoLabel;
@property (nonatomic, strong) BYPullScrollView *pullScrollView;

- (NSString*)expenseValueCurrencyFormattedString;
- (NSNumber*)expenseValueDecimalNumber;

@end

@implementation BYExpenseCreationViewController

#define KEYBOARD_HEIGHT 220

- (void)viewWillAppear:(BOOL)animated
{
//    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.pullScrollView = [[BYPullScrollView alloc]initWithFrame:CGRectInset(self.view.bounds, POPOVER_INSET_X, POPOVER_INSET_Y)];
    self.pullScrollView.pullScrollViewDelegate = self;
    
    self.pullScrollView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.pullScrollView.layer.borderWidth = 0.5;
    
    self.pullScrollView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.pullScrollView];
    
    
    self.expenseValueRawString = [[NSMutableString alloc]initWithCapacity:30];
    
    BYExpenseKeyboard *keyboard = [[BYExpenseKeyboard alloc]initWithFrame:CGRectMake(0, self.pullScrollView.frame.size.height - KEYBOARD_HEIGHT, self.pullScrollView.frame.size.width, KEYBOARD_HEIGHT)];
    self.expenseValueLabel = [[BYCursorLabel alloc]initWithFrame:CGRectMake(10, 10, self.pullScrollView.bounds.size.width - 20, 50)];
    self.expenseValueLabel.backgroundColor = [UIColor clearColor];
    self.expenseValueLabel.textColor = [UIColor darkTextColor];
    self.expenseValueLabel.font = [UIFont fontWithName:@"Miso-Light" size:40];
    [self.pullScrollView.childScrollView addSubview:self.expenseValueLabel];
    keyboard.delegate = self;
    keyboard.font = [UIFont fontWithName:@"Miso" size:24];
    [self.pullScrollView.childScrollView addSubview:keyboard];
    
    CGRect rect = CGRectInset(self.pullScrollView.bounds, 0, ((self.pullScrollView.frame.size.height - self.pullScrollView.frame.size.width) / 2));
    rect.origin.x = (self.pullScrollView.frame.size.width);
    
    self.photoLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 + CGRectGetWidth(self.pullScrollView.frame), 10, (CGRectGetWidth(self.pullScrollView.frame)) - 20, 50)];
    self.photoLabel.font = [UIFont fontWithName:@"Miso-Light" size:40];
    self.photoLabel.text = @"Tap to add photo";
    self.photoLabel.textAlignment = NSTextAlignmentCenter;
    [self.pullScrollView.childScrollView addSubview:self.photoLabel];
    
    self.quickShotView = [[BYQuickShotView alloc]initWithFrame:CGRectInset(rect, 0, 0)];
    self.quickShotView.delegate = self;
    [self.pullScrollView.childScrollView addSubview:self.quickShotView];
    self.pullScrollView.childScrollView.backgroundColor = [UIColor clearColor];
    rect.origin.x = (self.pullScrollView.frame.size.width * 2);
}

#pragma mark Text Input Handling

- (NSNumber*)expenseValueDecimalNumber
{
    return [NSNumber numberWithFloat:self.expenseValueRawString.floatValue];
}

- (NSString *)expenseValueCurrencyFormattedString
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setLocale:[BYLocalizer currentAppLocale]];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    formatter.currencySymbol = @"";
    NSString *string = [NSString stringWithFormat:@"%@ %@", [formatter stringFromNumber:[NSNumber numberWithFloat:self.expenseValueRawString.floatValue]], [[BYLocalizer currentAppLocale] objectForKey:NSLocaleCurrencySymbol]];
    return string;
}

- (void)numberKeyTapped:(NSString *)numberString
{
    NSRange decSeparatorRange = [self.expenseValueRawString rangeOfString:@"."];
    if (decSeparatorRange.length == 1) {
        if (decSeparatorRange.location == self.expenseValueRawString.length - 3) return;
        if ([numberString isEqualToString:@"."]) return;
    }
    [self.expenseValueRawString appendString:numberString];
    self.expenseValueLabel.text = self.expenseValueCurrencyFormattedString;
}

- (void)deleteKeyTapped
{
    if (self.expenseValueRawString.length < 1) {
        return;
    } else {
        NSRange range = NSMakeRange(self.expenseValueRawString.length - 1, 1);
        [self.expenseValueRawString deleteCharactersInRange:range];
    }
    self.expenseValueLabel.text = self.expenseValueCurrencyFormattedString;
}

#pragma mark Delegation (PullScrollView)

- (void)pullScrollView:(UIScrollView *)pullScrollView didDetectPullingAtEdge:(BYEdgeType)edge
{
    if (edge == BYEdgeTypeBottom || edge == BYEdgeTypeLeft) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:BYNavigationControllerShouldDismissExpenseCreationVCNotificationName object:nil];
    } else if ((edge == BYEdgeTypeRight || edge == BYEdgeTypeTop) && self.expenseValueRawString.length != 0){
        [[BYStorage sharedStorage] saveExpenseObjectWithStringValue:self.expenseValueCurrencyFormattedString
                                                        numberValue:self.expenseValueDecimalNumber
                                                       fullResImage:self.quickShotView.fullResCapturedImage
                                                         completion:^(BOOL success) {
                                                             //
                                                         }];
        [[NSNotificationCenter defaultCenter] postNotificationName:BYNavigationControllerShouldDismissExpenseCreationVCNotificationName object:nil];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }
}

#pragma mark Delegation (BYQuickShotView)

- (void)quickShotViewDidFinishPreparation:(BYQuickShotView *)quickShotView
{
    
}

- (void)quickShotView:(BYQuickShotView *)quickShotView didTakeSnapshot:(UIImage *)img
{
    self.photoLabel.text = @"Tap to retake";
}

- (void)quickShotViewDidDiscardLastImage:(BYQuickShotView *)quickShotView
{
    self.photoLabel.text = @"Tap to add photo";
}

@end
