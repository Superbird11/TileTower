//
//  TileTowerAIType3.m
//  Tile Tower
//
//  Created by Louis Jacobowitz on 1/16/15.
//  Copyright (c) 2015 Louis Jacobowitz. All rights reserved.
//

#import "TileTowerAIType3.h"

@implementation TileTowerAIType3

- (NSMutableArray*) sortByPointValue: (NSMutableArray*) array
{
    //QuickSort can go screw itself.
    //This is a bubble sort. Because to hell with efficiency.
    //TODO: update. Bubble sort is too inefficient. Try gnomeSort or 
    for(int i = 0; i < [array count]; i++){
        for(int j = i+1; j < [array count]; j++){
            if([super moveOptionOf:[array objectAtIndex:j]].pointValue > [super moveOptionOf:[array objectAtIndex:i]].pointValue){
                id temp = [array objectAtIndex:j];
                [array replaceObjectAtIndex:j withObject:[array objectAtIndex:i]];
                [array replaceObjectAtIndex:i withObject:temp];
            }
            else if([super moveOptionOf:[array objectAtIndex:j]].pointValue == [super moveOptionOf:[array objectAtIndex:i]].pointValue){
                if(((Tile*)[[theBoard objectAtIndex: [super moveOptionOf:[array objectAtIndex:j]].moveX] objectAtIndex: [super moveOptionOf:[array objectAtIndex:j]].moveY]).value > ((Tile*)[[theBoard objectAtIndex: [super moveOptionOf:[array objectAtIndex:i]].moveX] objectAtIndex: [super moveOptionOf:[array objectAtIndex:i]].moveY]).value){
                    
                    id temp = [array objectAtIndex:j];
                    [array replaceObjectAtIndex:j withObject:[array objectAtIndex:i]];
                    [array replaceObjectAtIndex:i withObject:temp];
                }
            }
        }
    }
    return array;
}

- (NSArray*) calculateMoveForBoard: (NSMutableArray*) board
{
    theBoard = board;
    int boardSketch[5][5];
    moveOption defaultMove;
    defaultMove.moveX = 0;
    defaultMove.moveY = 0;
    defaultMove.direction = false;
    defaultMove.placeX = 0;
    defaultMove.placeY = 0;
    defaultMove.pointValue = 0;
    NSMutableArray *moveOptions = [[NSMutableArray alloc] initWithObjects: [super valueWithMoveOption:defaultMove],nil];
    NSLog(@"Count 0");
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
    //MoveOption has all the highest-point-value moves
    NSArray *moveOptions2 = [NSArray arrayWithArray:[self sortByPointValue:moveOptions]];
    [moveOptions removeAllObjects];
    if(moveOptions2.count > 0)
        [moveOptions addObject: [moveOptions2 objectAtIndex:0]];
    NSLog(@"count 5");
    for(int i = 1; i < [moveOptions2 count]; i++){
        if(((Tile*)[[theBoard objectAtIndex: [super moveOptionOf:[moveOptions2 objectAtIndex:i]].moveX] objectAtIndex: [super moveOptionOf:[moveOptions2 objectAtIndex:i]].moveY]).value != ((Tile*)[[theBoard objectAtIndex: [super moveOptionOf:[moveOptions2 objectAtIndex:i-1]].moveX] objectAtIndex: [super moveOptionOf:[moveOptions2 objectAtIndex:i-1]].moveY]).value){
            break;
        }
        else{
            [moveOptions addObject: [moveOptions2 objectAtIndex:0]];
        }
    }
    
    moveOption incrementMove = defaultMove;
    int opponentMaxPoints = 26; //max possible score on one move is 25
    NSMutableArray* movesForMaxPoints = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:26], nil];
    
    int boardDrawing[5][5];
    
    for(int a = 0; a < 5; a++)
        for(int b = 0; b < 5; b++)
            boardSketch[a][b] = ((Tile*)[[board objectAtIndex:a] objectAtIndex:b]).value;
    
    [moveOptions count];
    NSLog(@"part1");
    
    for(int c = 0; c < [moveOptions count]; c++){
        moveOption currentTile = [super moveOptionOf:[moveOptions objectAtIndex:c]];
        for(int i = 0; i < 5; i++)
            for(int j = 0; j < 5; j++)
                boardDrawing[i][j] = boardSketch[i][j];
        boardDrawing[currentTile.placeX][currentTile.placeY] += 2;
        if(boardDrawing[currentTile.placeX][currentTile.placeY] > 5) boardDrawing[currentTile.placeX][currentTile.placeY] = 5;
        if(currentTile.placeX > 0 && currentTile.placeY > 0)
            if(boardDrawing[currentTile.placeX-1][currentTile.placeY-1] < 5)
                boardDrawing[currentTile.placeX-1][currentTile.placeY-1]++;
        if(currentTile.placeX > 0 && currentTile.placeY < 4)
            if(boardDrawing[currentTile.placeX-1][currentTile.placeY+1] < 5)
                boardDrawing[currentTile.placeX-1][currentTile.placeY+1]++;
        if(currentTile.placeX < 4 && currentTile.placeY > 0)
            if(boardDrawing[currentTile.placeX+1][currentTile.placeY-1] < 5)
                boardDrawing[currentTile.placeX+1][currentTile.placeY-1]++;
        if(currentTile.placeX < 4 && currentTile.placeY < 4)
            if(boardDrawing[currentTile.placeX+1][currentTile.placeY+1] < 5)
                boardDrawing[currentTile.placeX+1][currentTile.placeY+1]++;
        int k = 1;
        if(currentTile.direction){
            while(boardDrawing[currentTile.moveX+k][currentTile.moveY] == boardDrawing[currentTile.moveX][currentTile.moveY]){
                boardDrawing[currentTile.moveX+k][currentTile.moveY] = 0;
                k++;
            }
        }
        else{
            while(boardDrawing[currentTile.moveX][currentTile.moveY+k] == boardDrawing[currentTile.moveX][currentTile.moveY]){
                boardDrawing[currentTile.moveX][currentTile.moveY+k] = 0;
                k++;
            }
        }
        boardDrawing[currentTile.moveX][currentTile.moveY] = 0;
        //The board is now set up as if the AI had already made the move. Now....
        // The AI needs to find which move provides the lowest number of points for its opponent.
        int boardRepresentation[5][5];
        for(int i = 0; i < 5; i++){
            for(int j = 0; j < 5; j++){
                for(int a = 0; a < 5; a++)
                    for(int b = 0; b < 5; b++)
                        boardRepresentation[a][b] = boardDrawing[a][b];
                
                boardRepresentation[i][j] += 2;
                if(boardRepresentation[i][j] > 5) boardRepresentation[i][j] = 5;
                if(i > 0 && j > 0)
                    if(boardRepresentation[i-1][j-1] < 5)
                        boardRepresentation[i-1][j-1]++;
                if(i > 0 && j < 4)
                    if(boardRepresentation[i-1][j+1] < 5)
                        boardRepresentation[i-1][j+1]++;
                if(i < 4 && j > 0)
                    if(boardRepresentation[i+1][j-1] < 5)
                        boardRepresentation[i+1][j-1]++;
                if(i < 4 && j < 4)
                    if(boardRepresentation[i+1][j+1] < 5)
                        boardRepresentation[i+1][j+1]++;
                //The sketch for the possible next move has been made. Now, find the minimum value you can get off of it.
                int maxValForMove = 0;
                for(int a = 0; a < 5; a++){
                    for(int b = 0; b < 5; b++){
                        if(a+1 < 5){
                            if(boardRepresentation[a+1][b] == boardRepresentation[a][b]){
                                int tempPointValue = 0;
                                int k = 1;
                                while(a+k < 5 && boardRepresentation[a+k][b] == boardRepresentation[a][b] && boardRepresentation[a][b] != 0){
                                    tempPointValue += boardRepresentation[a+k][b];
                                    k++;
                                }
                                if(tempPointValue > maxValForMove){
                                    maxValForMove = tempPointValue;
                                }
                            }
                        }
                        if(b+1 < 5){
                            if(boardRepresentation[a][b+1] == boardRepresentation[a][b]){
                                int tempPointValue = 0;
                                int k = 1;
                                while(b+k < 5 && boardRepresentation[a][b+k] == boardRepresentation[a][b] && boardRepresentation[a][b] != 0){
                                    tempPointValue += boardRepresentation[a][b+k];
                                    k++;
                                }
                                if(tempPointValue > maxValForMove){
                                    maxValForMove = tempPointValue;
                                }
                            }
                        }
                    }
                }
                //see if the max points the opponent can get is as low as possible
                //if it is, add this to the list of acceptable moves
                if(maxValForMove < opponentMaxPoints){
                    opponentMaxPoints = maxValForMove;
                    [movesForMaxPoints removeAllObjects];
                    [movesForMaxPoints addObject:[NSNumber numberWithInt:c]];
                }
                else if(maxValForMove == opponentMaxPoints){
                    [movesForMaxPoints addObject:[NSNumber numberWithInt:c]];
                }
            }
        }
    }
    
    NSLog(@"part2");
    
    int c = [[movesForMaxPoints objectAtIndex:arc4random()%[movesForMaxPoints count]] intValue];
    incrementMove = [super moveOptionOf:[moveOptions objectAtIndex:c]];
    //everything from here forward is the same.
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
    NSLog(@"Part3");
    
    
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
    NSLog(@"Part4");
    
    return returner;
}

@end
