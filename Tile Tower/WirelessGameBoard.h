//
//  WirelessGameBoard.h
//  Tile Tower
//
//  Created by Louis Jacobowitz on 5/14/15.
//  Copyright (c) 2015 Louis Jacobowitz. All rights reserved.
//

#import "GameBoard.h"
#import "AppDelegate.h"

@interface WirelessGameBoard : GameBoard
{
    BOOL host;
    int myPlayerNo;
}

- (void) setHost: (BOOL) isHost;

- (void) sendState: (NSString*) str;

@property (strong, nonatomic) AppDelegate *appDelegate;

@end
