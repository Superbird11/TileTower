//
//  Tile.h
//  Tile Tower
//
//  Created by Louis Jacobowitz on 1/12/15.
//  Copyright (c) 2015 Louis Jacobowitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Tile : UIButton
{
    UIImageView *loadingOverlay;
    bool isHighlighted;
    
    NSTimer *timer;
}

@property (nonatomic) int value;
@property (nonatomic) int X;
@property (nonatomic) int Y;

- (id) initWithX: (int) x andY: (int) y;

- (void) increment: (int) num;

- (void) highlight;

- (BOOL) isHighlighted;

- (void) unhighlight;

@end
