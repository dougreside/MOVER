//
//  LoadingView.m
//  LiveLoop
//
//  Created by Vijay on 15/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//  

#import "LoadingViewFB.h"


@implementation LoadingViewFB

static UIActivityIndicatorView *activityIndicator;
static UIAlertView* alertView;

+(void)displayLoadingIndicator
{
	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	activityIndicator.hidesWhenStopped = YES;
	alertView = [[UIAlertView alloc] initWithTitle:@"Please wait copying audio..." message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
	[alertView addSubview:activityIndicator];
	activityIndicator.frame = CGRectMake(284/2 - 16, 218/3 - 16, 32.0, 32.0);
    [alertView show];
    [activityIndicator startAnimating];
}


+(void)removeLoadingIndicator
{
	if (alertView != nil)
    {
		[alertView dismissWithClickedButtonIndex:0 animated:NO];
        alertView = nil;
	}
}


@end
