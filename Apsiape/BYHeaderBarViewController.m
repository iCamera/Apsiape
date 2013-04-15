//
//  BYHeaderBarViewController.m
//  Apsiape
//
//  Created by Dario Lass on 13.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYHeaderBarViewController.h"
#import "InterfaceConstants.h"

@interface BYHeaderBarView : UIView

@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIButton *addButton;

@end

@implementation BYHeaderBarView

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchButton setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
        _searchButton.frame = CGRectMake(5, 5, HEADER_BUTTON_WIDTH, HEADER_BUTTON_HEIGHT);
    }
    return _searchButton;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
        _addButton.frame = CGRectMake(self.frame.size.width - HEADER_BUTTON_WIDTH - 5, 5, HEADER_BUTTON_WIDTH, HEADER_BUTTON_HEIGHT); 
    }
    return _addButton;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:.95 alpha:1];
    }
    return self;
}

- (void)layoutSubviews {
//    [self addSubview:self.searchButton];
//    [self addSubview:self.addButton];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] setStroke];
    CGContextSetLineWidth(context, 3);
    CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGContextDrawPath(context, kCGPathStroke);
}

@end

@interface BYHeaderBarViewController ()

@end

@implementation BYHeaderBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view = [[BYHeaderBarView alloc]initWithFrame:self.view.bounds];
}

@end
