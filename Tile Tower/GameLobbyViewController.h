//
//  GameLobbyViewController.h
//  Tile Tower
//
//  Created by Louis Jacobowitz on 1/14/15.
//  Copyright (c) 2015 Louis Jacobowitz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"

@interface GameLobbyViewController : UIViewController
{
    UILabel *container;
    
    GameViewController *gameVC;
    
    int playerNumber;
    UILabel *playerNumberLabel;
    UISegmentedControl *playerNumberSegmentedControl;
    // AI:
    UILabel *AILabel0, *AILabel1, *AILabel2, *AILabel3;
    UISegmentedControl *AIControl0, *AIControl1, *AIControl2, *AIControl3;
    
    UILabel *maxScoreLabel;
    UIStepper *incrementMaxScore;
    int maxScore;
    
    UIButton *startGameButton;
    UIBarButtonItem *continueGameButton;
}

- (void) changeMaxScore;

- (void) newGame;
- (void) continueGame;

- (void) changePlayerNumber;

@end
