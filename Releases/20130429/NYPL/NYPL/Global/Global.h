//
//  Global.h
//  MuslimCare
//
//  Created by kiwitech on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
// SR229197926


#define NSLog if(0)NSLog
#define ENSLog(classPointer, functionPointer) NSLog(@"%@ -> Enter -> %@",[classPointer class], NSStringFromSelector(functionPointer));
#define ExNSLog(classPointer, functionPointer) NSLog(@"%@ -> Exit -> %@",[classPointer class], NSStringFromSelector(functionPointer));

typedef enum
{
    RootTabSelected = 0,
	PlayTabSelected,
    AnnotateTabSelected,
	BookmarkTabSelected,
	AboutUsTabSelected,
    
} HighlightedTab;

typedef enum
{
	btnIndex = 0,
	btnContent,
	btnImages,
	btnResources,
	btnTables,
	btnNews,
	btnFav,
	btnUpdates
} buttonTags;

int currentIndex;
int currentFontSize;

#define FONT_TAHOMA_REGULAR(s) [UIFont fontWithName:@"extra" size:s]
#define FONT_TAHOMA_BOLD(s) [UIFont fontWithName:@"tahoma" size:s];

// Added By Prakash.
#define kColor(_r_, _g_, _b_, _a_) [UIColor colorWithRed:_r_/255.0 green:_g_/255.0 blue:_b_/255.0 alpha:_a_]

