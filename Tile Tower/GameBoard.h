//
//  GameBoard.h
//  Tile Tower
//
//  Created by Louis Jacobowitz on 1/12/15.
//  Copyright (c) 2015 Louis Jacobowitz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tile.h"
#import "TileTowerAI.h"
#import "TileTowerAIType1.h"
#import "TileTowerAIType2.h"
#import "TileTowerAIType3.h"

@interface GameBoard : UILabel
{
    NSMutableArray *board;
    NSMutableArray *highlightedTileList;
    UILabel *clickDragOverlay;
    UIImageView *messageOverlay;
    UILabel *backgroundLabel;
    UILabel *messageLabel;
    UIButton *endTurnButton;
    
    TileTowerAI *AI0;
    TileTowerAI *AI1;
    TileTowerAI *AI2;
    TileTowerAI *AI3;
    
    int turn;
    int maxplayers;
    int maxScore;
    NSMutableArray *score;
    NSMutableArray *scoreLabels;
    NSMutableArray *scoreLabelBackgrounds;
    bool turnPhase;
    bool messageIsUp;
    
    NSMutableArray *AIMove;
    NSArray *names;
    NSTimer *timer;
    int timerCt;
}

- (id) initWithPlayers: (NSArray*) playernumber withNames: (NSArray*) playerNames withFrame: (CGRect) frame andScoreLimit: (int) limit;

- (void) tileWasClicked: (Tile*) tile;

- (void) sendMessage: (NSString*) message;

- (void) startTurn;

- (void) endTurn;

- (void) dealWithAI;

- (void) setAIActive: (BOOL) x;

@end
