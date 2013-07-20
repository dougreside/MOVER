//
//  AnimateViews.m
//  Elsevier
//
//  Created by Tarun on 12/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AnimateViews.h"
#import "Global.h"

static AnimateViews* classObject = nil;

@implementation AnimateViews
@synthesize animatedView, animationType, animationSubType, animationStartingFrame, callbackFunction, isForRemovingView;
@synthesize callerDelegate;

+ (AnimateViews*) allocate 
{
	@synchronized(self)
    {
		if(!classObject)
        {
			classObject = [[AnimateViews alloc]init];
			classObject.callbackFunction = NULL;
		}
	}
	return classObject;
}


+ (void) deAllocate
{
	@synchronized(self)
    {
		//RELEASE(classObject);
	}
}

- (void)startAnimationOnview:(UIView*)fromView toView:(UIView*)toView animationType:(AnimationType)animateType animationSubType:(NSString*)animateSubType 
{
	self.animationType = animateType;
	self.animationSubType = animateSubType;
	self.animatedView = fromView;
	switch (self.animationType)
    {
		case BounceViewAnimationType:
			[self startBounceViewAnimation];
			break;
		case BounceViewRevertAnimationType:
			[self startBounceViewRevertAnimation];
			break;
		case RevealViewAnimationType:
			[self startRevealViewAnimation];
			break;
		case PushViewAnimationType:
			[self startPushViewAnimation];
			break;
		case PushViewRevertAnimationType:
			[self startPushViewRevertAnimation];
			break;
		case RippleViewRevertAnimationType:
			[self startRippleViewAnimation];
			break;
		case ShakeViewRevertAnimationType:
			[self startShakeViewAnimation];
			break;
		case ZoomViewAnimationType:
			[self startZoomViewAnimation];
			break;
		case CubeAnimationType:
			[self startCubeAnimation];
		case FlipAnimationType:
			[self startFlipViewAnimation];
	}
}




- (void) bounce1AnimationStopped
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
	self.animatedView.transform = CGAffineTransformMakeScale(0.98, 0.98);
	[UIView commitAnimations];
}

- (void) bounce2AnimationStopped
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(onStoppingAnimation)];
	self.animatedView.transform = CGAffineTransformIdentity;
	[UIView commitAnimations];
}


#pragma mark -
#pragma mark StartAnimation
- (void) startBounceViewAnimation
{
	self.animatedView.transform = CGAffineTransformMakeScale(0.001, 0.001);
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
	self.animatedView.transform = CGAffineTransformMakeScale(1.1, 1.1);
	[UIView commitAnimations];	
}

- (void) startFlipViewAnimation
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
	if(self.animationSubType == kCATransitionFromLeft)
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.animatedView cache:YES];
	else if(self.animationSubType == kCATransitionFromRight)
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.animatedView cache:YES];
	[UIView commitAnimations];	
}

- (void) startZoomViewAnimation
{
	self.animatedView.transform = CGAffineTransformMakeScale(0.001, 0.001);
	CGPoint initialPoint = self.animatedView.layer.position;
	self.animatedView.layer.position = CGPointMake(self.animatedView.layer.position.x, self.animatedView.frame.size.height);
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.8];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(onStoppingAnimation)];
	self.animatedView.transform = CGAffineTransformIdentity;
	self.animatedView.layer.position = initialPoint;
	[UIView commitAnimations];	
}

- (void) startCubeAnimation
{
	CATransition* trans = [CATransition animation];
	trans.type = @"cube";
	trans.subtype = self.animationSubType;
	trans.duration = 2.0;
	trans.removedOnCompletion = YES;
	trans.delegate = self;
	[self.animatedView.layer addAnimation:trans forKey:nil];
}


- (void) startBounceViewRevertAnimation
{	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(onStoppingAnimation)];
	self.animatedView.transform = CGAffineTransformMakeScale(0.001, 0.001);
	[UIView commitAnimations];	
	if([self.animationSubType caseInsensitiveCompare:@"withRotation"] == NSOrderedSame)
		[[self.animatedView layer] addAnimation:[self createSimpleRotationAnimation] forKey:@"move along x"];
}

- (void) startRevealViewAnimation
{
	CATransition* animation = [CATransition animation];
	animation.duration = 0.6;
	animation.type = kCATransitionReveal;
	animation.subtype = self.animationSubType;
	animation.removedOnCompletion = YES;
	[self.animatedView.layer addAnimation:animation forKey:nil];
}

- (void) startPushViewAnimation
{
	CATransition* animation = [CATransition animation];
	animation.duration = 0.4;
	animation.delegate = self;
	animation.type = kCATransitionPush;
	animation.subtype = self.animationSubType;
	animation.removedOnCompletion = YES;
	[self.animatedView.layer addAnimation:animation forKey:nil];
}

- (void) startPushViewRevertAnimation{}

- (void) startRippleViewAnimation 
{
	CATransition* animation = [CATransition animation];
	animation.duration = 2.0;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.removedOnCompletion = YES;
	animation.type = @"rippleEffect";
	animation.subtype = kCATransitionFromBottom;
	[self.animatedView.layer addAnimation:animation forKey:@"animation"];
}

- (void) startShakeViewAnimation
{
	[self.animatedView shakeX];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
	[self onStoppingAnimation];
}

- (void) onStoppingAnimation
{
	int switchvalue=self.animationType;
	switch (switchvalue)
    {
		case BounceViewAnimationType:
		{
			self.animatedView.transform = CGAffineTransformIdentity;
			if(self.isForRemovingView)
            {
				[self.animatedView removeFromSuperview];
			}
//            if ([callerDelegate performSelector:@selector(resetViewAfterAnimation) withObject:nil])
//                [callerDelegate resetViewAfterAnimation];
			if(self.callbackFunction != NULL)
            {
				self.callbackFunction();
				self.callbackFunction = NULL;
			}
			//RELEASE(classObject);
		}
        break;
		case BounceViewRevertAnimationType:
		{
			self.animatedView.transform = CGAffineTransformIdentity;
			if(self.isForRemovingView)
            {
				[self.animatedView removeFromSuperview];
			}
			if(self.callbackFunction != NULL)
            {
				self.callbackFunction();
				self.callbackFunction = NULL;
			}
			//RELEASE(classObject);
		}
        break;
		case PushViewAnimationType:
		{
			self.animatedView.transform = CGAffineTransformIdentity;
			if(self.isForRemovingView)
            {
				[self.animatedView removeFromSuperview];
			}
			if(self.callbackFunction != NULL)
            {
				self.callbackFunction();
				self.callbackFunction = NULL;
			}
			//RELEASE(classObject);
		}
        break;
		case ShakeViewRevertAnimationType:
		{
			if(self.isForRemovingView)
			if(self.callbackFunction != NULL)
            {
				self.callbackFunction();
				self.callbackFunction = NULL;
			}
			//RELEASE(classObject);
		}
        break;
		case ZoomViewAnimationType:
		{
			self.animatedView.transform = CGAffineTransformIdentity;
			if(self.isForRemovingView)
			if(self.callbackFunction != NULL)
            {
				self.callbackFunction();
				self.callbackFunction = NULL;
			}
			//RELEASE(classObject);
		}
        break;
		case CubeAnimationType:
		{
			if(self.isForRemovingView)
            if(self.callbackFunction != NULL)
            {
				self.callbackFunction();
				self.callbackFunction = NULL;
			}
			//RELEASE(classObject);
		}
        break;
		case FlipAnimationType:
		{
			if(self.isForRemovingView)
            if(self.callbackFunction != NULL)
            {
				self.callbackFunction();
				self.callbackFunction = NULL;
			}
			//RELEASE(classObject);
		}
        break;
	}
}


- (void) moveViewOnY: (UIView *) moving toPosition: (NSNumber *) position
{
    
    CABasicAnimation *move = [self createBasicAnimationWithKeyPath:@"transform.translation.y" 
                                                       andPosition:position];
    [[moving layer] addAnimation:move forKey:@"move along y"];
}

- (void) moveViewOnX: (UIView *) moving toPosition: (NSNumber *) position
{  
    CABasicAnimation *move = [self createBasicAnimationWithKeyPath:@"transform.translation.x" 
                                                       andPosition:position];
    [[moving layer] addAnimation:move forKey:@"move along x"];
}

- (CABasicAnimation *) createBasicAnimationWithKeyPath: (NSString *) keyPath andPosition: (NSNumber *) position
{
    CABasicAnimation *move = [CABasicAnimation animationWithKeyPath:keyPath];
    [move setFromValue:[NSNumber numberWithFloat:-2.0f]];
    [move setToValue:position];
    [move setRemovedOnCompletion:NO];
    [move setFillMode:kCAFillModeForwards];
    [move setDuration:0.2];
    [move setAutoreverses:YES];
    return move;
}

- (CABasicAnimation *) createSimpleRotationAnimation 
{
    CABasicAnimation *fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [fullRotation setFromValue:[NSNumber numberWithFloat:0]];
    [fullRotation setToValue:[NSNumber numberWithFloat:((360*M_PI)/180)]];
    [fullRotation setDuration:0.5f];
    return fullRotation;
}

- (CABasicAnimation *) createSimpleScaleAnimation
{
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [scale setToValue:[NSNumber numberWithFloat:10.0f]];
    [scale setDuration:1.0f];
    return scale;
}


//- (void)dealloc 
//{
//	self.callbackFunction = NULL;
//	RELEASE(animatedView);
//	RELEASE(animationSubType);
//	[super dealloc];
//}
@end

@implementation UIView (I7ShakeAnimation)

- (void)shakeX
{
	[self shakeXWithOffset:40.0 breakFactor:0.85 duration:1.5 maxShakes:30];
}

- (void)shakeXWithOffset:(CGFloat)aOffset breakFactor:(CGFloat)aBreakFactor duration:(CGFloat)aDuration maxShakes:(NSInteger)maxShakes 
{
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	[animation setDuration:aDuration];
	[animation setDelegate:self];
	
	NSMutableArray *keys = [NSMutableArray arrayWithCapacity:20];
	int infinitySec = maxShakes;
	while(aOffset > 0.01)
    {
		[keys addObject:[NSValue valueWithCGPoint:CGPointMake(self.center.x - aOffset, self.center.y)]];
		aOffset *= aBreakFactor;
		[keys addObject:[NSValue valueWithCGPoint:CGPointMake(self.center.x + aOffset, self.center.y)]];
		aOffset *= aBreakFactor;
		infinitySec--;
		if(infinitySec <= 0) 
        {
			break;
		}
	}
	animation.values = keys;	
	[self.layer addAnimation:animation forKey:@"position"];
}

@end
