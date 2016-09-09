//
//  TileTowerAI.h
//  Tile Tower
//
//  Created by Louis Jacobowitz on 1/15/15.
//  Copyright (c) 2015 Louis Jacobowitz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tile.h"

@interface TileTowerAI : NSObject

struct moveOption
{
    int placeX;
    int placeY;
    int moveX;
    int moveY;
    bool direction;
    int pointValue;
};
typedef struct moveOption moveOption;

- (NSArray*) calculateMoveForBoard: (NSMutableArray*) board;

- (id) valueWithMoveOption: (moveOption) opt;

- (moveOption) moveOptionOf: (NSValue*) val;


@end
