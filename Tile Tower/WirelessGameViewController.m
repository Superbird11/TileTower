//
//  WirelessGameViewController.m
//  Tile Tower
//
//  Created by Louis Jacobowitz on 1/19/15.
//  Copyright (c) 2015 Louis Jacobowitz. All rights reserved.
//

#import "WirelessGameViewController.h"

@implementation WirelessGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) setHost: (BOOL) isHost
{
    host = isHost;
}

- (void) startNewGameWithPlayers:(NSArray *)players andLimit:(int)limit withVC:(UIViewController *)vc
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
    
    game = [[WirelessGameBoard alloc] initWithPlayers: playerStatuses withNames: players withFrame:CGRectMake(10,50,300,400) andScoreLimit:limit];
    [self.view addSubview:game];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
