//
//  scrollBaseView.h
//  BLTJ
//
//  Created by kiwitech on 26/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define numberOfViewsOnScreen 1
#define numberOfViewsOnScreenPortrait 1
#define heightForScroller 370

@class CustomView;
@class NoteView;
@class MainWebControllerViewController;

@interface BaseScrollView : UIView
<UIWebViewDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate>
{
    float currentcontentOffsetX;
    NoteView* addNotesView;
}

@property (nonatomic, retain) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, retain) CustomView *leftCustomView;
@property (nonatomic, retain) CustomView *currentCustomView;
@property (nonatomic, retain) CustomView *rightCustomView;
@property (nonatomic, retain) NSArray *dataSourceArray;
@property (nonatomic, assign) NSInteger mCurrentView;
@property (nonatomic, assign) NSInteger mPrevView;
@property (nonatomic, retain) MainWebControllerViewController *webDelegate;

- (CustomView *)createView:(NSInteger)inImageIndex;
- (id)initWithFrame:(CGRect)frame andDataSource:(NSArray *)mutArray
       withDelegate:delegate isFromNBView:(BOOL)isT withCurrentVersionNO:(int)currentVNO;
- (void)previousView:(id)sender;
- (void)nextView:(id)sender;
- (void)manageViewOnMove:(CGFloat)swipeDistance;
- (void)hideViews;
- (void)jumpToView:(NSInteger)pageNo;
- (NSString*)getVersionName:(NSString*)verValue;
@end

