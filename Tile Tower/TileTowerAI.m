//
//  TileTowerAI.m
//  Tile Tower
//
//  Created by Louis Jacobowitz on 1/15/15.
//  Copyright (c) 2015 Louis Jacobowitz. All rights reserved.
//

#import "TileTowerAI.h"

@implementation TileTowerAI

- (NSArray*) calculateMoveForBoard: (NSMutableArray*) board
{
    NSArray* moves = [[NSArray alloc] init];
    //First item: tile to change. Further items: tile to take
    
    return moves;
    //Postcondition: moves has at least one item
    //If it doesn't have at least three, it passes the second part of its turn
}

- (id) valueWithMoveOption: (moveOption) opt
{
    return [NSValue value:&opt withObjCType:@encode(moveOption)];
}

- (moveOption) moveOptionOf: (NSValue*) val
{
    moveOption opt;
    [val getValue:&opt];
    return opt;
}

@end
