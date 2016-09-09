//
//  SubordinateGameViewController.m
//  Tile Tower
//
//  Created by Louis Jacobowitz on 1/19/15.
//  Copyright (c) 2015 Louis Jacobowitz. All rights reserved.
//

#import "SubordinateGameViewController.h"

@implementation SubordinateGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Handling the wireless stuff
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:@"MCDidReceiveDataNotification"
                                               object:nil];
    // Giving the Game a container
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sendGame:)
                                                 name:@"MultiplayerGame"
                                               object:nil];
}

- (void) sendGame: (NSNotification*) notification
{
    if(appDelegate.mcManager.connected){
        NSData *dataToSend = [NSData dataWithBytes:(__bridge const void *)(game) length:sizeof(game)]; //[_txtMessage.text dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *allPeers = appDelegate.mcManager.session.connectedPeers;
        NSError *error;
        
        [appDelegate.mcManager.session sendData:dataToSend
                                        toPeers:allPeers
                                       withMode:MCSessionSendDataReliable
                                          error:&error];
        
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
    [game startTurn];
}

-(void)didReceiveDataWithNotification:(NSNotification *)notification{ //taken straight from tutorial
    //has yet to be dealt with
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    
    NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
    game = receivedData;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
