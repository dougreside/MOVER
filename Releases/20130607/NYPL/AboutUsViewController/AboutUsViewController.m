//
//  AboutUsViewController.m
//  NYPL
//
//  Created by shahnwaz on 10/23/12.
//  Copyright (c) 2012 shahnwaz. All rights reserved.
//

#import "AboutUsViewController.h"
#import "AppDelegate.h"
#import "NYPLMenuViewController.h"
#import "Global.h"

@interface AboutUsViewController ()

@end


@implementation AboutUsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIFont *myFont = FONT_TAHOMA_REGULAR(13);
    [titleLabel setFont:myFont];
    titleLabel.textColor = kColor(255, 154, 4, 1);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (BOOL)shouldAutorotate
{
       return NO;
}

#pragma mark -
#pragma mark UIButton Event methods
- (IBAction)Back_Clicked:(id)sender {
    AppDelegate* delegate = [UIApplication sharedApplication].delegate;
    [delegate.nyplMenuViewController showRequiredController:RootTabSelected];
    delegate.nyplMenuViewController.hidden = NO;
}
@end