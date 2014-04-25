//
//  NoteView.m
//  NYPL
//
//  Created by shahnwaz on 10/29/12.
//  Copyright (c) 2012 shahnwaz. All rights reserved.
//

#import "NoteView.h"
#import "MainWebControllerViewController.h"
#import "DatabaseConnection.h"

@implementation NoteView

@synthesize _textNotes;
@synthesize highlightedText;
@synthesize noteId;
@synthesize filePath;
@synthesize selectionInnerHtmlString;
@synthesize playAuthorName;
@synthesize playTitle;

@synthesize callerDelegate;
@synthesize isAlreadyNote;

@synthesize playID;
@synthesize versionNo;


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self._textNotes = nil;
    self.highlightedText = nil;
    self.noteId = nil;
    self.filePath = nil;
    self.selectionInnerHtmlString = nil;
    self.playAuthorName = nil;
    self.playTitle = nil;
}

-(NSUInteger)supportedInterfaceOrientations {
    return 0;
}
- (BOOL)shouldAutorotate {
    return NO;
}


#pragma mark -
#pragma mark Button Event Handling methods

-(IBAction)btnCancelAction {
    
	if([callerDelegate respondsToSelector:@selector(removeNoteView)])
		[callerDelegate removeNoteView];
}


- (IBAction)btnSaveAction {
    
    if([[_textNotes.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter any text." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        alert = nil;
        return;
    }
   
    DatabaseConnection *objDBManger = [DatabaseConnection sharedConnection];
	
    if (noteId && highlightedText) {
        //PLAY_ID,MP3_ID,VERSION_NO,AUDIO_FILENAME
        NSString *query = [NSString stringWithFormat:@"insert into HIGHLIGHTOBJECT (PLAY_ID,HIGHLIGHT_ID,NOTE,VERSION_NO,SELECT_TEXT,PLAY_AUTHOR_NAME,PLAY_TITLE) values (%i,\"%@\",\"%@\",%i,\"%@\",\"%@\",\"%@\")",self.playID,[noteId stringByReplacingOccurrencesOfString:@"'" withString:@"''"],
            [_textNotes.text stringByReplacingOccurrencesOfString:@"'" withString:@"''"],
            self.versionNo,
           [highlightedText stringByReplacingOccurrencesOfString:@"\"" withString:@""],
            playAuthorName,
            playTitle];
        NSLog(@"query to add notes %@",query);
		[objDBManger saveOrDeleteNotes:query];
		[self saveNoteInHTML];
		[self btnCancelAction];
	}
    isAlreadyNote = NO;
}


- (IBAction)btnEditAction {
    
    if([[_textNotes.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"Please enter any text." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show]; alert = nil;
        return;
    }
    
	DatabaseConnection *objDBManger=[DatabaseConnection sharedConnection];
	NSString* query = [NSString stringWithFormat:@"update HIGHLIGHTOBJECT set NOTE = '%@' where HIGHLIGHT_ID = %@",[_textNotes.text stringByReplacingOccurrencesOfString:@"'" withString:@"''"],noteId];
    BOOL result = [objDBManger updateNotesInfo:query];
    
    if(result) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Update Notes" message:@"Notes have been updated successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show]; alert = nil;
    }
    [self btnCancelAction];
}


- (IBAction)btnDeleteAction {
    
	DatabaseConnection *objDBManger = [DatabaseConnection sharedConnection];
	BOOL result =  [objDBManger saveOrDeleteNotes:[NSString stringWithFormat:@"delete from HIGHLIGHTOBJECT where HIGHLIGHT_ID = '%@'",noteId]];
	if ([((NSObject*)self.callerDelegate) respondsToSelector:@selector(deleteNoteForId:)])
    {
		[self.callerDelegate deleteNoteForId:noteId];
		[self btnCancelAction];
	}
    UIAlertView *alert = nil;
    
    if(result == YES) {
        alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Note has been deleted successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    if ([[objDBManger SelectHighlightObjectDetail:[NSString stringWithFormat:@"Select * from HIGHLIGHTOBJECT"]] count] == 0) {
        alert.tag = 666;
    }
}

#pragma mark User Define Methods

- (void)showButtonsOnNotesView:(BOOL)isUpdateBtnHidden {
    
    if (isUpdateBtnHidden) {
        btnSave.hidden = TRUE;
        btnDelete.hidden = FALSE;
        btnUpdate.hidden = FALSE;
        btnCancel.frame=CGRectMake(btnCancel.frame.origin.x - 39, btnCancel.frame.origin.y, btnCancel.frame.size.width, btnCancel.frame.size.height);
        
    } else {
        btnSave.hidden = FALSE;
        btnDelete.hidden = TRUE;
        btnUpdate.hidden = TRUE;
    }
}

- (void)saveNoteInHTML {
    
	NSArray *htmlComponenets = [[NSString stringWithContentsOfFile:filePath encoding:NSASCIIStringEncoding error:nil] componentsSeparatedByString:@"<body"];
	
	NSString *headerComponet = @"";
	NSString *bodyComponent = @"";
	NSString *footerComponent = @"";
	
	if ([htmlComponenets count] > 0) {
		headerComponet = [htmlComponenets objectAtIndex:0];
		if ([htmlComponenets count] > 1) {
			NSArray *bodyStyleComp = [[htmlComponenets objectAtIndex:1] componentsSeparatedByString:@">"];
			if ([bodyStyleComp count] > 0)
            {
				bodyComponent = [bodyStyleComp objectAtIndex:0];
			}
		}
	}
    
	NSArray *htmlFooterComponents = [[NSString stringWithContentsOfFile:filePath encoding:NSASCIIStringEncoding error:nil] componentsSeparatedByString:@"</body"];
    
	if ([htmlFooterComponents count] > 1) {
		footerComponent = [htmlFooterComponents objectAtIndex:1];
	}
	NSError *error;
	NSString *finalHTML = [headerComponet stringByAppendingFormat:@"<body %@>",bodyComponent];
	finalHTML = [finalHTML stringByAppendingString:selectionInnerHtmlString];
	finalHTML = [finalHTML stringByAppendingFormat:@"</body %@",footerComponent];
	[finalHTML writeToFile:filePath atomically:TRUE encoding:NSUTF8StringEncoding error:&error];
}

- (void)showUserNote:(NSString*)text {
	[_textNotes setText:text];
}

#pragma mark -
#pragma mark UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView commitAnimations];
	return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView commitAnimations];
	return YES;
}

- (BOOL)textView:(UITextView *)texview shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    
	if([text isEqualToString:@"\n"]) {
        texview.text=[texview.text stringByAppendingString:@"\n"];
		return NO;
	}
	return YES;
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 666) {
        alertView.tag = 777;
        [self.callerDelegate popViewController];
    }
}
@end