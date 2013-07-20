//
//  MainWebControllerViewController.m
//  NYPL
//
//  Created by shahnwaz on 10/29/12.
//  Copyright (c) 2012 shahnwaz. All rights reserved.
//

#import "MainWebControllerViewController.h"
#import "AppDelegate.h"
#import "NYPLMenuViewController.h"
#import "VersionPopView.h"
#import "DatabaseConnection.h"
#import "Version.h"
#import "BaseScrollView.h"
#import "Play.h"
#import "AppDelegate.h"
#import "NoteView.h"
#import "AnimateViews.h"
#import "CustomView.h"
#import "HighlightObject.h"
#import "BookmarkViewController.h"
#import "Bookmark.h"
#import "AnnotateViewController.h"
#import "LoadingViewFB.h"
#import "Audio.h"
#define ADDAUDIO_TAG 2345
#define CANCELBUTTON_TAG 2346
#define PLAYFROMLIBRARYBUTTON_TAG 2347
#define PURCHASEBUTTON_TAG 2348

@implementation MainWebControllerViewController

@synthesize isFav;
@synthesize playID;
@synthesize currentPlayTitle;
@synthesize currentPlayAuthor;

@synthesize playArray,verArray;
@synthesize versionButton;
@synthesize baseScrollView;
@synthesize versionLabel;
@synthesize audioFilePath,audioSelectionInnerHtmlString,audioNoteID,songFileName;
@synthesize exportURL;
@synthesize playbackTimer;
@synthesize audioObj;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Adding add note Menu controller
    UIMenuItem *addNoteMenu = [[UIMenuItem alloc] initWithTitle:@"Add Notes" action:@selector(highlightNotes)];
    UIMenuController *mc = [UIMenuController sharedMenuController];
	[mc setMenuItems:[NSArray arrayWithObjects:addNoteMenu, nil]];
    verArray = [[NSMutableArray alloc] init];
    [self setttingArray];
    
    playView.frame = CGRectMake(0, self.view.frame.size.height, playView.frame.size.width, playView.frame.size.height);
    [self.view addSubview:playView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return 0;
}

- (BOOL)shouldAutorotate
{
    return NO;
}


#pragma mark -
#pragma mark User Define methods

- (void)setttingArray
{
    DatabaseConnection *dbCon = [DatabaseConnection sharedConnection];
    NSLog(@"%d play id",self.playID);
    self.playArray = [dbCon SelectVersionDetail:[NSString stringWithFormat:@"SELECT * FROM VERSION where PLAY_ID=%i", self.playID]];
   
    NSMutableArray *htmlFileArray = [[NSMutableArray alloc] init];
    for (Version* ver in self.playArray){
        NSLog(@"%@ file name",ver.htmlFileName);

        [htmlFileArray addObject:ver.htmlFileName];
    }
    
    for (Version* ver in self.playArray)
        [self.verArray addObject:ver.versionName];    
    
    id obj = [self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count]-2)];
    
    if([obj isKindOfClass:[BookmarkViewController class]]) {
        BookmarkViewController *bookMarkViewContrler = (BookmarkViewController*)obj;
        NSIndexPath *indexPath = [bookMarkViewContrler.bookmarkTableView indexPathForSelectedRow];
        Bookmark *bookmark = [[bookMarkViewContrler.sections valueForKey:[[[bookMarkViewContrler.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
         baseScrollView = [[BaseScrollView alloc] initWithFrame:CGRectMake(10, 80, 300, 370) andDataSource:htmlFileArray withDelegate:self isFromNBView:YES withCurrentVersionNO:bookmark.versionNo];
        self.currentPlayTitle = bookmark.playTitle;
        self.currentPlayAuthor = bookmark.playAuthorName;
        [baseScrollView jumpToView:bookmark.versionNo];
        baseScrollView.mPrevView = baseScrollView.mPrevView-1;
        
    } else if([obj isKindOfClass:[AnnotateViewController class]]) {
        AnnotateViewController* annotateViewController=(AnnotateViewController*)obj;
        NSIndexPath* indexPath=[annotateViewController.noteTableView indexPathForSelectedRow];
        HighlightObject *highlightObj = [[annotateViewController.sections valueForKey:[[[annotateViewController.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        baseScrollView=[[BaseScrollView alloc] initWithFrame:CGRectMake(10, 80, 300, 370) andDataSource:htmlFileArray withDelegate:self isFromNBView:YES withCurrentVersionNO:highlightObj.versionNo];
        self.currentPlayTitle = highlightObj.playTitle;
        self.currentPlayAuthor = highlightObj.playAuthorName;
        [baseScrollView jumpToView:highlightObj.versionNo];
        baseScrollView.mPrevView = baseScrollView.mPrevView-1;
        
    } else {
        baseScrollView = [[BaseScrollView alloc] initWithFrame:CGRectMake(10, 80, 300, 370) andDataSource:htmlFileArray withDelegate:self isFromNBView:NO withCurrentVersionNO:0];
    }
    baseScrollView.webDelegate = self;
   
    [self.view addSubview:baseScrollView];
    [self.view bringSubviewToFront:coverImage];
    [self.view bringSubviewToFront:brandingImageView];
    [self.view bringSubviewToFront:navBarImageView];
    [self.view bringSubviewToFront:backButton];
    [self.view bringSubviewToFront:versionButton];
    [self.view bringSubviewToFront:versionLabel];
    [self.view bringSubviewToFront:versionImageView];
    [self.view bringSubviewToFront:fontButton];
    [self.view bringSubviewToFront:bookmarkButton];
    [self.view bringSubviewToFront:webLoader];
        
    UIFont *myFont = FONT_TAHOMA_REGULAR(17);
    [versionLabel setFont:myFont];
    versionLabel.textColor = kColor(255, 154, 4, 1);
    NSString *titles = [self.currentPlayTitle stringByAppendingFormat:@" : %@",[baseScrollView getVersionName:[verArray objectAtIndex:0]]];
    versionLabel.text = titles;
}


- (NSString*)getFilePathNameForArticleId:(NSString *)folderName andFileName:(NSString*)fileName
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
	NSMutableString *documentsDirectory = [[NSMutableString alloc]initWithString:[paths objectAtIndex:0]];
	documentsDirectory = (NSMutableString*)[documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@/%@",folderName,fileName]];
	if(![fileManager fileExistsAtPath:documentsDirectory])
		return nil;
	return documentsDirectory;
}

- (void)checkStatusOfBookmarkButton
{
    DatabaseConnection* dbCon=[DatabaseConnection sharedConnection];
    NSArray* dataArray=[dbCon SelectBookmarkDetail:[NSString stringWithFormat:@"Select * from BOOKMARK where PLAY_ID=%i AND VERSION_NO=%d",playID,currentIndex]];
    if ([dataArray count]==0)
        [bookmarkButton setSelected:FALSE];
    else
        [bookmarkButton setSelected:TRUE];
}

- (void)fontchange
{
    [baseScrollView.currentCustomView.currentWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"uiWebview_changeCSS('%@.css')",[NSString stringWithFormat:@"style%i",currentFontSize]]];
}

- (void)popViewController
{
    id obj = [self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count]-2)];
    if([obj isKindOfClass:[AnnotateViewController class]])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark -
#pragma mark UIButton Event methods

- (IBAction)Back_Clicked:(id)sender
{
    [self onAudioCancelButtonClicked:nil];
    AppDelegate* delegate=[UIApplication sharedApplication].delegate;
    
    if (isFav)
    {
        delegate.nyplMenuViewController.hidden = NO;
        isFav = FALSE;
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)Version_Clicked:(id)sender
{
    [self onAudioCancelButtonClicked:nil];
    DatabaseConnection *dbCon = [DatabaseConnection sharedConnection];
    Play *play = [dbCon PlayDetail:[NSString stringWithFormat:@"SELECT * FROM PLAY where _id=%i",self.playID]];
    popUp=[[VersionPopView alloc] initWithNibName:@"VersionPopView" bundle:nil];
    popUp.versionArray=verArray;
    popUp.mainWebControllerViewController=self;
    popUp.playTitle = play.playTitle;
    [self.view addSubview:popUp.view];
}

- (IBAction)Bookmark_Clicked:(id)sender
{
    NSString *query = nil;
    DatabaseConnection *dbCon = [DatabaseConnection sharedConnection];
    UIAlertView *alert = nil;
    if (bookmarkButton.selected)
    {
        [bookmarkButton setSelected:FALSE];
        query = [NSString stringWithFormat:@"delete from BOOKMARK where PLAY_ID = \"%d\" and VERSION_NO=%d",playID,currentIndex];
        if ([dbCon deleteRowOfBookMarkTable:query])
            alert=[[UIAlertView alloc] initWithTitle:@"NYPL" message:@"Bookmark deleted successfully." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        if ([[dbCon SelectBookmarkDetail:[NSString stringWithFormat:@"Select * from BOOKMARK"]] count]== 0)
            alert.tag=999;
    }
    else
    {
        [bookmarkButton setSelected:TRUE];
        NSString* query=[NSString stringWithFormat:@"INSERT INTO BOOKMARK (PLAY_ID,VERSION_NO,PLAY_TITLE,PLAY_AUTHOR_NAME,IMAGE_NAME) VALUES (\"%d\",\"%d\",\"%@\",\"%@\",\"%@\")",playID,currentIndex,currentPlayTitle,currentPlayAuthor,@""];
        if ([dbCon insertIntoBookMarkTable:query])
             alert=[[UIAlertView alloc] initWithTitle:@"NYPL" message:@"Bookmark added successfully." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    }
    [alert show];
}

- (IBAction)Font_Clicked:(id)sender
{
    NSLog(@"FONT_CHANGED");
    UIButton* btn = (UIButton*)sender;
    if (currentFontSize<2 && btn.tag==10)
    {
        currentFontSize++;
        if (currentFontSize == 2) 
            btn.tag = 20;
    } else if (currentFontSize > -2  && btn.tag == 20)
    {
        currentFontSize--;
        if (currentFontSize == -2)
            btn.tag = 10;
    }
    [baseScrollView.currentCustomView.currentWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"uiWebview_changeCSS('%@.css')",[NSString stringWithFormat:@"style%i",currentFontSize]]];
}

- (IBAction)onAudioPlayButtonClicked:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    if (!btn.selected)
    {
		[player pause];
		btn.selected = YES;
        
	}
    else
    {
		[player play];
		btn.selected = NO;
	}
}

- (IBAction)onAudioCancelButtonClicked:(id)sender
{
    [playbackTimer invalidate];
    [player pause];
    playPauseButton.enabled = TRUE;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.6];
     playView.frame = CGRectMake(0, self.view.frame.size.height, playView.frame.size.width, playView.frame.size.height);
    [UIView commitAnimations];
}

- (void)onPurchaseButtonClicked:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"NYPL!" message:@"Under Devlopment." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show]; alert = nil;
}

- (void)onPlayFromLiabraryButtonClicked:(id)sender
{    
    MPMediaPickerController *pickerController =	[[MPMediaPickerController alloc]
												 initWithMediaTypes: MPMediaTypeMusic];
	pickerController.prompt = @"Choose song to export";
	pickerController.allowsPickingMultipleItems = NO;
	pickerController.delegate = self;
    [self.navigationController pushViewController:pickerController animated:YES];
    [self onClickCancelButton:nil];
}


- (void)onClickCancelButton:(id)sender
{
    UIView* popUpView=(UIView*)[self.view viewWithTag:ADDAUDIO_TAG];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.6];
    if (popUpView)
        popUpView.transform = CGAffineTransformMakeScale(0.001,0.001);
    [UIView commitAnimations];
    [self performSelector:@selector(removePopUpView) withObject:nil afterDelay:0.6];
}



#pragma mark -
#pragma mark Audio Slider Delegate Methods

- (IBAction) handleSliderValueChanged
{
    CMTime seekTime = CMTimeMake(playbackSlider.value, 1);
    [player seekToTime:seekTime];
}

- (IBAction) handleSliderTouchDown
{
	userIsScrubbing = YES;
    [playbackTimer invalidate];
    playbackTimer = nil;
}

- (IBAction) handleSliderTouchUp
{
	userIsScrubbing = NO;
    self.playbackTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(playerTimerUpdate:) userInfo:nil repeats:YES];
}

- (void) playerTimerUpdate: (NSTimer*) timer
{
   
    CMTime currentTime = player.currentTime;
    int minValue=(((int) CMTimeGetSeconds(currentTime))/60.0);
    NSString * minString=nil;
    if (minValue<10)
        minString=[NSString stringWithFormat:@"0%i",minValue];
    else
        minString=[NSString stringWithFormat:@"%i",minValue];
    
    int secondValue=audioObj.toTime-audioObj.fromTime;
     CMTime endTime = CMTimeConvertScale (player.currentItem.asset.duration,currentTime.timescale,kCMTimeRoundingMethod_RoundHalfAwayFromZero);
     NSLog(@"current time-- %d",(int) CMTimeGetSeconds(currentTime));
     NSLog(@"total music file duration-- %d",(int) CMTimeGetSeconds(player.currentItem.asset.duration));
   
    if (((int) CMTimeGetSeconds(currentTime) >= audioObj.toTime) ||((int) CMTimeGetSeconds(currentTime) == (int) CMTimeGetSeconds(player.currentItem.asset.duration))) {
        [playbackTimer invalidate];
        [player pause];
        playPauseButton.enabled = FALSE;
        playPauseButton.selected  = FALSE;
      [self onAudioCancelButtonClicked:nil];
    }
    
    
    NSString * secondString=nil;
    if (secondValue<10)
        secondString=[NSString stringWithFormat:@"0%i",secondValue];
    else
        secondString=[NSString stringWithFormat:@"%i",secondValue];
    songDurationLabel.text=[NSString stringWithFormat:@"%@:%@",minString,secondString];

   
    if (player && !userIsScrubbing)
    {
		
        if (endTime.value != 0)
        {
			playbackSlider.value =  CMTimeGetSeconds(currentTime);
		}
	}
}

- (void)setUpAVPlayerForURL:(NSURL*)url
{
    player = nil;
    [player replaceCurrentItemWithPlayerItem:nil];
    [player removeTimeObserver:self];
	player = [[AVPlayer alloc] initWithURL: url];
	if (player)
    {
		playbackSlider.hidden = NO;
		userIsScrubbing = NO;
        playbackSlider.value = 0;
        NSLog(@"player rate %f",player.rate);
        player.rate = 1;
        [player seekToTime:kCMTimeZero];
		[self performSelectorOnMainThread:@selector (createPlaybackTimer) withObject:nil waitUntilDone:YES];
	}
}

- (void)createPlaybackTimer
{
	if (playbackTimer)
    {
		[playbackTimer invalidate];
        playbackTimer = nil;
	}
	self.playbackTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(playerTimerUpdate:) userInfo:nil repeats:YES];
}


#pragma mark -
#pragma mark highlightNotes

- (BOOL)canPerformAction:(SEL)selector withSender:(id) sender
{
    if (selector == @selector(highlightNotes))
    {
        if(hideMenuOption == FALSE)
            return YES;
    }
    return NO;
}

- (void)onClickAudioIcon
{
    [self onAudioCancelButtonClicked:nil];
    UIImageView* popUpView = [[UIImageView alloc]init];
    popUpView.userInteractionEnabled=TRUE;
    popUpView.frame = CGRectMake(0,0,320,480);
    popUpView.image = [UIImage imageNamed:@"addMp3.png"];
    popUpView.transform = CGAffineTransformMakeScale(0.1,0.1);
    popUpView.tag = ADDAUDIO_TAG;
    
    UIButton* purchaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    purchaseButton.frame = CGRectMake(80, 170, 155, 30);
    purchaseButton.tag = PURCHASEBUTTON_TAG;
    [purchaseButton setImage:[UIImage imageNamed:@"btn_purchase.png"] forState:UIControlStateNormal];
    [purchaseButton addTarget:self action:@selector(onPurchaseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [popUpView addSubview:purchaseButton];

    UIButton* playFromLibraryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    playFromLibraryButton.frame = CGRectMake(80, 223, 155, 30);
    playFromLibraryButton.tag = CANCELBUTTON_TAG;
    [playFromLibraryButton setImage:[UIImage imageNamed:@"btn_library.png"] forState:UIControlStateNormal];

    [playFromLibraryButton addTarget:self action:@selector(onPlayFromLiabraryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [popUpView addSubview:playFromLibraryButton];

    
    UIButton* closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(80, 275, 155, 30);
    closeButton.tag = CANCELBUTTON_TAG;
    [closeButton setImage:[UIImage imageNamed:@"btn_cancel2.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(onClickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [popUpView addSubview:closeButton];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.6];
    popUpView.transform = CGAffineTransformMakeScale(1.0,1.0);
    [self.view addSubview:popUpView];
    [UIView commitAnimations];
}

- (void)removePopUpView
{
    UIView *popUpView = (UIView*)[self.view viewWithTag:ADDAUDIO_TAG];
    if (popUpView)
        [popUpView removeFromSuperview];
}


- (void)highlightNotes
{
    [self onAudioCancelButtonClicked:nil];
    DatabaseConnection* dbCon = [DatabaseConnection sharedConnection];
    NSString* query = [NSString stringWithFormat:@"SELECT * FROM VERSION WHERE Play_Id=%i AND Ver_Name='version%i'",self.playID, currentIndex];
    NSString* CurrentfileName = [dbCon getSelectedVersionFileName:query];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"search" ofType:@"html"];
	NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    jsCode = [jsCode stringByAppendingString:[NSString stringWithFormat:@"highlightsText('notes.png')"]];
	NSString *htmlContent = (NSString*)[baseScrollView.currentCustomView.currentWebView stringByEvaluatingJavaScriptFromString:jsCode];
  	NSString *filePath = [self getFilePathNameForArticleId:@"HTML" andFileName:CurrentfileName];
    NSArray *selectionComponents = [htmlContent componentsSeparatedByString:@"<noteseparator>"];
	NSString *idstring;
	NSString *highlightText = @"";
    if ([selectionComponents count]>2)
	{
		if(addNotesView)
			[self removeNoteView];
        addNotesView = [[NoteView alloc] initWithNibName:@"NoteView" bundle:nil];
		htmlContent = [selectionComponents objectAtIndex:0];
        
        //Setting Note Variables
		idstring = [selectionComponents objectAtIndex:1];
		highlightText = [selectionComponents objectAtIndex:2];
        addNotesView.playID = self.playID;
		addNotesView.noteId = idstring;
        addNotesView.versionNo = currentIndex;
        addNotesView.highlightedText = highlightText;
        addNotesView.playAuthorName = currentPlayAuthor;
        addNotesView.playTitle = currentPlayTitle;
        
		//other Variables
		[addNotesView setSelectionInnerHtmlString:htmlContent];
        [addNotesView showUserNote:@""];
        [addNotesView setFilePath:filePath];
		addNotesView.view.tag = -1234;
        [addNotesView setCallerDelegate:self];
		[self.view.superview addSubview:addNotesView.view];
		[addNotesView._textNotes becomeFirstResponder];
		[[AnimateViews allocate] startAnimationOnview:addNotesView.view toView:nil animationType:BounceViewAnimationType animationSubType:0];
        hideMenuOption = FALSE;
	} 
}

#pragma mark -
#pragma mark deleteNoteForId

- (void)deleteNoteForId:(NSString*)noteId
{
    DatabaseConnection *dbCon = [DatabaseConnection sharedConnection];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM VERSION WHERE Play_Id=%i AND Ver_Name='version%i'",self.playID,currentIndex];
    NSString *CurrentfileName = [dbCon getSelectedVersionFileName:query];
    
	NSString *path = [[NSBundle mainBundle] pathForResource:@"search" ofType:@"html"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	NSString *deleteJs = [jsCode stringByAppendingString:[NSString stringWithFormat:@"deletetagValue('%@')", noteId]];
    
	[baseScrollView.currentCustomView.currentWebView stringByEvaluatingJavaScriptFromString:deleteJs];
	NSString *getInnerHtmljs = [jsCode stringByAppendingString:[NSString stringWithFormat:@"getInnerHtml()"]];
    
	NSString *selectionString = (NSString*)[baseScrollView.currentCustomView.currentWebView stringByEvaluatingJavaScriptFromString:getInnerHtmljs];
    
	NSString *filePath = [self getFilePathNameForArticleId:@"HTML" andFileName:CurrentfileName];
	NSArray *htmlComponenets = [[NSString stringWithContentsOfFile:filePath encoding:NSASCIIStringEncoding error:nil]componentsSeparatedByString:@"<body"];
	
    NSString *headerComponet;
	NSString *bodyComponent;
	NSString *footerComponent;
    
	if ([htmlComponenets count] > 0) {
		headerComponet=[htmlComponenets objectAtIndex:0];
		if ([htmlComponenets count] > 1) {
			NSArray *bodyStyleComp = [[htmlComponenets objectAtIndex:1] componentsSeparatedByString:@">"];
			if ([bodyStyleComp count] > 0)
				bodyComponent=[bodyStyleComp objectAtIndex:0];
		}
	}
    
	NSArray *htmlFooterComponents=[[NSString stringWithContentsOfFile:filePath encoding:NSASCIIStringEncoding error:nil] componentsSeparatedByString:@"</body"];
	
    if ([htmlFooterComponents count] > 1)
		footerComponent=[htmlFooterComponents objectAtIndex:1];
    
	NSError *error;
	NSString *finalHTML = [headerComponet stringByAppendingFormat:@"<body %@>",bodyComponent];
	finalHTML=[finalHTML stringByAppendingString:selectionString];
	finalHTML=[finalHTML stringByAppendingFormat:@"</body %@",footerComponent];
	[finalHTML writeToFile:filePath atomically:TRUE encoding:NSUTF8StringEncoding error:&error];
}

- (void)removeNoteView
{
    [baseScrollView.currentCustomView.currentWebView reload];
    [addNotesView.view removeFromSuperview];
}



#pragma mark -
#pragma mark UIWebview Delegate Event methods

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    webLoader.hidden=FALSE;
    [webLoader startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webLoader stopAnimating];
    webLoader.hidden = TRUE;
    //[self fontchange];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
     DatabaseConnection *objDBManager = [DatabaseConnection sharedConnection];
    if(navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        NSArray *urlCoponents = [[request.URL absoluteString] componentsSeparatedByString:@"/"];
        if([urlCoponents count] == 1)
        {
            NSArray *highLightcomponents=[[urlCoponents lastObject] componentsSeparatedByString:@":"];
            NSRange range = [[urlCoponents lastObject] rangeOfString:@"#"];
            
            if(range.location != NSNotFound)
            {
                NSLog(@"internal link..");
                return YES;
            }
           
            if ([highLightcomponents count] == 2)
            {
                HighlightObject *highLightObj = [objDBManager selectHighlightText:[NSString stringWithFormat:@"select *  from HIGHLIGHTOBJECT where highlight_id='%@'",[highLightcomponents objectAtIndex:1]]];
                
                if (highLightObj.selectedText)
                {
                    if(addNotesView)
                        [self removeNoteView];
                    addNotesView = [[NoteView alloc] initWithNibName:@"NoteView" bundle:nil];
                    [self.view.superview addSubview:addNotesView.view];
                    addNotesView.playID=highLightObj.playId;
                    [addNotesView setNoteId:[highLightcomponents objectAtIndex:1]];
                    [addNotesView setSelectionInnerHtmlString:highLightObj.selectedText];
                    [addNotesView showUserNote:highLightObj.note];
                    addNotesView.view.tag = -1234;
                    addNotesView.callerDelegate = self;
                    [addNotesView showButtonsOnNotesView:YES];
                    [addNotesView._textNotes becomeFirstResponder];
                    
                }
                return FALSE;
            }
        }
        else if ([urlCoponents count] == 11)
        {
            clipId=[[urlCoponents objectAtIndex:[urlCoponents count]-1] integerValue];
            
            if (!clipId) {
                NSString *versionToJump =[urlCoponents objectAtIndex:[urlCoponents count]-1];
                if ([[versionToJump componentsSeparatedByString:@"_"]containsObject:@"version"]) {
                    [self onAudioCancelButtonClicked:nil];
                    DatabaseConnection *dbCon = [DatabaseConnection sharedConnection];
                    Play *play = [dbCon PlayDetail:[NSString stringWithFormat:@"SELECT * FROM PLAY where _id=%i",self.playID]];
                    popUp=[[VersionPopView alloc] initWithNibName:@"VersionPopView" bundle:nil];
                    popUp.versionArray=verArray;
                    popUp.mainWebControllerViewController=self;
                    popUp.playTitle = play.playTitle;
                    [self.view addSubview:popUp.view];
                }
                return TRUE;
            }
           
            audioObj = [objDBManager audioWithClipId:[[urlCoponents objectAtIndex:[urlCoponents count]-1] integerValue] andVerId:currentIndex andPlayId:playID];
            
            
            
            if ([audioObj.audioFileName isEqualToString:@""])
                [self onClickAudioIcon];
            else
            {
                NSString *audio = @"";
                NSArray* pathArray=[audioObj.audioFileName componentsSeparatedByString:@"Caches/"];
                if ([pathArray count]>0)
                  audio  =[pathArray objectAtIndex:1];
                if (![[NSUserDefaults standardUserDefaults]boolForKey:audio]) {
                 [self onClickAudioIcon];
                    return FALSE;
                }
                 [self setUpAVPlayerForURL:[NSURL fileURLWithPath:audioObj.audioFileName] ];
                CMTime endTime = CMTimeConvertScale (player.currentItem.asset.duration,player.currentTime.timescale,kCMTimeRoundingMethod_RoundHalfAwayFromZero);
                 NSLog(@"from time %i",audioObj.fromTime);
                if ((int) CMTimeGetSeconds(endTime)<audioObj.fromTime) {
                   
                    NSLog(@"total duration %lli",endTime.value/endTime.timescale);
                    [playbackTimer invalidate];
                    [player pause];
                    playPauseButton.enabled = FALSE;
                    playPauseButton.selected  = FALSE;
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Unable to play audio!" message:@"Audio file size is too short to play at this duration." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [alert show];
                    return FALSE;
                }
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDelegate:self];
                [UIView setAnimationDuration:0.6];
                 playView.frame = CGRectMake(0, self.view.frame.size.height-playView.frame.size.height+1, playView.frame.size.width, playView.frame.size.height);
                [UIView commitAnimations];
                
               
                CMTime newTime = CMTimeMakeWithSeconds(audioObj.fromTime, 1);
               // CMTime dur= player.currentItem.duration;
                
                [player seekToTime:newTime];
                playbackSlider.maximumValue = audioObj.toTime;
                playbackSlider.minimumValue = audioObj.fromTime;
                
                [player play];
                [playbackSlider setThumbImage:[UIImage imageNamed:@"drag_red.png"] forState:UIControlStateNormal];
                [playbackSlider setMinimumTrackImage:[UIImage imageNamed:@"seek_bar_orange.png"] forState:UIControlStateNormal];
                [playbackSlider setMaximumTrackImage:[UIImage imageNamed:@"seek_bar_white.png"] forState:UIControlStateNormal];
               
                if ([pathArray count]>0) 
                    songFileNameLabel.text=[pathArray objectAtIndex:1];
            }
            return FALSE;
        }
        else if ([urlCoponents count] == 12)
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Audio functionality is not working in this html file." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            [webLoader stopAnimating];
            webLoader.hidden = TRUE;
             return FALSE;
        }
    }
    return TRUE;
}


#pragma mark MPMediaPickerControllerDelegate

- (void)mediaPicker: (MPMediaPickerController *)mediaPicker
  didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    [self.navigationController popViewControllerAnimated:YES];
	
    if ([mediaItemCollection count] < 1) {
		return;
	}
	MPMediaItem *songItem = [[mediaItemCollection items] objectAtIndex:0];
    self.songFileName=[songItem valueForProperty:MPMediaItemPropertyTitle];
	[player pause];
	userIsScrubbing = NO;
	
    if (playbackTimer) {
		[playbackTimer invalidate];
		playbackTimer = nil;
	}
    NSFileManager *fileManager = [NSFileManager defaultManager];
     NSString *exportFile = [myCacheDirectory() stringByAppendingPathComponent: [songFileName stringByAppendingString:@".m4a"]];
    if (![fileManager fileExistsAtPath:exportFile]) {
         exportFile = [self copySelectedSongIntoCache:songItem];
    }
   
    if (exportFile)
    {
        DatabaseConnection* dcon=[DatabaseConnection sharedConnection];
        [dcon updeteAudioWherePlayId:self.playID clipId:clipId versionId:currentIndex withAudioFileName:exportFile];
	}
}


- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
	 [self.navigationController popViewControllerAnimated:YES];
     [baseScrollView.currentCustomView.currentWebView reload];
}

#pragma mark UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 999 ) {
        alertView.tag = 888;
        id obj = [self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count]-2)];
       
        if([obj isKindOfClass:[BookmarkViewController class]]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        return;
    }
    else if(alertView.tag == 123456789 )
    {
        
    }
}

#pragma mark conveniences

NSString* myCacheDirectory()
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];;
}


void myDeleteFile (NSString* path)
{
	if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
		NSError *deleteErr = nil;
		[[NSFileManager defaultManager] removeItemAtPath:path error:&deleteErr];
		
        if (deleteErr) {
			NSLog (@"Can't delete %@: %@", path, deleteErr);
		}
	}
}

static void CheckResult(OSStatus result, const char *operation)
{
	if (result == noErr) return;
	
	char errorString[20];
	*(UInt32 *)(errorString + 1) = CFSwapInt32HostToBig(result);
	
    if (isprint(errorString[1]) && isprint(errorString[2]) && isprint(errorString[3]) && isprint(errorString[4])) {
		errorString[0] = errorString[5] = '\'';
		errorString[6] = '\0';
        
	} else {
        sprintf(errorString, "%d", (int)result);
    }
		
	fprintf(stderr, "Error: %s (%s)\n", operation, errorString);
	exit(1);
}


#pragma mark core audio test

- (NSString *)copySelectedSongIntoCache:(MPMediaItem*)songItem {
    
	if (! songItem) {
		return @"";
	}
	NSURL *assetURL = [songItem valueForProperty:MPMediaItemPropertyAssetURL];
	AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURL options:nil];
	AVAssetExportSession *exporter = [[AVAssetExportSession alloc]
									  initWithAsset: songAsset
									  presetName: AVAssetExportPresetAppleM4A];
	exporter.outputFileType = @"com.apple.m4a-audio";
    [LoadingViewFB displayLoadingIndicator];
    NSString *audio = [songFileName stringByAppendingString:@".m4a"];
    [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:audio];
    [[NSUserDefaults standardUserDefaults]synchronize];
	__block NSString *exportFile = [myCacheDirectory() stringByAppendingPathComponent: [songFileName stringByAppendingString:@".m4a"]];
	myDeleteFile(exportFile);
	self.exportURL = [NSURL fileURLWithPath:exportFile];
	exporter.outputURL = exportURL;
	// do the export
	[exporter exportAsynchronouslyWithCompletionHandler:^
     {
         int exportStatus = exporter.status;
         switch (exportStatus) {
             case AVAssetExportSessionStatusFailed: {
                 NSError *exportError = exporter.error;
                 NSLog (@"AVAssetExportSessionStatusFailed: %@", exportError);
                 break;
             }
             case AVAssetExportSessionStatusCompleted: {
                 NSString* string=[self enablePCMConversionIfCoreAudioCanOpenURL: exporter.outputURL];
                 if (string.length!=0)
                     exportFile=string;
                 [LoadingViewFB removeLoadingIndicator];
                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:audio];
                 [[NSUserDefaults standardUserDefaults]synchronize];
                 break;
             }
             case AVAssetExportSessionStatusUnknown: {
                 NSLog (@"AVAssetExportSessionStatusUnknown"); break;
             }
             case AVAssetExportSessionStatusExporting: {
                 NSLog (@"AVAssetExportSessionStatusExporting"); break;
             }
             case AVAssetExportSessionStatusCancelled: {
                 NSLog (@"AVAssetExportSessionStatusCancelled"); break;
             }
             case AVAssetExportSessionStatusWaiting: {
                 NSLog (@"AVAssetExportSessionStatusWaiting"); break;
             }
             default: {
                 NSLog (@"didn't get export status"); break;
             }
         }
     }];
    return exportFile;
}


BOOL coreAudioCanOpenURL (NSURL* url) {
    
	OSStatus openErr = noErr;
	AudioFileID audioFile = NULL;
	openErr = AudioFileOpenURL((__bridge CFURLRef) url, kAudioFileReadPermission ,0,&audioFile);
	if (audioFile) 
		AudioFileClose (audioFile);
	return openErr ? NO : YES;
}


- (NSString *) enablePCMConversionIfCoreAudioCanOpenURL:(NSURL*)url {
	BOOL coreAudioCanOpen =  coreAudioCanOpenURL (url);
    if (coreAudioCanOpen) {
        NSLog(@"Core Audio can open this file");
        return nil;
        
    } else {
        NSLog(@"Core Audio cannot open this file") ;
        return [self convertedToPCMFile];
    }
}

- (NSString *)convertedToPCMFile
{
	ExtAudioFileRef inputFile;
	CheckResult (ExtAudioFileOpenURL((__bridge CFURLRef)exportURL, &inputFile),
				 "ExtAudioFileOpenURL failed");
	// prepare to convert to a plain ol' PCM format
	AudioStreamBasicDescription myPCMFormat;
	myPCMFormat.mSampleRate = 44100; // todo: or use source rate?
	myPCMFormat.mFormatID = kAudioFormatLinearPCM ;
	myPCMFormat.mFormatFlags =  kAudioFormatFlagsCanonical;
	myPCMFormat.mChannelsPerFrame = 2;
	myPCMFormat.mFramesPerPacket = 1;
	myPCMFormat.mBitsPerChannel = 16;
	myPCMFormat.mBytesPerPacket = 4;
	myPCMFormat.mBytesPerFrame = 4;
	CheckResult (ExtAudioFileSetProperty(inputFile, kExtAudioFileProperty_ClientDataFormat,
                                         sizeof (myPCMFormat), &myPCMFormat),
                 "ExtAudioFileSetProperty failed");
    
	// allocate a big buffer. size can be arbitrary for ExtAudioFile.
	// you have 64 KB to spare, right?
	UInt32 outputBufferSize = 0x10000;
	void* ioBuf = malloc (outputBufferSize);
	UInt32 sizePerPacket = myPCMFormat.mBytesPerPacket;
	UInt32 packetsPerBuffer = outputBufferSize / sizePerPacket;
	
	// set up output file
	NSString *outputPath = [myCacheDirectory() stringByAppendingPathComponent:[songFileName stringByAppendingString:@".caf"]];
	NSURL *outputURL = [NSURL fileURLWithPath:outputPath];
	AudioFileID outputFile;
	CheckResult(AudioFileCreateWithURL((__bridge CFURLRef)outputURL,
									   kAudioFileCAFType,
									   &myPCMFormat,
									   kAudioFileFlags_EraseFile,
									   &outputFile),
                "AudioFileCreateWithURL failed");
	
	// start convertin'
	UInt32 outputFilePacketPosition = 0; //in bytes
	
	while (true) {
		// wrap the destination buffer in an AudioBufferList
		AudioBufferList convertedData;
		convertedData.mNumberBuffers = 1;
		convertedData.mBuffers[0].mNumberChannels = myPCMFormat.mChannelsPerFrame;
		convertedData.mBuffers[0].mDataByteSize = outputBufferSize;
		convertedData.mBuffers[0].mData = ioBuf;
		UInt32 frameCount = packetsPerBuffer;
		// read from the extaudiofile
		CheckResult (ExtAudioFileRead(inputFile,
									  &frameCount,
									  &convertedData),
					 "Couldn't read from input file");
		
		if (frameCount == 0) {
			printf ("done reading from file");
			break;
		}
		// write the converted data to the output file
		CheckResult (AudioFileWritePackets(outputFile,
										   false,
										   frameCount,
										   NULL,
										   outputFilePacketPosition / myPCMFormat.mBytesPerPacket,
										   &frameCount,
										   convertedData.mBuffers[0].mData),
					 "Couldn't write packets to file");
		// advance the output file write location
		outputFilePacketPosition += (frameCount * myPCMFormat.mBytesPerPacket);
	}
	// clean up
	ExtAudioFileDispose(inputFile);
	AudioFileClose(outputFile);
	
    // show size in label
	if ([[NSFileManager defaultManager] fileExistsAtPath:outputPath]) {
		NSError *fileManagerError = nil;
		unsigned long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:outputPath error:&fileManagerError]fileSize];
		
        if (fileManagerError) {
            NSLog (@"%@", fileManagerError.localizedFailureReason);
            
		} else {
            NSLog (@"%@", [NSString stringWithFormat: @"%lld bytes", fileSize]);
		}
        
	} else {
		NSLog (@"no file at %@", outputPath);
	}
	return outputPath;
}
@end