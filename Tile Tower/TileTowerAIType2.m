//
//  TileTowerAIType2.m
//  Tile Tower
//
//  Created by Louis Jacobowitz on 1/16/15.
//  Copyright (c) 2015 Louis Jacobowitz. All rights reserved.
//

#import "TileTowerAIType2.h"



@implementation TileTowerAIType2



- (NSArray*) calculateMoveForBoard: (NSMutableArray*) board
{
    int boardSketch[5][5];
    moveOption defaultMove;
    defaultMove.moveX = 0;
    defaultMove.moveY = 0;
    defaultMove.direction = false;
    defaultMove.placeX = 0;
    defaultMove.placeY = 0;
    defaultMove.pointValue = 0;
    NSMutableArray *moveOptions = [[NSMutableArray alloc] initWithObjects: [super valueWithMoveOption:defaultMove],nil];
    
    for(int i = 0; i < 5; i++){
        for(int j = 0; j < 5; j++){
            for(int a = 0; a < 5; a++)
                for(int b = 0; b < 5; b++)
                    boardSketch[a][b] = ((Tile*)[[board objectAtIndex:a] objectAtIndex:b]).value;
            
            boardSketch[i][j] += 2;
            if(boardSketch[i][j] > 5) boardSketch[i][j] = 5;
            if(i > 0 && j > 0)
                if(boardSketch[i-1][j-1] < 5)
                    boardSketch[i-1][j-1]++;
            if(i > 0 && j < 4)
                if(boardSketch[i-1][j+1] < 5)
                    boardSketch[i-1][j+1]++;
            if(i < 4 && j > 0)
                if(boardSketch[i+1][j-1] < 5)
                    boardSketch[i+1][j-1]++;
            if(i < 4 && j < 4)
                if(boardSketch[i+1][j+1] < 5)
                    boardSketch[i+1][j+1]++;
            //The board sketch has been made. Now to find the highest-point move on it.
            for(int a = 0; a < 5; a++){
                for(int b = 0; b < 5; b++){
                    if(a+1 < 5){
                        if(boardSketch[a+1][b] == boardSketch[a][b]){
                            int tempPointValue = 0;
                            int k = 1;
                            while(a+k < 5 && boardSketch[a+k][b] == boardSketch[a][b] && boardSketch[a][b] != 0){
                                tempPointValue += boardSketch[a+k][b];
                                k++;
                            }
                            if(tempPointValue > [super moveOptionOf:[moveOptions objectAtIndex:0]].pointValue){
                                [moveOptions removeAllObjects];
                                moveOption move;
                                move.placeX = i;
                                move.placeY = j;
                                move.moveX = a;
                                move.moveY = b;
                                move.direction=true;
                                move.pointValue = tempPointValue;
                                [moveOptions addObject:[super valueWithMoveOption:move]];
                            }
                            else if(tempPointValue == [super moveOptionOf:[moveOptions objectAtIndex:0]].pointValue){
                                moveOption move;
                                move.placeX = i;
                                move.placeY = j;
                                move.moveX = a;
                                move.moveY = b;
                                move.direction=true;
                                move.pointValue = tempPointValue;
                                [moveOptions addObject:[super valueWithMoveOption:move]];
                            }
                        }
                    }
                    if(b+1 < 5){
                        if(boardSketch[a][b+1] == boardSketch[a][b]){
                            int tempPointValue = 0;
                            int k = 1;
                            while(b+k < 5 && boardSketch[a][b+k] == boardSketch[a][b] && boardSketch[a][b] != 0){
                                tempPointValue += boardSketch[a][b+k];
                                k++;
                            }
                            if(tempPointValue > [super moveOptionOf:[moveOptions objectAtIndex:0]].pointValue){
                                [moveOptions removeAllObjects];
                                moveOption move;
                                move.placeX = i;
                                move.placeY = j;
                                move.moveX = a;
                                move.moveY = b;
                                move.direction=false;
                                move.pointValue = tempPointValue;
                                [moveOptions addObject:[super valueWithMoveOption:move]];
                            }
                            else if(tempPointValue == [super moveOptionOf:[moveOptions objectAtIndex:0]].pointValue){
                                moveOption move;
                                move.placeX = i;
                                move.placeY = j;
                                move.moveX = a;
                                move.moveY = b;
                                move.direction=false;
                                move.pointValue = tempPointValue;
                                [moveOptions addObject:[super valueWithMoveOption:move]];
                            }
                        }
                    }
                }
            }
        }
    }
    moveOption incrementMove = [super moveOptionOf:[moveOptions objectAtIndex:arc4random()%[moveOptions count]]];
    
    for(int a = 0; a < 5; a++)
        for(int b = 0; b < 5; b++)
            boardSketch[a][b] = ((Tile*)[[board objectAtIndex:a] objectAtIndex:b]).value;
    boardSketch[incrementMove.placeX][incrementMove.placeY] += 2;
    if(boardSketch[incrementMove.placeX][incrementMove.placeY] > 5)
        boardSketch[incrementMove.placeX][incrementMove.placeY] = 5;
    if(incrementMove.placeX > 0 && incrementMove.placeY > 0)
        if(boardSketch[incrementMove.placeX-1][incrementMove.placeY-1] < 5)
            boardSketch[incrementMove.placeX-1][incrementMove.placeY-1]++;
    if(incrementMove.placeX > 0 && incrementMove.placeY < 4)
        if(boardSketch[incrementMove.placeX-1][incrementMove.placeY+1] < 5)
            boardSketch[incrementMove.placeX-1][incrementMove.placeY+1]++;
    if(incrementMove.placeX < 4 && incrementMove.placeY > 0)
        if(boardSketch[incrementMove.placeX+1][incrementMove.placeY-1] < 5)
            boardSketch[incrementMove.placeX+1][incrementMove.placeY-1]++;
    if(incrementMove.placeX < 4 && incrementMove.placeY < 4)
        if(boardSketch[incrementMove.placeX+1][incrementMove.placeY+1] < 5)
            boardSketch[incrementMove.placeX+1][incrementMove.placeY+1]++;

    
    
    Tile *tileToIncrement = [[board objectAtIndex:incrementMove.placeX] objectAtIndex:incrementMove.placeY];
    NSMutableArray *returner = [[NSMutableArray alloc] initWithObjects:tileToIncrement,nil];
    if(incrementMove.direction){
        for(int i = incrementMove.moveX; boardSketch[i][incrementMove.moveY] == boardSketch[incrementMove.moveX][incrementMove.moveY] && i < 5; i++){
            [returner addObject:[[board objectAtIndex:i] objectAtIndex:incrementMove.moveY]];
        }
    }
    else{
        for(int i = incrementMove.moveY; boardSketch[incrementMove.moveX][i] == boardSketch[incrementMove.moveX][incrementMove.moveY] && i < 5; i++){
            [returner addObject:[[board objectAtIndex:incrementMove.moveX] objectAtIndex:i]];
        }
    }
    
    return returner;
}

@end
