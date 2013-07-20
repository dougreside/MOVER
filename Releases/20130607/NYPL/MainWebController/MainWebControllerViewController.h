//
//  MainWebControllerViewController.h
//  NYPL
//
//  Created by shahnwaz on 10/29/12.
//  Copyright (c) 2012 shahnwaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

@class VersionPopView;
@class NoteView;
@class BaseScrollView;
@class Play;
@class Audio;
@interface MainWebControllerViewController : UIViewController
<UIWebViewDelegate, MPMediaPickerControllerDelegate, UIAlertViewDelegate> {
    
    VersionPopView *popUp;
    NoteView       *addNotesView;
    BaseScrollView *baseScrollView;
    
    IBOutlet UIImageView *coverImage;
    IBOutlet UIImageView *brandingImageView;
    IBOutlet UIImageView *navBarImageView;
    IBOutlet UIImageView *versionImageView;
      
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *fontButton;
    IBOutlet UIButton *bookmarkButton;
    IBOutlet UIButton *versionButton;
    
    IBOutlet UIActivityIndicatorView* webLoader;
    IBOutlet UISlider *playbackSlider;
    IBOutlet UIView *playView;
    
    IBOutlet UIButton *playPauseButton;
    IBOutlet UILabel *songFileNameLabel;
    IBOutlet UILabel *songDurationLabel;
    
    AVPlayer *player;
	NSTimer  *playbackTimer;
    BOOL hideMenuOption;
    BOOL userIsScrubbing;
    int clipId;
    
   
}

// Play
@property (nonatomic, assign) NSInteger         playID;
@property (nonatomic, retain) NSString          *currentPlayTitle;
@property (nonatomic, assign) BOOL              isFav;
@property (nonatomic, retain) NSString          *currentPlayAuthor;
//

@property (nonatomic, retain) BaseScrollView    *baseScrollView;
@property (nonatomic, retain) IBOutlet UIButton *versionButton;
@property (nonatomic, retain) IBOutlet UILabel  *versionLabel;

@property (nonatomic, retain) NSArray           *playArray;
@property (nonatomic, retain) NSMutableArray    *verArray;

@property (nonatomic, retain) NSString          *audioFilePath;
@property (nonatomic, retain) NSString          *audioSelectionInnerHtmlString;
@property (nonatomic, retain) NSString          *audioNoteID;
@property (nonatomic, retain) NSString          *songFileName;

@property (nonatomic, retain) NSURL             *exportURL;
@property (nonatomic, retain) NSTimer           *playbackTimer;

@property (nonatomic, retain) Audio* audioObj;
- (IBAction)Back_Clicked:(id)sender;
- (IBAction)Version_Clicked:(id)sender;
- (IBAction)Bookmark_Clicked:(id)sender;
- (IBAction)Font_Clicked:(id)sender;
- (NSString*)getFilePathNameForArticleId:(NSString *)folderName
                             andFileName:(NSString*)fileName;
- (void)setttingArray;
- (void)removeNoteView;
- (void)deleteNoteForId:(NSString*)noteId;
- (void)checkStatusOfBookmarkButton;
- (void)fontchange;
- (void)popViewController;
- (void)onPlayFromLiabraryButtonClicked:(id)sender;
- (void)onPurchaseButtonClicked:(id)sender;
- (void)onClickCancelButton:(id)sender;
- (NSString*)copySelectedSongIntoCache:(MPMediaItem*)songItem;
- (NSString*)convertedToPCMFile;
- (IBAction)onAudioPlayButtonClicked:(id)sender;
- (IBAction)onAudioCancelButtonClicked:(id)sender;
- (void) setUpAVPlayerForURL:(NSURL*)url;
@end
