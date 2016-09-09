//
//  WirelessGameViewController.h
//  Tile Tower
//
//  Created by Louis Jacobowitz on 1/19/15.
//  Copyright (c) 2015 Louis Jacobowitz. All rights reserved.
//

#import "GameViewController.h"
#import "WirelessGameBoard.h"

@interface WirelessGameViewController : GameViewController
{
    BOOL host;
    int playerNo;
}

- (void) setHost: (BOOL) isHost;

@end
