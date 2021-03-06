//
//  PXViewController.m
//  PXMaskButton
//
//  Created by Daniel Blakemore on 05/01/2015.
//  Copyright (c) 2014 Daniel Blakemore. All rights reserved.
//

#import "PXViewController.h"
#import "PXView.h"

@interface PXViewController ()

@end

@implementation PXViewController

- (PXView*)contentView
{
    return (PXView*)[self view];
}

- (void)loadView
{
    [self setView:[[PXView alloc] init]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setTitle:@"PX Mask Button"];
    
    [[self view] setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    [[[self navigationController] navigationBar] setBarTintColor:[UIColor orangeColor]];
    [[[self navigationController] navigationBar] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

@end
