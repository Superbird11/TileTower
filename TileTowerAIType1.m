//
//  TileTowerAIType1.m
//  Tile Tower
//
//  Created by Louis Jacobowitz on 1/15/15.
//  Copyright (c) 2015 Louis Jacobowitz. All rights reserved.
//

#import "TileTowerAIType1.h"

@implementation TileTowerAIType1

- (NSArray*) calculateMoveForBoard: (NSMutableArray*) board
{
    /* Chooses a random tile to increment, and then take the highest-scoring move. */
    
    int x = arc4random() % 5;
    int y = arc4random() % 5;
    
    Tile *incrementTile = [[board objectAtIndex:x] objectAtIndex:y];
    
    int boardSketch[5][5];
    for(int i = 0; i < 5; i++)
        for(int j = 0; j < 5; j++)
            boardSketch[i][j] = ((Tile*)[[board objectAtIndex:i] objectAtIndex:j]).value;
    
    boardSketch[x][y] += 2;
    if(x > 0 && y > 0)
        boardSketch[x-1][y-1]++;
    if(x > 0 && y < 4)
        boardSketch[x-1][y+1]++;
    if(x < 4 && y > 0)
        boardSketch[x+1][y-1]++;
    if(x < 4 && y < 4)
        boardSketch[x+1][y+1]++;
    
    for(int i = 0; i < 5; i++)
        for(int j = 0; j < 5; j++)
            if(boardSketch[i][j] > 5){boardSketch[i][j] = 5;}
    
    int maxPointValue = 0;
    int maxX = 0;
    int maxY = 0;
    BOOL direction = false; // TRUE = horizontal (changing i), FALSE = vertical (changing j)
    
    for(int i = 0; i < 5; i++){
        for(int j = 0; j < 5; j++){
            if(j < 4)
            if(boardSketch[i][j+1] == boardSketch[i][j] && boardSketch[i][j] != 0){
                int points = 0; int k = j;
                while(k < 5 && boardSketch[i][k] == boardSketch[i][j]){
                    points += boardSketch[i][k];
                    k++;
                }
                if(points > maxPointValue || (points == maxPointValue && arc4random() % 100 > arc4random() % 75)){
                    maxX = i;
                    maxY = j;
                    maxPointValue = points;
                    direction = false;
                }
            }
            if(i < 4)
            if(boardSketch[i+1][j] == boardSketch[i][j] && boardSketch[i][j] != 0){
                int points = 0; int k = i;
                while(k < 5 && boardSketch[k][j] == boardSketch[k][j]){
                    points += boardSketch[k][j];
                    k++;
                }
                if(points > maxPointValue || (points == maxPointValue && arc4random() % 100 > arc4random() % 75)){
                    maxX = i;
                    maxY = j;
                    maxPointValue = points;
                    direction = true;
                }
            }
        }
    }
    
    NSMutableArray *returnArray = [[NSMutableArray alloc] initWithObjects: incrementTile,nil];
    
    if(maxPointValue != 0){
        int incrementX, incrementY;
        if(direction){incrementX = 1; incrementY = 0;}
        else{incrementX = 0; incrementY = 1;}
        
        int i = maxX, j = maxY;
        while(i < 5 && j < 5 && boardSketch[i][j] == boardSketch[maxX][maxY]){
            [returnArray addObject:[[board objectAtIndex:i] objectAtIndex:j]];
            i += incrementX; j += incrementY;
        }
    }
    
    if([returnArray count] == 2)
        [returnArray removeObjectAtIndex:1];
    
    NSArray* moveToDo = [[NSArray alloc] initWithArray:returnArray];
    return moveToDo;
}

@end
