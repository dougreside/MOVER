//
//  AnimateViews.h
//  Elsevier
//
//  Created by Tarun on 12/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

typedef enum
 {
	BounceViewAnimationType = 0,
	BounceViewRevertAnimationType,
	RevealViewAnimationType,
	PushViewAnimationType,
	PushViewRevertAnimationType,
	RippleViewRevertAnimationType,
	ShakeViewRevertAnimationType,
	ZoomViewAnimationType,
	CubeAnimationType, 
	FlipAnimationType
}AnimationType;

typedef enum 
{
	NoneAnimationSubType = 0,
	FromLeftDirection,
	FromRightDirection,
	FromUpDirection,
	FromDownDirection
}AnimationSubType;

@interface AnimateViews : NSObject
@property (nonatomic, retain) UIView* animatedView;
@property (nonatomic, assign) AnimationType animationType;
@property (nonatomic, retain) NSString* animationSubType;
@property (nonatomic, assign) CGRect animationStartingFrame;
@property (nonatomic, assign) BOOL isForRemovingView;
@property (copy) void (^callbackFunction)();
@property (nonatomic,assign) id callerDelegate;
+ (AnimateViews*) allocate;
+ (void) deAllocate;

- (void) startAnimationOnview:(UIView*)fromView toView:(UIView*)toView animationType:(AnimationType)animateType animationSubType:(NSString*)animateSubType; 

- (void) startBounceViewAnimation;
- (void) startBounceViewRevertAnimation;
- (void) startRevealViewAnimation;
- (void) startPushViewAnimation;
- (void) startPushViewRevertAnimation;
- (void) startRippleViewAnimation;
- (void) startShakeViewAnimation;
- (void) startZoomViewAnimation;
- (void) startCubeAnimation;

- (void) moveViewOnY: (UIView *) moving toPosition: (NSNumber *) position;
- (void) moveViewOnX: (UIView *) moving toPosition: (NSNumber *) position;
- (void) bounce1AnimationStopped;
- (void) bounce2AnimationStopped;
- (void) onStoppingAnimation;
- (void) startFlipViewAnimation;

- (CABasicAnimation *) createBasicAnimationWithKeyPath: (NSString *) keyPath andPosition: (NSNumber *) position;
- (CABasicAnimation *) createSimpleRotationAnimation;
- (CABasicAnimation *) createSimpleScaleAnimation;
@end


@interface UIView (I7ShakeAnimation)

/*!
 @abstract			Performes a easy X axis shake
 @result			
 @discussion		
 */
- (void)shakeX;

/*!
 @abstract			Performes a customized X axis shake
 @result			
 @discussion		You can give a special offset (the amount of pixel to break out) and the breakfactor (which must be < 1). A animation duration is also possible
 */
- (void)shakeXWithOffset:(CGFloat)aOffset breakFactor:(CGFloat)aBreakFactor duration:(CGFloat)aDuration maxShakes:(NSInteger)maxShakes;

@end
