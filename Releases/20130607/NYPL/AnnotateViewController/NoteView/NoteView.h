//
//  NoteView.h
//  NYPL
//
//  Created by shahnwaz on 10/29/12.
//  Copyright (c) 2012 shahnwaz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteView : UIViewController <UIAlertViewDelegate> {
    
	IBOutlet UIButton *btnCancel;
  	IBOutlet UIButton *btnSave;
    IBOutlet UIButton *btnUpdate;
    IBOutlet UIButton *btnDelete;
}
@property (nonatomic, retain) IBOutlet UITextView *_textNotes;
@property (nonatomic, retain) NSString *highlightedText;
@property (nonatomic, retain) NSString *noteId;
@property (nonatomic, retain) NSString *filePath;
@property (nonatomic, retain) NSString *selectionInnerHtmlString;
@property (nonatomic, retain) NSString *playAuthorName;
@property (nonatomic, retain) NSString *playTitle;

@property (nonatomic, assign) id  callerDelegate;
@property (nonatomic, assign) BOOL isAlreadyNote;

@property (nonatomic, assign) int playID;
@property (nonatomic, assign) int versionNo;

- (void)showUserNote:(NSString *)text;
- (void)showButtonsOnNotesView:(BOOL)isUpdateBtnHidden;
- (void)saveNoteInHTML;
- (IBAction)btnCancelAction;
- (IBAction)btnSaveAction;
- (IBAction)btnEditAction;
- (IBAction)btnDeleteAction;
@end
