//
//  GameViewController.h
//  Tile Tower
//

//  Copyright (c) 2015 Louis Jacobowitz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "GameBoard.h"


@interface GameViewController : UIViewController
{
    UILabel *gameContainer;
    GameBoard *game;
    UIViewController *lowerViewController;
    int p1Status, p2Status, p3Status, p4Status;
    
    UIBarButtonItem *backButton;
}

- (void) pauseGame;
- (void) unpauseGame;

- (void) startNewGameWithPlayers: (NSArray*) players andLimit: (int) limit withVC: (UIViewController*) vc;
- (void) configurePlayers1: (int) p1 player2:(int) p2 player3: (int) p3 player4: (int) p4;
- (void) popThisView;

@end
