//
//  DatabaseConnection.h
//  Wimbo Music
//
//  Created by Rakhi goel on 16/08/11.
//  Copyright 2011 KiwiTech. All rights reserved.
//
//  Edited --@prakash

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class Play;
@class HighlightObject;
@class Audio;
@class Version;

@interface DatabaseConnection : NSObject {
	 NSString *databasePath;
}

// Initial methods------- Added By @Prakash
+ (DatabaseConnection *)sharedConnection;
- (void)createDatabase:(NSString *)DBName;
- (void)removeAllItemsFromTable:(NSString *)tblName;


// Play Table Methods
- (void)addPlay:(Play *)play;
- (NSArray *)SelectPlayDetail:(NSString *)query;
- (Play *)PlayDetail:(NSString *)query;


// Version Table Methods
- (void)addVersion:(Version *)version;
- (NSString *)getSelectedVersionFileName:(NSString *)query;
- (NSArray *)SelectVersionDetail:(NSString *)query;


// Bookmark Table Methods 
- (NSArray *)SelectBookmarkDetail:(NSString *)query;
- (BOOL)insertIntoBookMarkTable:(NSString*)query;
- (BOOL)deleteRowOfBookMarkTable:(NSString*)query;


// Note Table Methods
- (NSArray *)SelectHighlightObjectDetail:(NSString *)query;
- (HighlightObject *)selectHighlightText:(NSString*)query;
- (BOOL)saveOrDeleteNotes:(NSString *)query;
- (BOOL)updateNotesInfo:(NSString *)query;
// AUDIO Table Methods
- (void)addAudio:(Audio *)audio;
- (void)updeteAudio:(Audio *)audio withAudio:(Audio *)audio;
- (Audio *)audioWithClipId:(NSInteger)clipId andVerId:(NSInteger)verId
                 andPlayId:(NSInteger)playId;
- (void)updeteAudioWherePlayId:(int)playId clipId:(int)clipId versionId:(int)verId withAudioFileName:(NSString*)audioFileName;
@end
