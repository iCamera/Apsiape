//
//  BYNewExpenseViewController.m
//  Apsiape
//
//  Created by Dario Lass on 28.05.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "BYNewExpenseViewController.h"
#import "BYQuickShotView.h"
#import "BYExpenseKeyboard.h"
#import "Expense.h"
#import "BYStorage.h"
#import "BYCursorLabel.h"

@interface BYNewExpenseViewController () <BYQuickShotViewDelegate, BYExpenseKeyboardDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UINavigationBar *headerBar;
@property (nonatomic, strong) UIImage *capturedPhoto;
@property (nonatomic, strong) BYQuickShotView *quickShotView;
@property (nonatomic, strong) NSMutableString *expenseValue;
@property (nonatomic, strong) BYCursorLabel *expenseValueLabel;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIScrollView *pagingScrollView;

- (void)dismiss;

@end

@implementation BYNewExpenseViewController

#define KEYBOARD_HEIGHT 240

- (UINavigationBar *)headerBar
{
    if (!_headerBar) {
        _headerBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    }
    return _headerBar;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    if (!self.mainScrollView) self.mainScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    if (!self.pagingScrollView) self.pagingScrollView = [[UIScrollView alloc]initWithFrame:self.mainScrollView.bounds];
    
    self.mainScrollView.backgroundColor = [UIColor blackColor];
    self.pagingScrollView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    self.mainScrollView.frame = self.view.bounds;
    self.mainScrollView.contentSize = self.mainScrollView.frame.size;
    self.pagingScrollView.frame = self.mainScrollView.bounds;
    self.pagingScrollView.pagingEnabled = YES;
    self.pagingScrollView.contentSize = CGSizeMake(self.mainScrollView.frame.size.width * 3, self.mainScrollView.frame.size.height);
    self.pagingScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.alwaysBounceVertical = YES;
    self.mainScrollView.delegate = self;
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.pagingScrollView];
    self.mainScrollView.layer.cornerRadius = 10;
    self.mainScrollView.layer.borderWidth = 2;
    self.mainScrollView.layer.borderColor = [UIColor blackColor].CGColor;
    self.mainScrollView.layer.masksToBounds = YES;
    
    self.expenseValue = [[NSMutableString alloc]initWithCapacity:30];
    BYExpenseKeyboard *keyboard = [[BYExpenseKeyboard alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - KEYBOARD_HEIGHT, 320, KEYBOARD_HEIGHT)];
    self.expenseValueLabel = [[BYCursorLabel alloc]initWithFrame:CGRectMake(10, 10, 300, 80)];
    [self.pagingScrollView addSubview:self.expenseValueLabel];
    keyboard.delegate = self;
    [self.pagingScrollView addSubview:keyboard];
    
    self.quickShotView = [[BYQuickShotView alloc]initWithFrame:CGRectMake(320, 0, self.pagingScrollView.frame.size.width, self.pagingScrollView.frame.size.height)];
    self.quickShotView.delegate = self;
    [self.pagingScrollView addSubview:self.quickShotView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
}

- (void)numberKeyTapped:(NSString *)numberString
{
    NSRange decSeparatorRange = [self.expenseValue rangeOfString:@"."];
    if (decSeparatorRange.length == 1) {
        if (decSeparatorRange.location < self.expenseValue.length - 2) return;
        if ([numberString isEqualToString:@"."]) return;
    }
    if (self.expenseValue.length == 7) return;
    
    [self.expenseValue appendString:numberString];
    self.expenseValueLabel.text = self.expenseValue;
}
- (void)deleteKeyTapped
{
    if (self.expenseValue.length < 1) {
        return;
    } else {
        NSRange range = NSMakeRange(self.expenseValue.length - 1, 1);
        [self.expenseValue deleteCharactersInRange:range];
    }
    self.expenseValueLabel.text = self.expenseValue;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.expenseValue.length != 0) {
        Expense *newExpense = [NSEntityDescription insertNewObjectForEntityForName:@"Expense" inManagedObjectContext:[[BYStorage sharedStorage]managedObjectContext]];
        newExpense.value = self.expenseValue;
        newExpense.image = self.capturedPhoto;
        [[BYStorage sharedStorage]saveDocument];
    }
}
- (void)didTakeSnapshot:(UIImage *)img
{
    self.capturedPhoto = img;
}
- (void)didDiscardLastImage
{
    self.capturedPhoto = nil;
}
- (void)dismiss
{
    [self.view removeFromSuperview];
}

@end
