//
//  WirelessGameLobbyVC.h
//  Tile Tower
//
//  Created by Louis Jacobowitz on 1/19/15.
//  Copyright (c) 2015 Louis Jacobowitz. All rights reserved.
//

#import "GameLobbyViewController.h"
#import "WirelessGameViewController.h"
#import "AppDelegate.h"

@interface WirelessGameLobbyVC : GameLobbyViewController
{
    NSArray* playerNames;
    
    int minNumberOfPlayers;
    
    BOOL host;
}

@property (strong, nonatomic) AppDelegate *appDelegate;

- (void) changeAI: (UISegmentedControl*) sender;

- (id) initWithPlayers: (NSArray*) players;

- (void) setIsHost: (BOOL) isHost;

@end
