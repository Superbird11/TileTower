//
//  GameViewController.m
//  Tile Tower
//
//  Created by Louis Jacobowitz on 1/10/15.
//  Copyright (c) 2015 Louis Jacobowitz. All rights reserved.
//

#import "GameViewController.h"

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor: [UIColor whiteColor]];
    
    backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back to Lobby" style:UIBarButtonItemStylePlain target:self action:@selector(pauseGame)];

    self.navigationItem.leftBarButtonItem = backButton;
    
    
    //game = [[GameBoard alloc] initWithPlayers:2 withFrame: CGRectMake(10,50,300,400)];
    [self.view addSubview: game];
    
    p1Status = p2Status = p3Status = p4Status = 0;
    
}

- (void) pauseGame
{
    [game setAIActive: NO];
    [self popThisView];
}

- (void) unpauseGame
{
    [game setAIActive: YES];
}

- (void) startNewGameWithPlayers: (NSArray*) players andLimit: (int) limit withVC: (UIViewController*) vc;
{
    lowerViewController = vc;
    if(game)
        [game removeFromSuperview];
    game = nil;
    
    int playerCt = [players count];
    
    NSMutableArray *playerStatuses = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:p1Status],[NSNumber numberWithInt:p2Status],nil];
    if(playerCt >= 3)
        [playerStatuses addObject:[NSNumber numberWithInt:p3Status]];
    if(playerCt >= 4)
        [playerStatuses addObject:[NSNumber numberWithInt:p4Status]];
    
    game = [[GameBoard alloc] initWithPlayers: playerStatuses withNames: players withFrame:CGRectMake(10,50,300,400) andScoreLimit:limit];
    [self.view addSubview:game];
}

- (void) configurePlayers1:(int) p1 player2:(int)p2 player3:(int)p3 player4:(int)p4
{
    p1Status = p1;
    p2Status = p2;
    p3Status = p3;
    p4Status = p4;
}

- (void) popThisView
{
    [[self navigationController] popToViewController:lowerViewController animated:YES];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
