//
//  ViewController.m
//  ColorClock
//
//  Created by syshen on 12/16/14.
//  Copyright (c) 2014 Mechanical Dog. All rights reserved.
//

#import "ViewController.h"

@interface UIView (Autolayout)
+(id)autolayoutView;
@end

@implementation UIView (Autolayout)
+(id)autolayoutView
{
    UIView *view = [self new];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}
@end

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *colorCodeLabel;
@property (nonatomic, strong) NSTimer  *timer;

@property (nonatomic, strong) NSMutableArray *centralLayouts;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.scrollView.contentSize = self.view.bounds.size;
    self.timeLabel = [UILabel autolayoutView];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.text = @"-";
    self.timeLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:50];
    self.timeLabel.textColor = [UIColor whiteColor];
    
    [self.scrollView addSubview:self.timeLabel];
    
    self.colorCodeLabel = [UILabel autolayoutView];
    self.colorCodeLabel.textAlignment = NSTextAlignmentCenter;
    self.colorCodeLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16];
    self.colorCodeLabel.text = @"#";
    self.colorCodeLabel.textColor = [UIColor whiteColor];
    
    [self.scrollView addSubview:self.colorCodeLabel];
    UILabel *colorCodeLabel = self.colorCodeLabel;
    UIScrollView *scrollView = self.scrollView;
    UILabel *timeLabel = self.timeLabel;
    
    NSDictionary *dict = NSDictionaryOfVariableBindings(scrollView, colorCodeLabel, timeLabel);
    NSArray *topLayouts = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[timeLabel(120)]-30-[colorCodeLabel(60)]" options:NSLayoutFormatAlignAllLeft metrics:nil views:dict];
    
    [self updateCentralLayouts];
    [self.scrollView addConstraints:topLayouts];
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:colorCodeLabel
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1.0
                                                                 constant:0]];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshTime) userInfo:nil repeats:YES];

}

- (void) updateCentralLayouts {
    if (self.centralLayouts) {
        [self.scrollView removeConstraints:self.centralLayouts];
        [self.centralLayouts removeAllObjects];
    } else {
        self.centralLayouts = [NSMutableArray array];
    }
    
    CGFloat width = self.view.frame.size.width;
    NSDictionary *metrics = @{@"width": @(width)};
    UILabel *colorCodeLabel = self.colorCodeLabel;
    UIScrollView *scrollView = self.scrollView;
    UILabel *timeLabel = self.timeLabel;
    
    NSDictionary *dict = NSDictionaryOfVariableBindings(scrollView, colorCodeLabel, timeLabel);
    NSArray *centralLayouts = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[timeLabel(width)]|" options:NSLayoutFormatAlignAllBaseline metrics:metrics views:dict];
    NSArray *central2Layouts = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[colorCodeLabel(width)]|" options:NSLayoutFormatAlignAllBaseline metrics:metrics views:dict];

    [self.centralLayouts addObjectsFromArray:centralLayouts];
    [self.centralLayouts addObjectsFromArray:central2Layouts];
    [self.scrollView addConstraints:self.centralLayouts];
}

- (BOOL) prefersStatusBarHidden {
    return YES;
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (!CGSizeEqualToSize(self.scrollView.contentSize, self.view.frame.size)) {
        [self updateCentralLayouts];
        self.scrollView.contentSize = self.view.frame.size;
    }
}

- (NSDateFormatter*) dateFormatter {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"HH : mm : ss";
    });
    return formatter;
}

- (NSUInteger) hexified:(NSUInteger)from {
    return (NSUInteger)(from / 10) * 16 + (NSUInteger)(from % 10);
}

- (void) refreshTime {
    NSDate *now = [NSDate date];
    self.timeLabel.text = [[self dateFormatter] stringFromDate:now];
    
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:now];
    UIColor *color = [UIColor colorWithRed:(CGFloat)[self hexified:comps.hour]/255.0 green:(CGFloat)[self hexified:comps.minute]/255.0 blue:(CGFloat)[self hexified:comps.second]/255.0 alpha:1.0];
    self.view.backgroundColor = color;
    
    self.colorCodeLabel.text = [NSString stringWithFormat:@"#%02ld%02ld%02ld", comps.hour, comps.minute, comps.second];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
