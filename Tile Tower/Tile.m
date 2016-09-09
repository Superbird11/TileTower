//
//  Tile.m
//  Tile Tower
//
//  Created by Louis Jacobowitz on 1/12/15.
//  Copyright (c) 2015 Louis Jacobowitz. All rights reserved.
//

#import "Tile.h"

@implementation Tile

- (id) initWithX: (int) x andY: (int) y 
{
    self = [super initWithFrame: CGRectMake(60*x,60*y,60,60)];
    
    [self setBackgroundImage: [UIImage imageNamed: @"score0.png"] forState: UIControlStateNormal];
    [self setBackgroundImage: [self backgroundImageForState:UIControlStateNormal] forState: UIControlStateHighlighted];
    //image = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"score0.png"]];
    //[image setFrame: self.frame];
    //[self addSubview: image];
    //[self bringSubviewToFront:image];
    
    loadingOverlay = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,60,60)];
    [loadingOverlay setImage: [UIImage animatedImageNamed:@"highlight" duration:.7] ];
    
    _value = 0;
    _X = x;
    _Y = y;
    isHighlighted = NO;
    
    if(x == 2 && y == 2)
        [self increment:2];
    
    return self;
}

- (void) increment: (int) num
{
    _value += num;
    if(_value > 5)
        _value = 5;
    switch(_value){
        case 1:
            [self setBackgroundImage: [UIImage imageNamed: @"score1.png"] forState: UIControlStateNormal];
            break;
        case 2:
            [self setBackgroundImage: [UIImage imageNamed: @"score2.png"] forState: UIControlStateNormal];
            break;
        case 3:
            [self setBackgroundImage: [UIImage imageNamed: @"score3.png"] forState: UIControlStateNormal];
            break;
        case 4:
            [self setBackgroundImage: [UIImage imageNamed: @"score4.png"] forState: UIControlStateNormal];
            break;
        case 5:
            [self setBackgroundImage: [UIImage imageNamed: @"score5.png"] forState: UIControlStateNormal];
            break;
        default:
            [self setBackgroundImage: [UIImage imageNamed: @"score0.png"] forState: UIControlStateNormal];
            break;
    }
    [self setBackgroundImage: [self backgroundImageForState:UIControlStateNormal] forState: UIControlStateHighlighted];
    
    [loadingOverlay setImage:[UIImage animatedImageNamed:@"demolish" duration:.3]];
    [self addSubview:loadingOverlay];
    timer = [NSTimer scheduledTimerWithTimeInterval:.3 target:self selector:@selector(unhighlight) userInfo:nil repeats:NO];
}

- (void) highlight
{
    if(!isHighlighted){
        [self addSubview: loadingOverlay];
        [self bringSubviewToFront: loadingOverlay];
        isHighlighted = YES;
    }
}

- (void) unhighlight
{
    [loadingOverlay removeFromSuperview];
    isHighlighted = NO;
    [loadingOverlay setImage:[UIImage animatedImageNamed:@"highlight" duration:.7]];
}

- (BOOL) isHighlighted
{
    return isHighlighted;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
