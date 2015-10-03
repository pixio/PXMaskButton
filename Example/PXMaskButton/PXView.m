//
//  PXView.m
//  PXMaskButton
//
//  Created by Calvin Kern on 6/11/15.
//  Copyright (c) 2015 Daniel Blakemore. All rights reserved.
//

#import "PXView.h"
#import <PXMaskButton/PXMaskButton.h>

@implementation PXView
{
    NSMutableArray* _constraints;
    
    PXMaskButton* _button;
    UIImageView* _backgroundImageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self == nil) {
        return nil;
    }
    
    _constraints = [NSMutableArray array];
    
    _backgroundImageView = [[UIImageView alloc] init];
    [_backgroundImageView setTranslatesAutoresizingMaskIntoConstraints:FALSE];
    [_backgroundImageView setImage:[UIImage imageNamed:@"lamb"]];
    [_backgroundImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:_backgroundImageView];

    _button = [[PXMaskButton alloc] init];
    [_button setTranslatesAutoresizingMaskIntoConstraints:FALSE];
    [_button setClipsToBounds:TRUE];
    [_button setText:@"lamb"];
    [_button setCornerRadius:20.f];
    [_button setBorderColor:[UIColor greenColor]];
    [_button setBorderWidth:8.f];
    [_button setTintColor:[UIColor greenColor]];
    [_button setFont:[UIFont boldSystemFontOfSize:420]];
    [_button setFontSize:30];
    [_button setIcon:[UIImage imageNamed:@"sheeplamb"]];
    [self addSubview:_button];
    
    [self setNeedsUpdateConstraints];
    return self;
}

- (void)updateConstraints
{
    [self removeConstraints:_constraints];
    [_constraints removeAllObjects];

    NSDictionary* views = NSDictionaryOfVariableBindings(_backgroundImageView, _button);
    NSDictionary* metrics = @{@"bh" : @100};

    [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_backgroundImageView]|" options:0 metrics:metrics views:views]];
    [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_backgroundImageView]|" options:0 metrics:metrics views:views]];
    
    [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_button(bh)]" options:0 metrics:metrics views:views]];
    [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_button(bh)]" options:0 metrics:metrics views:views]];
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_button attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f]];
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    
    [self addConstraints:_constraints];
    [super updateConstraints];
}

@end
