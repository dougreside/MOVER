//
//  scrollBaseView.m
//  BLTJ
//
//  Created by kiwitech on 26/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseScrollView.h"
#import "CustomView.h"
#import "Global.h"
#import "NoteView.h"
#import "DatabaseConnection.h"
#import "HighlightObject.h"
#import "MainWebControllerViewController.h"

@implementation BaseScrollView
@synthesize dataSourceArray;
@synthesize leftCustomView;
@synthesize currentCustomView;
@synthesize rightCustomView;
@synthesize mCurrentView;
@synthesize mPrevView;
@synthesize panRecognizer = _panRecognizer;
@synthesize webDelegate;
CGPoint startTouchPosition;
CGFloat mSwipeStart;

BOOL mSwiping;

CGPoint touchBegan;

- (void) panned:(UIPanGestureRecognizer *) recognizer
{
    switch (recognizer.state) {
        [webDelegate checkStatusOfBookmarkButton];
       
        case UIGestureRecognizerStateBegan: {
            [self.currentCustomView setHidden:NO];
            [[self leftCustomView] setHidden:NO];
            [[self rightCustomView] setHidden:NO];
            touchBegan = [recognizer locationInView:self];
        } break;
        
        case UIGestureRecognizerStateChanged: {
            if(currentCustomView.isPdfForDisplay==YES && currentCustomView.wantsToMovePDf==YES)
                return;
            float currentLoc = [recognizer locationInView:self].x - touchBegan.x;
            [self manageViewOnMove:currentLoc];
        } break;
            
        case UIGestureRecognizerStateFailed:{}break;
            
        case UIGestureRecognizerStateRecognized: {
            if(currentCustomView.isPdfForDisplay==YES && currentCustomView.wantsToMovePDf==YES)
                return;
            float xDiff = [recognizer locationInView:self].x - touchBegan.x;
            if(xDiff<=25.0)
                [self nextView:nil];
            else if(xDiff>=25.0)
                [self previousView:nil];
        } break;
            
        default:
            break;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

- (id)initWithFrame:(CGRect)frame andDataSource:(NSArray *)mutArray
       withDelegate:delegate isFromNBView:(BOOL)isT withCurrentVersionNO:(int)currentVNO
{
    self = [super initWithFrame:frame];
    if (self)
    {
        if(!isT)
        currentIndex = 1;
        [delegate checkStatusOfBookmarkButton];
        _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
        [_panRecognizer setDelegate:self];
        [self addGestureRecognizer:_panRecognizer];
        
        self.dataSourceArray = mutArray;
        NSInteger viewCounter = 1;
        mPrevView=-1;
        mCurrentView=1;
        NSArray *arrayForCurrentView=nil;
        NSArray *arrayForRightView=nil;
        
        NSArray *arrayForCurrenIndexes=nil;
        NSArray *arrayForRightIndexes=nil;
        int i=0;
        if([dataSourceArray count]>0)
        {
            NSMutableArray *tempArray= [[NSMutableArray alloc] init];
            NSMutableArray *tempIndexArray=[[NSMutableArray alloc] init];
            if (isT && currentVNO != 1) {
                for(i = 0; i < viewCounter; i++) {
                    if(i < [dataSourceArray count]) {
                        [tempArray addObject:[dataSourceArray objectAtIndex:currentVNO-2]];
                        [tempIndexArray addObject:[NSString stringWithFormat:@"%i",currentVNO-2]];
                        i = currentVNO-2;
                    } else {
                        break;
                    }
                }
            } else {
                for(i = 0; i < viewCounter; i++) {
                    if(i<[dataSourceArray count]) {
                        [tempArray addObject:[dataSourceArray objectAtIndex:i]];
                        [tempIndexArray addObject:[NSString stringWithFormat:@"%i",i]];
                    }
                    else{
                        break;
                    }
                }
                if (currentVNO==1) 
                    i = 0;
            }
            arrayForCurrentView=[NSArray arrayWithArray:tempArray];
            arrayForCurrenIndexes=[NSArray arrayWithArray:tempIndexArray];
        }
        if([dataSourceArray count] > i) {
            NSMutableArray *tempArray1= [[NSMutableArray alloc] init];
            NSMutableArray *tempIndexArray1=[[NSMutableArray alloc] init];
            for(int j = 0; j < viewCounter; j++) {
                NSInteger index=i+j;
                if(index < [dataSourceArray count]) {
                    [tempArray1 addObject:[dataSourceArray objectAtIndex:index]];
                    [tempIndexArray1 addObject:[NSString stringWithFormat:@"%i",(i+j)]];
                    
                } else {
                    break;
                }
            }
            arrayForRightView = [NSArray arrayWithArray:tempArray1];
            arrayForRightIndexes = [NSArray arrayWithArray:tempIndexArray1];
        }
        if(arrayForCurrentView)
            self.currentCustomView = [[CustomView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 370) forViews:arrayForCurrentView forIndexes:arrayForCurrenIndexes forDelegate:delegate];
        if(arrayForRightView)
            self.rightCustomView = [[CustomView alloc] initWithFrame:CGRectMake(300, 0, self.frame.size.width, 370) forViews:arrayForRightView forIndexes:arrayForRightIndexes forDelegate:delegate];
        [self addSubview:currentCustomView];
        [self addSubview:rightCustomView];
    }
    self.rightCustomView.hidden = YES;
    [delegate performSelector:@selector(fontchange) withObject:nil afterDelay:.5];
    return self;
}


- (void)manageViewOnMove:(CGFloat)swipeDistance
{
    if(swipeDistance * swipeDistance < 50.0) return;
	CGSize contentSize = self.frame.size;
	self.leftCustomView.frame = CGRectMake(swipeDistance - contentSize.width , 0.0f, contentSize.width, contentSize.height);
	self.currentCustomView.frame = CGRectMake(swipeDistance, 0.0f, contentSize.width, contentSize.height);
	self.rightCustomView.frame = CGRectMake(swipeDistance + contentSize.width, 0.0f, contentSize.width, contentSize.height);
}

- (void)enableInteraction
{
    [self setUserInteractionEnabled:YES];
}

- (CustomView *)createView:(NSInteger)inImageIndex
{
    if (inImageIndex >= [dataSourceArray count])
		return nil;
    NSInteger viewCounter=1;
    NSMutableArray *viewsMutArray=[[NSMutableArray alloc] init];
    NSMutableArray *indexArray=[[NSMutableArray alloc] init];
    for(int i=0;i<viewCounter;i++)
    {
        if((i+inImageIndex)<[dataSourceArray count])
        {
            [viewsMutArray addObject:[dataSourceArray objectAtIndex:(inImageIndex+i)]];
            [indexArray addObject:[NSString stringWithFormat:@"%i",(inImageIndex+i)]];
        }
        else
        {
            break;
        }
    }
    NSArray *viewsArray=[NSArray arrayWithArray:viewsMutArray];
    NSArray *tagsArray=[NSArray arrayWithArray:indexArray];
	CustomView * thumb_imageView = [[CustomView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, heightForScroller) forViews:viewsArray forIndexes:tagsArray forDelegate:webDelegate];
    [webDelegate checkStatusOfBookmarkButton];
    
	return thumb_imageView;
}


-(void)previousView:(id)sender
{
    [webDelegate onAudioCancelButtonClicked:nil];
    [self.currentCustomView setHidden:NO];
    [self.leftCustomView setHidden:NO];
    [self.rightCustomView setHidden:NO];
    CGSize contentSize = self.frame.size;
    if (mCurrentView > 0 && mPrevView>=0)
    {
        currentIndex--;
        [webDelegate checkStatusOfBookmarkButton];
        [self.rightCustomView removeFromSuperview];
        self.rightCustomView = self.currentCustomView;
        self.currentCustomView = self.leftCustomView;
        NSInteger viewCounter=1;
        mCurrentView=mCurrentView-viewCounter;
        mPrevView=mPrevView-viewCounter;
        if (mCurrentView > 0 && mPrevView>=0)
        {
            self.leftCustomView = [self createView:mPrevView];
            self.leftCustomView.hidden = YES;
            [self addSubview:self.leftCustomView];
        }
        else
        {
            self.leftCustomView = nil;
        }
    }
    [self performSelector:@selector(hideViews) withObject:nil afterDelay:.3];
    [UIView beginAnimations:@"swipe" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.3f];
    self.leftCustomView.frame = CGRectMake(-contentSize.width, 0.0f, contentSize.width, contentSize.height);
    self.currentCustomView.frame = CGRectMake(0.0f, 0.0f, contentSize.width, contentSize.height);
    self.rightCustomView.frame = CGRectMake(contentSize.width, 0.0f, contentSize.width, contentSize.height);
    [UIView commitAnimations];
    NSString* title=[webDelegate.currentPlayTitle stringByAppendingFormat:@" : %@",[self getVersionName:[webDelegate.verArray objectAtIndex:currentIndex-1]]];
    webDelegate.versionLabel.text=title;
    [webDelegate performSelector:@selector(fontchange) withObject:nil afterDelay:0.5];
}

-(void)nextView:(id)sender
{
    [webDelegate onAudioCancelButtonClicked:nil];
    [self.currentCustomView setHidden:NO];
    [self.leftCustomView setHidden:NO];
    [self.rightCustomView setHidden:NO];
    CGSize contentSize = self.frame.size;
    NSUInteger count = [dataSourceArray count];
    
    if (mCurrentView < count )
    {
        currentIndex++;
        [webDelegate checkStatusOfBookmarkButton];
        [leftCustomView removeFromSuperview];
        self.leftCustomView = self.currentCustomView;
        self.currentCustomView = self.rightCustomView;
        NSInteger viewCounter=1;
        mCurrentView=mCurrentView+viewCounter;
        mPrevView=mPrevView+viewCounter;
        if (mCurrentView < count )
        {
            self.rightCustomView = [self createView:mCurrentView];
            self.rightCustomView.hidden = YES;
            [self addSubview:self.rightCustomView];
        }
        else
        {
            self.rightCustomView = nil;
        }
    }
    [self performSelector:@selector(hideViews) withObject:nil afterDelay:.3];
    [UIView beginAnimations:@"swipe" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.3f];
    self.leftCustomView.frame = CGRectMake(-contentSize.width, 0.0f, contentSize.width, contentSize.height);
    self.currentCustomView.frame = CGRectMake(0.0f, 0.0f, contentSize.width, contentSize.height);
    self.rightCustomView.frame = CGRectMake(contentSize.width, 0.0f, contentSize.width, contentSize.height);
    [UIView commitAnimations];
    NSString* title=[webDelegate.currentPlayTitle stringByAppendingFormat:@" : %@",[self getVersionName:[webDelegate.verArray objectAtIndex:currentIndex-1]]];
    webDelegate.versionLabel.text=title;
    [webDelegate performSelector:@selector(fontchange) withObject:nil afterDelay:0.5];
}

-(void)jumpToView:(NSInteger)pageNo
{
    mCurrentView=pageNo;
    mPrevView=pageNo-1;
    currentIndex=pageNo;
    [self.currentCustomView setHidden:NO];
    [self.leftCustomView setHidden:NO];
    [self.rightCustomView setHidden:NO];
    CGSize contentSize = self.frame.size;
    NSUInteger count = [dataSourceArray count];
    if (mCurrentView <= count )
    {
        [webDelegate checkStatusOfBookmarkButton];
        [leftCustomView removeFromSuperview];
        self.leftCustomView = self.currentCustomView;
        self.currentCustomView = self.rightCustomView;
        
        if (mCurrentView < count )
        {
            self.rightCustomView = [self createView:mCurrentView];
            self.rightCustomView.hidden = YES;
            if (pageNo==1) 
                [leftCustomView removeFromSuperview];
            [self addSubview:self.rightCustomView];
        }
        else
        {
            self.rightCustomView = nil;
        }
    }
    [self performSelector:@selector(hideViews) withObject:nil afterDelay:.3];
    self.leftCustomView.frame = CGRectMake(-contentSize.width, 0.0f, contentSize.width, contentSize.height);
    self.currentCustomView.frame = CGRectMake(0.0f, 0.0f, contentSize.width, contentSize.height);
    self.rightCustomView.frame = CGRectMake(contentSize.width, 0.0f, contentSize.width, contentSize.height);
}


-(void)hideViews
{
    self.leftCustomView.hidden=YES;
    self.rightCustomView.hidden=YES;
}

- (NSString*)getVersionName:(NSString*)verValue
{
    return verValue;
}
@end
