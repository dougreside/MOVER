//
//  CircleView.m
//  CircleView
//
//  Created by RAVI DAS on 31/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#define degreesToRadians(x) (M_PI * x / 180.0)

#import "CircleView.h"
#import "RoundLoader.h"
int oldPercent;
@implementation CircleView
@synthesize radius;
@synthesize loader;
@synthesize percentageLbl;
static CircleView* _sharedView;

+ (CircleView *)sharedView {
	@synchronized(self) {
        if (_sharedView == nil) {
            _sharedView=[[self alloc] init];
        }
    }
    return _sharedView;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        CircleView *circle = [[[NSBundle mainBundle]loadNibNamed:@"CircleView" owner:self options:nil]objectAtIndex:0];
        //self.frame = circle.frame;
        [self addSubview:circle];
        loader.frame = circle.frame;
        loader.radius = 15;
        loader.widthOfRadius = 6;
    }
    return self;
}

-(void)setRadius:(CGFloat)radius1
{
    loader.radius = radius1;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CircleView *circle = [[[NSBundle mainBundle]loadNibNamed:@"CircleView" owner:self options:nil]objectAtIndex:0];
        self.frame = frame;
        circle.frame = self.bounds;
        [self addSubview:circle];
      
      
        // Initialization code
    }
    return self;
}
- (void)addLoaderView:(int)percentComplete
{
    if (percentComplete==oldPercent) return;

    float startAngle = degreesToRadians(oldPercent*3.6)-M_PI/2 ;
    float endAngle = degreesToRadians(percentComplete*3.6)-M_PI/2;
    percentageLbl.text = [NSString stringWithFormat:@"%d%",percentComplete];
    [loader startAnimation:startAngle endAngle:endAngle duration:1];
    oldPercent = percentComplete;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
