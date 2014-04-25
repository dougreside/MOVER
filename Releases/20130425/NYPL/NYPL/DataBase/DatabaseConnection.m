//
//  DatabaseConnection.m
//  Wimbo Music
//
//  Created by Rakhi goel on 16/08/11.
//  Copyright 2011 KiwiTech. All rights reserved.
//
//  Edited --@prakash

#import "Play.h"
#import "Version.h"
#import "DatabaseConnection.h"
#import "Global.h"
#import "HighlightObject.h"
#import "Bookmark.h"
#import "Audio.h"

@interface DatabaseConnection ()
- (BOOL)executeQuery:(NSString *)query;
@end


@implementation DatabaseConnection

static DatabaseConnection * _sharedDBConnection = nil;
sqlite3 *database;

#pragma mark -
#pragma mark Public Methods


// Singleton Methods
+ (DatabaseConnection *)sharedConnection {
	@synchronized(self) {
        if (_sharedDBConnection == nil) 
            _sharedDBConnection = [[self alloc] init];
    }
    return _sharedDBConnection;
}

// Method to create database into cache with @param : DBname
- (void)createDatabase:(NSString *)DBName {
    
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent:DBName];
    
	NSFileManager *filemgr = [NSFileManager defaultManager];
	
    // Check if already created.
    if ([filemgr fileExistsAtPath:databasePath]) return;
   	
    // Get the path to the database in the application package
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DBName];
	
    // Copy the database from the package to the users filesystem
    if(![filemgr copyItemAtPath:databasePathFromApp toPath:databasePath error:nil]) {
        NSLog(@"Error to create database"); return;
    }
    NSLog(@"database successfully created !");
}


// Global method to remove all object from a table - @param : tblName
- (void)removeAllItemsFromTable:(NSString *)tblName {
    NSString *query = [NSString stringWithFormat:@"DELETE FROM %@;",tblName];
    if([self executeQuery:query])
        NSLog(@"all version are deleted...");
}

#pragma mark -
#pragma mark PLAY

- (void)addPlay:(Play *)play {
    // Add your Play here.
    NSString *query_srt = [[NSString alloc] initWithFormat:@"insert into PLAY (Play_Id,Play_Name,Image_URL,Author,Author_Info,Caption,Fav) values('%i','%@','%@','%@','%@','%@','%i');", play.playId, play.playTitle, play.imageURL, play.authorName,play.authorInfo, play.captionName, play.isFav];
    if([self executeQuery:query_srt])
        NSLog(@"version is Inserted...");
}

- (NSArray *)SelectPlayDetail:(NSString *)query {
    
	NSMutableArray *playList=[[NSMutableArray alloc]init];
	if(sqlite3_open([databasePath UTF8String],&database) == SQLITE_OK) {
		
        const char *sql = [query UTF8String];
		sqlite3_stmt *statement;
        
		if(sqlite3_prepare_v2(database,sql,-1,&statement,NULL) == SQLITE_OK) {
            
            char *value = NULL;
            short indexNumber;
            
			while (sqlite3_step(statement) == SQLITE_ROW) {
                indexNumber = 1;
                               
				Play *playObj = [[Play alloc]init];
                
                playObj.playId = sqlite3_column_int(statement, indexNumber++);
                
                playObj.playTitle = (value = (char *)sqlite3_column_text(statement, indexNumber++)) == NULL ? nil : [NSString stringWithUTF8String:value];
				
                playObj.imageURL = (value = (char *)sqlite3_column_text(statement, indexNumber++)) == NULL ? nil : [NSString stringWithUTF8String:value];
                
               playObj.authorName = (value = (char *)sqlite3_column_text(statement, indexNumber++)) == NULL ? nil : [NSString stringWithUTF8String:value];
                
                playObj.authorInfo = (value = (char *)sqlite3_column_text(statement, indexNumber++)) == NULL ? nil : [NSString stringWithUTF8String:value];
                
                playObj.captionName = (value = (char *)sqlite3_column_text(statement, indexNumber++)) == NULL ? nil : [NSString stringWithUTF8String:value];
                
                playObj.isFav = sqlite3_column_int(statement, indexNumber++);
                
                [playList addObject:playObj];
			}
		}
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	return playList;
}

- (Play *)PlayDetail:(NSString *)query
{
    Play *playObj = [[Play alloc]init];
	if(sqlite3_open([databasePath UTF8String],&database) == SQLITE_OK) {
        
		const char *sql = [query UTF8String];
		sqlite3_stmt *statement;
        
		if(sqlite3_prepare_v2(database,sql,-1,&statement,NULL) == SQLITE_OK) {
            
			while (sqlite3_step(statement) == SQLITE_ROW) {
                
                char *value = NULL;
                short indexNumber = 1;
                playObj.playId = sqlite3_column_int(statement, indexNumber++);
                
                playObj.playTitle = (value = (char *)sqlite3_column_text(statement, indexNumber++)) == NULL ? nil : [NSString stringWithUTF8String:value];
				
                playObj.imageURL = (value = (char *)sqlite3_column_text(statement, indexNumber++)) == NULL ? nil : [NSString stringWithUTF8String:value];
                
                playObj.authorName = (value = (char *)sqlite3_column_text(statement, indexNumber++)) == NULL ? nil : [NSString stringWithUTF8String:value];
                
                playObj.authorInfo = (value = (char *)sqlite3_column_text(statement, indexNumber++)) == NULL ? nil : [NSString stringWithUTF8String:value];
                
                playObj.captionName = (value = (char *)sqlite3_column_text(statement, indexNumber++)) == NULL ? nil : [NSString stringWithUTF8String:value];
                
                playObj.isFav = sqlite3_column_int(statement, indexNumber++);
			}
		}
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	return playObj;
}

#pragma mark -
#pragma mark VERSION

- (void)addVersion:(Version *)version {
    // Add your version here.
    NSString *query_srt = [[NSString alloc] initWithFormat:@"insert into VERSION (Play_Id,Ver_Id,Ver_Name,HTML_Name,Audio_Name,Notes,Bookmark) values('%i','%i','%@','%@','%@','%@','%i');",version.playId, version.versionId, version.versionName, version.htmlFileName, version.audioName, version.notes, version.bookmark];
    if([self executeQuery:query_srt])
        NSLog(@"version is Inserted...");
}

- (NSString *)getSelectedVersionFileName:(NSString *)query
{
    NSString *fileName = @"";
    
	if(sqlite3_open([databasePath UTF8String],&database) == SQLITE_OK) {
		const char *sql = [query UTF8String];
		sqlite3_stmt *statement;
		if(sqlite3_prepare_v2(database,sql,-1,&statement,NULL) == SQLITE_OK) {
			if(sqlite3_step(statement) == SQLITE_ROW) {
                if(sqlite3_column_text(statement,4))
					fileName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,4)];
			}
            sqlite3_finalize(statement);
		}
		
		sqlite3_close(database);
	}
	return fileName;
}


- (NSArray *)SelectVersionDetail:(NSString *)query
{
	NSMutableArray *versionList = [[NSMutableArray alloc]init];
	if(sqlite3_open([databasePath UTF8String],&database) == SQLITE_OK) {
		const char *sql=[query UTF8String];
		sqlite3_stmt *statement;
		if(sqlite3_prepare_v2(database,sql,-1,&statement,NULL) == SQLITE_OK)
        {
			while (sqlite3_step(statement) == SQLITE_ROW)
			{
                char *value = NULL;
                short indexNumber = 1;
                
				Version *versionObj = [[Version alloc]init];
                versionObj.playId = sqlite3_column_int(statement, indexNumber++);
                versionObj.versionId = sqlite3_column_int(statement, indexNumber++);
                
                versionObj.versionName = (value = (char *)sqlite3_column_text(statement, indexNumber++)) == NULL ? nil : [NSString stringWithUTF8String:value];
                
                 versionObj.htmlFileName = (value = (char *)sqlite3_column_text(statement, indexNumber++)) == NULL ? nil : [NSString stringWithUTF8String:value];
                
                 versionObj.audioName = (value = (char *)sqlite3_column_text(statement, indexNumber++)) == NULL ? nil : [NSString stringWithUTF8String:value];
                
                versionObj.notes = (value = (char *)sqlite3_column_text(statement, indexNumber++)) == NULL ? nil : [NSString stringWithUTF8String:value];
                
                versionObj.bookmark = sqlite3_column_int(statement, indexNumber++);
                
                [versionList addObject:versionObj];
			}
		}
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
    return versionList;
}

#pragma mark -
#pragma mark BOOKMARK Table Methods

- (NSArray*)SelectBookmarkDetail:(NSString *)query
{
    NSMutableArray *bookmarkObjectList=[[NSMutableArray alloc]init];
	if(sqlite3_open([databasePath UTF8String],&database) == SQLITE_OK)
	{
		const char *sql=[query UTF8String];
		sqlite3_stmt *statement;
		if(sqlite3_prepare_v2(database,sql,-1,&statement,NULL)==SQLITE_OK)
        {
			while (sqlite3_step(statement)==SQLITE_ROW)
			{
				Bookmark *bookmarkObj=[[Bookmark alloc]init];
				if(sqlite3_column_int64(statement,0))
					bookmarkObj._id=sqlite3_column_int64(statement,0);
                if(sqlite3_column_int64(statement,1))
					bookmarkObj.playId=sqlite3_column_int64(statement,1);
                if(sqlite3_column_int64(statement,2))
					bookmarkObj.versionNo=sqlite3_column_int64(statement,2);
                if(sqlite3_column_text(statement,3))
					bookmarkObj.playTitle=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,3)];
                if(sqlite3_column_text(statement,4))
					bookmarkObj.playAuthorName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,4)];
                if(sqlite3_column_text(statement,5))
					bookmarkObj.imageName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,5)];
                [bookmarkObjectList addObject:bookmarkObj];
			}
		}
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	return bookmarkObjectList;
}

- (BOOL)insertIntoBookMarkTable:(NSString*)query
{
    return [self executeQuery:query];
}

- (BOOL)deleteRowOfBookMarkTable:(NSString*)query
{
    return [self executeQuery:query];
}

#pragma mark -
#pragma mark HIGHLIGHTOBJECT Table Methods

- (NSArray*)SelectHighlightObjectDetail:(NSString *)query
{
	NSMutableArray *highlightObjectList=[[NSMutableArray alloc]init];
	if(sqlite3_open([databasePath UTF8String],&database) == SQLITE_OK)
	{
		const char *sql=[query UTF8String];
		sqlite3_stmt *statement;
		if(sqlite3_prepare_v2(database,sql,-1,&statement,NULL)==SQLITE_OK)
        {
			while (sqlite3_step(statement)==SQLITE_ROW)
			{
				HighlightObject *highLightObj=[[HighlightObject alloc]init];
				if(sqlite3_column_int64(statement,0))
					highLightObj._id=sqlite3_column_int64(statement,0);
                if(sqlite3_column_int64(statement,1))
					highLightObj.playId=sqlite3_column_int64(statement,1);
				if(sqlite3_column_text(statement,2))
					highLightObj.highlightId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)];
                if(sqlite3_column_text(statement,3))
					highLightObj.note=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,3)];
                if(sqlite3_column_int64(statement,4))
					highLightObj.versionNo=sqlite3_column_int64(statement,4);
                if(sqlite3_column_text(statement,5))
					highLightObj.selectedText=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,5)];
                if(sqlite3_column_text(statement,6))
					highLightObj.playAuthorName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,6)];
                if(sqlite3_column_text(statement,7))
					highLightObj.playTitle=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,7)];
                [highlightObjectList addObject:highLightObj];
			}
		}
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	return highlightObjectList;
}

- (HighlightObject *)selectHighlightText:(NSString*)query
{
	HighlightObject *highLightObj = [[HighlightObject alloc]init];
	if(sqlite3_open([databasePath UTF8String],&database) == SQLITE_OK)
	{
		const char *sql = [query UTF8String];
		sqlite3_stmt *statement;
		if(sqlite3_prepare_v2(database,sql,-1,&statement,NULL) == SQLITE_OK)
        {
			while (sqlite3_step(statement) == SQLITE_ROW)
			{
                if(sqlite3_column_int64(statement,0))
					highLightObj._id = sqlite3_column_int64(statement,0);
                if(sqlite3_column_int64(statement,1))
					highLightObj.playId = sqlite3_column_int64(statement,1);
				if(sqlite3_column_text(statement,2))
					highLightObj.highlightId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)];
                if(sqlite3_column_text(statement,3))
					highLightObj.note=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,3)];
                if(sqlite3_column_int64(statement,4))
					highLightObj.versionNo=sqlite3_column_int64(statement,4);
                if(sqlite3_column_text(statement,5))
					highLightObj.selectedText=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,5)];
                if(sqlite3_column_text(statement,6))
					highLightObj.playAuthorName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,6)];
                if(sqlite3_column_text(statement,7))
					highLightObj.playTitle=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,7)];
			}
		}
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	return highLightObj;
}

- (BOOL)saveOrDeleteNotes:(NSString *)query
{
    return [self executeQuery:query];
}

- (BOOL)updateNotesInfo:(NSString *)query
{
    return [self executeQuery:query];
}


// AUDIO Table Methods
- (void)addAudio:(Audio *)audio
{
    NSString *query_srt = [[NSString alloc] initWithFormat:@"insert into AUDIO (Play_Id,Ver_Id,Clip_Id,From_Time,To_Time,Audio_File_Name) values('%i','%i','%i','%i','%i','%@');", audio.playId, audio.versionId, audio.clipId, audio.fromTime, audio.toTime, audio.audioFileName];
    if([self executeQuery:query_srt])
        NSLog(@"AUDIO is Inserted...");
}

- (void)updeteAudio:(Audio *)audio withAudio:(Audio *)audio1
{
    int k = (audio1.selected) ? 1 : 0;
    NSString *query_srt = [[NSString alloc] initWithFormat:@"UPDATE AUDIO SET Selected='%i',Audio_File_Name='%@' WHERE Play_Id='%i' AND Ver_Id='%i' AND Clip_Id='%i';", k, audio1.audioFileName, audio.playId, audio.versionId, audio.clipId];
    if([self executeQuery:query_srt])
        NSLog(@"AUDIO is Updated...");
}

- (void)updeteAudioWherePlayId:(int)playId clipId:(int)clipId versionId:(int)verId withAudioFileName:(NSString*)audioFileName
{
    NSString *query_srt = [[NSString alloc] initWithFormat:@"UPDATE AUDIO set Audio_File_Name='%@' WHERE Play_Id='%i' AND Ver_Id='%i';", audioFileName,playId, verId];
    if([self executeQuery:query_srt])
        NSLog(@"AUDIO is Updated...");

}

- (Audio *)audioWithClipId:(NSInteger)clipId andVerId:(NSInteger)verId
                 andPlayId:(NSInteger)playId {
    
    Audio *audio = [[Audio alloc] init];
    
    if(sqlite3_open([databasePath UTF8String],&database) == SQLITE_OK) {
        
        NSString *query_srt = [[NSString alloc] initWithFormat:@"select * from AUDIO WHERE Play_Id='%i' AND Ver_Id='%i' AND Clip_Id='%i';",playId, verId, clipId];
        sqlite3_stmt *statement;
		
        if(sqlite3_prepare_v2(database, [query_srt UTF8String], -1,&statement, NULL) == SQLITE_OK) {
            char *value = NULL;
            short indexNumber;
			if(sqlite3_step(statement) == SQLITE_ROW) {
                indexNumber = 1;
                audio.playId = sqlite3_column_int(statement,indexNumber++);
                audio.versionId = sqlite3_column_int(statement,indexNumber++);
                audio.clipId = sqlite3_column_int(statement,indexNumber++);
                audio.fromTime = sqlite3_column_int(statement,indexNumber++);
                audio.toTime = sqlite3_column_int(statement,indexNumber++);
                audio.selected = (sqlite3_column_int(statement,indexNumber++) == 1);
                audio.audioFileName = (value = (char *)sqlite3_column_text(statement, indexNumber++)) == NULL ? nil: [NSString stringWithUTF8String:value];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(database);
    }
    return audio;
}

#pragma mark - Private Methods

- (BOOL)executeQuery:(NSString *)query {
    BOOL flag = NO;
    if(sqlite3_open([databasePath UTF8String],&database) == SQLITE_OK) {
        char *err1;
        flag = (sqlite3_exec(database,[query UTF8String],NULL,NULL,&err1) == SQLITE_OK);
		sqlite3_close(database);
    }
    return flag;
}
@end