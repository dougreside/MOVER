//
//  ViewController.m
//  NYPL
//
//  Created by shahnwaz on 10/23/12.
//  Copyright (c) 2012 shahnwaz. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "NYPLMenuViewController.h"
#import "DatabaseConnection.h"
#import "Play.h"
#import "MainWebControllerViewController.h"
#import "PlayViewController.h"
#import "DownloadController.h"

@implementation ViewController
@synthesize currnetPlayID;
@synthesize currentPlayAuthor;
@synthesize playTitle;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    icarousel.type = iCarouselTypeCoverFlow;
    icarousel.backgroundColor = [UIColor clearColor];
    
    DatabaseConnection* dbCon = [DatabaseConnection sharedConnection];
    NSArray *arrToSort = [dbCon SelectPlayDetail:[NSString stringWithFormat:@"Select * from PLAY where FAV=%i",1]];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"playTitle" ascending:YES];
    _dataArray= [NSArray arrayWithArray:[arrToSort sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]] ];
    [icarousel reloadData];
    [self unzippingHTMLFile];
    [self setFontSetting];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    icarousel = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppDelegate* delegate = [UIApplication sharedApplication].delegate;
    delegate.nyplMenuViewController.hidden = YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return 0;
}
- (BOOL)shouldAutorotate
{
    return NO;
}


- (void)setFontSetting
{
    UIFont *myFont = FONT_TAHOMA_BOLD(15);
    [titleLabel setFont:myFont];
    titleLabel.textColor = kColor(154, 4, 4, 1);
    
    myFont = FONT_TAHOMA_REGULAR(13);
    [authorLabel setFont:myFont];
    [contentLabel setFont:myFont];
    authorLabel.textColor = contentLabel.textColor = kColor(42, 42, 42, 1);
}

#pragma mark -
#pragma mark UIButton Event  methods

- (IBAction)FullText_Clicked:(id)sender
{
    MainWebControllerViewController* mainWebControllerViewController=[[MainWebControllerViewController alloc] initWithNibName:@"MainWebControllerViewController" bundle:nil];
    mainWebControllerViewController.isFav=TRUE;
    mainWebControllerViewController.playID=self.currnetPlayID;
    mainWebControllerViewController.currentPlayAuthor=currentPlayAuthor;
    mainWebControllerViewController.currentPlayTitle=playTitle;
    allPlaySearchBar.text=@"";
    [self.navigationController pushViewController:mainWebControllerViewController animated:YES];
}

#pragma mark -
#pragma mark User Define  methods

- (void)unzippingHTMLFile
{
	if(![[NSUserDefaults standardUserDefaults] objectForKey:@"ISAPPFIRSTTIMELOADING"])
	{
		DownloadController *downloadController = [DownloadController sharedController];
		[downloadController setSender:self];
		UIViewController *Currentview = self;
		[downloadController setController:Currentview.view];
        [downloadController addLoaderForView];
		[downloadController createDownloadQueForQueData];
		[[NSUserDefaults standardUserDefaults] setObject:@"TRUE" forKey:@"ISAPPFIRSTTIMELOADING"];
	}
}



#pragma mark -
#pragma mark iCarousel Data Source methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return [_dataArray count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
         reusingView:(UIView *)view {
    
	UIButton *button = (UIButton *)view;
	if (button == nil) {
		UIImage *image = [UIImage imageNamed:@"frame1.png"];
		button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.frame = CGRectMake(30.0f, 130, 120, 118);
		[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[button setBackgroundImage:image forState:UIControlStateNormal];
		button.titleLabel.font = [button.titleLabel.font fontWithSize:50];
		[button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
	}
	return button;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel {
    return 160;
}

#pragma mark -
#pragma mark iCarousel Delegate methods

- (void)carouselDidEndDecelerating:(iCarousel *)carousel {
    
    Play* play = (Play*)[_dataArray objectAtIndex:carousel.currentItemIndex];
    titleLabel.text = play.playTitle;
    authorLabel.text = play.authorName;
    contentLabel.text = play.authorInfo;
    self.currnetPlayID = play.playId;
    self.currentPlayAuthor = play.authorName;
    self.playTitle = play.playTitle;
}

- (void)carouselDidScroll:(iCarousel *)carousel {
    
    Play *play = (Play*)[_dataArray objectAtIndex:carousel.currentItemIndex];
    titleLabel.text = play.playTitle;
    authorLabel.text = play.authorName;
    contentLabel.text = play.authorInfo;
    self.currnetPlayID = play.playId;
    self.currentPlayAuthor = play.authorName;
    self.playTitle = play.playTitle;
}

#pragma mark -
#pragma mark Button tap event

- (void)buttonTapped:(UIButton *)sender
{
    [allPlaySearchBar resignFirstResponder];
	NSInteger index = [icarousel indexOfItemView:sender];
    MainWebControllerViewController *mainWebControllerViewController = [[MainWebControllerViewController alloc] initWithNibName:@"MainWebControllerViewController" bundle:nil];
    Play *pl = [_dataArray objectAtIndex:index];
    mainWebControllerViewController.isFav = TRUE;
    mainWebControllerViewController.playID = pl.playId;
    mainWebControllerViewController.currentPlayTitle = pl.playTitle;
    mainWebControllerViewController.currentPlayAuthor = pl.authorName;
    allPlaySearchBar.text = @"";
    [self.navigationController pushViewController:mainWebControllerViewController animated:YES];
}

#pragma mark -
#pragma mark UITextFieldDelegate Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (allPlaySearchBar.text.length==0) 
        return YES;
    PlayViewController* playViewController=[[PlayViewController alloc] initWithNibName:@"PlayViewController" bundle:nil];
    playViewController.searchText=allPlaySearchBar.text;
    allPlaySearchBar.text=@"";
    [self.navigationController pushViewController:playViewController animated:YES];
    return YES;
}

@end
