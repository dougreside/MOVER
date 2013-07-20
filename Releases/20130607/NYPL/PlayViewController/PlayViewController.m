//
//  PlayViewController.m
//  NYPL
//
//  Created by shahnwaz on 10/23/12.
//  Copyright (c) 2012 shahnwaz. All rights reserved.
//

#import "PlayViewController.h"
#import "AppDelegate.h"
#import "NYPLMenuViewController.h"
#import "Global.h"
#import "DatabaseConnection.h"
#import "Play.h"
#import "PlayCustomCell.h"
#import "MainWebControllerViewController.h"
#import "ViewController.h"
@implementation PlayViewController

@synthesize searchText;
@synthesize  sections;
@synthesize dataArray = _dataArray;
@synthesize playTableView;
- (void)viewDidAppear:(BOOL)animated
{
    [self getDataForBookmarkTable];
}
- (void)getDataForBookmarkTable
{
    playSearchBar.text = @"";
    DatabaseConnection*dbCon = [DatabaseConnection sharedConnection];
    _dataArray = [dbCon SelectPlayDetail:[NSString stringWithFormat:@"Select * from PLAY"]];
    self.filteredListContent = [_dataArray mutableCopy];
    [self setDataForPlay];
    [self checkStatusOfInfoLabel];
    [playTableView reloadData];
}
- (void)viewDidLoad
{
    self.filteredListContent = [[NSMutableArray alloc] init];
   
    self.sections = [[NSMutableDictionary alloc] init];
    self.filteredListContent = [_dataArray mutableCopy];
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filterContentforText) name:UITextFieldTextDidChangeNotification object:nil];
    [titleLabel setFont:FONT_TAHOMA_REGULAR(17)];
    [titleLabel setTextColor:kColor(255, 154, 4, 1)];
    playTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    if (searchText) {
        playSearchBar.text = searchText;
        [self.filteredListContent removeAllObjects];
        
        for (Play *product in _dataArray) {
            NSComparisonResult result = [product.playTitle compare:searchText options:(NSCaseInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            if (result == NSOrderedSame) {
                [self.filteredListContent addObject:product];
            }
        }
        [self setDataForPlay];
        [playTableView reloadData];
    }
    [self checkStatusOfInfoLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return 0;
}
- (BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark -
#pragma mark User Defined Method

-(void)setDataForPlay
{
    self.sections = [[NSMutableDictionary alloc] init];
    BOOL found;
    
    // Loop through the Play and create our keys
    for (Play *play in self.filteredListContent) {

        NSString *c = [play.playTitle substringToIndex:1];
        found = NO;
        
        for (NSString *str in [self.sections allKeys]) {
            if ([str isEqualToString:c]) {
                found = YES;
            }
        }
        
        if (!found) {
            [self.sections setValue:[[NSMutableArray alloc] init] forKey:c];
        }
    }
    
    // Loop again and sort the Play into their respective keys
    for (Play *play in self.filteredListContent) {
        [[self.sections objectForKey:[play.playTitle substringToIndex:1]] addObject:play];
    }
    
    // Sort each section array
    for (NSString *key in [self.sections allKeys]) {
        [[self.sections objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"playTitle" ascending:YES]]];
    }
}

- (void)checkStatusOfInfoLabel
{
    infoLabel.hidden = ([self.filteredListContent count] > 0);
}

- (void)filterContentforText
{
    NSString* string = playSearchBar.text;
    [self.filteredListContent removeAllObjects]; // First clear the filtered array.
   
    for (Play *product in _dataArray) {
        NSComparisonResult result = [product.playTitle compare:string options:(NSCaseInsensitiveSearch) range:NSMakeRange(0, string.length)];
        if (result == NSOrderedSame)
            [self.filteredListContent addObject:product];
    }
    [self setDataForPlay];
    [playTableView reloadData];
    [self checkStatusOfInfoLabel];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = nil;
    cellIdentifier = [NSString stringWithFormat:@"cell%d%d",indexPath.row,indexPath.section];
    PlayCustomCell *cell = (PlayCustomCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        UIViewController* viewController = [[UIViewController alloc] initWithNibName:@"PlayCustomCell" bundle:nil];
        cell = (PlayCustomCell*)viewController.view;
        viewController = nil;
    }
    Play *play = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    cell.titleLable.text = play.playTitle;
    UIFont* myFont=FONT_TAHOMA_BOLD(15);
    [cell.titleLable setFont:myFont];
    cell.titleLable.textColor = kColor(154, 4, 4, 1);
    
    cell.authorLabel.text = play.authorName;
    myFont=FONT_TAHOMA_REGULAR(13);
    [cell.authorLabel setFont:myFont];
    cell.authorLabel.textColor = kColor(42, 42, 42, 1);
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero] ;
    cell.selectedBackgroundView.backgroundColor = kColor(106, 5, 5, 1);
    return cell;
}


#pragma mark -
#pragma mark Table view Delegate Methods

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImage *image = [UIImage imageNamed:@"bar_red.png"];
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    imageview.image = image;
    imageview.userInteractionEnabled=YES;
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(imageview.frame.size.width-20, image.size.height/2-11, 20, 20)];
    labelTitle.text = [[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
    UIFont* myfont=FONT_TAHOMA_BOLD(13);
    [labelTitle setFont:myfont];
    [imageview addSubview:labelTitle];
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.textColor = kColor(255, 154, 4, 1);;
    
    return imageview;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.sections allKeys] count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    [playSearchBar resignFirstResponder];
    MainWebControllerViewController* mainWebControllerViewController=[[MainWebControllerViewController alloc] initWithNibName:@"MainWebControllerViewController" bundle:nil];
    Play *play = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    mainWebControllerViewController.playID = play.playId;
    mainWebControllerViewController.currentPlayAuthor = play.authorName;
    mainWebControllerViewController.currentPlayTitle = play.playTitle;
    [self.navigationController pushViewController:mainWebControllerViewController animated:YES];
}
#pragma mark -
#pragma mark UIButton Event methods

-(IBAction)Back_Clicked:(id)sender
{
    AppDelegate* delegate=[UIApplication sharedApplication].delegate;
    if (searchText)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [delegate.nyplMenuViewController showRequiredController:RootTabSelected];
    delegate.nyplMenuViewController.hidden=NO;
}

-(void)onClcikHeaderButton:(id)sender
{
    NSLog(@"hello");
}

#pragma mark -
#pragma mark UITextfield Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}



- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self checkStatusOfInfoLabel];
}

@end
