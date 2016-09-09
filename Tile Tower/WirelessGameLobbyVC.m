//
//  WirelessGameLobbyVC.m
//  Tile Tower
//
//  Created by Louis Jacobowitz on 1/19/15.
//  Copyright (c) 2015 Louis Jacobowitz. All rights reserved.
//

#import "WirelessGameLobbyVC.h"

@implementation WirelessGameLobbyVC

@synthesize appDelegate;

- (id) initWithPlayers: (NSArray*) players
{
    self = [super init];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    playerNames = players;
    minNumberOfPlayers = (int)[players count];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //AI and players
    [AILabel0 setText: (NSString*) [playerNames objectAtIndex:0]];
    
    if(playerNames.count > 1)
        [AILabel1 setText: (NSString*) [playerNames objectAtIndex:1]];
    else
        [AILabel1 setText: @"Player 2: "];
    
    if(playerNames.count > 2)
        [AILabel2 setText: (NSString*) [playerNames objectAtIndex:2]];
    else
        [AILabel2 setText: @"Player 3: "];
    
    if(playerNames.count > 3)
        [AILabel3 setText: (NSString*) [playerNames objectAtIndex:3]];
    else
        [AILabel3 setText: @"Player 4: "];
    
    [AIControl0 setUserInteractionEnabled:NO];
    
    if(minNumberOfPlayers >= 2)
        [AIControl1 setUserInteractionEnabled:NO];
    
    if(minNumberOfPlayers >= 3)
        [AIControl2 setUserInteractionEnabled:NO];
    
    if(minNumberOfPlayers >= 4)
        [AIControl3 setUserInteractionEnabled:NO];
    
    [AIControl0 addTarget:self action:@selector(changeAI:) forControlEvents:UIControlEventValueChanged];
    [AIControl1 addTarget:self action:@selector(changeAI:) forControlEvents:UIControlEventValueChanged];
    [AIControl2 addTarget:self action:@selector(changeAI:) forControlEvents:UIControlEventValueChanged];
    [AIControl3 addTarget:self action:@selector(changeAI:) forControlEvents:UIControlEventValueChanged];

    
    
    if(minNumberOfPlayers >= 3){
        [container addSubview: AIControl2];
        [container addSubview: AILabel2];
    }
    if(minNumberOfPlayers >= 4){
        [container addSubview: AILabel3];
        [container addSubview: AIControl3];
    }
    
    
    
    if(!host) {
        [self.view setUserInteractionEnabled:NO];
    }
    
    //set up wireless things
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:@"MCDidReceiveDataNotification"
                                               object:nil];
}

- (NSArray*) setPlayerList
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    for(int i = 0; i < playerNumber; i++){
        if(i < minNumberOfPlayers)
            [list addObject: [playerNames objectAtIndex: i]];
        else
            [list addObject: [@"Player " stringByAppendingFormat:@"%i",i]];
    }
    return list;
}

- (void) changeAI: (UISegmentedControl*) sender
{
    if(host){
        NSString *toSend = @"ChangeP";
        if(sender == AIControl0)
            toSend = [toSend stringByAppendingString:@"0"];
        else if(sender == AIControl1)
            toSend = [toSend stringByAppendingString:@"1"];
        else if(sender == AIControl2)
            toSend = [toSend stringByAppendingString:@"2"];
        else if(sender == AIControl3)
            toSend = [toSend stringByAppendingString:@"3"];
        toSend = [toSend stringByAppendingString:@"State"];
        toSend = [toSend stringByAppendingFormat:@"%i",(int)sender.selectedSegmentIndex];
        [self sendState:toSend];
    }
}

- (void) newGame{
    NSString* changeName = @"ChangeNames";
    for(int i = 0; i < playerNames.count; i++){
        changeName = [changeName stringByAppendingString:[playerNames objectAtIndex:i]];
        changeName = [changeName stringByAppendingString:@","];
    }
    
    [self sendState:changeName];
    [self sendState:@"StartGame"];
    [super newGame];
}

- (void) changeMaxScore{
    if(host)
        maxScore = incrementMaxScore.value;
    
    [maxScoreLabel setText:[@"Score Limit: " stringByAppendingString:[NSString stringWithFormat:@"%i",maxScore]]];
    NSString *toSend = @"ChangeMaxScore";
    toSend = [toSend stringByAppendingFormat:@"%i",maxScore];
    [self sendState: toSend];
}

- (void) actuallyChangePlayerNumber{
    if(playerNumber >= 4){
        [container addSubview:AILabel3];
        [container addSubview:AIControl3];
    }
    else{
        [AILabel3 removeFromSuperview];
        [AIControl3 removeFromSuperview];
    }
    if(playerNumber >= 3){
        [container addSubview:AILabel2];
        [container addSubview:AIControl2];
    }
    else{
        [AILabel2 removeFromSuperview];
        [AIControl2 removeFromSuperview];
    }
    
}

- (void) changePlayerNumber{
    [super changePlayerNumber];
    
    NSString *toSend = @"ChangePlayerNo";
    toSend = [toSend stringByAppendingFormat:@"%i",(int)playerNumberSegmentedControl.selectedSegmentIndex];
    [self sendState: toSend];
    //[self performSelectorOnMainThread:@selector(actuallyChangePlayerNumber) withObject:nil waitUntilDone:NO];
}//7b1758b0
//7b164070

- (void) sendState: (NSString*) str;
{
    if(appDelegate.mcManager.connected && host){
        NSLog(@"Sent");
        NSLog(str);
        
        NSData *dataToSend = [str dataUsingEncoding: NSUTF8StringEncoding];
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
}

- (int) findChar: (char) c inString: (NSString*) s
{
    for(int i = 0; i < [s length]; i++)
        if([s characterAtIndex:i] == c)
            return i;
    return -1;
}

-(void)didReceiveDataWithNotification:(NSNotification *)notification{
    //MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    //NSString *peerDisplayName = peerID.displayName;
    if(!host){
        NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
        NSString *action = [[NSString alloc] initWithData: receivedData encoding:NSUTF8StringEncoding];
        
        NSLog(@"Recieved:");
        NSLog(action);
        
        if([action containsString:@"ChangeMaxScore"]){
            NSString* valueStr = [action substringFromIndex:14];
            maxScore = (int)[valueStr integerValue];
            //[self changeMaxScore];
            [self performSelectorOnMainThread:@selector(changeMaxScore) withObject:nil waitUntilDone:NO];
        }
        else if([action containsString:@"ChangePlayerNo"]){
            NSString *valueStr = [action substringFromIndex:14];
            [playerNumberSegmentedControl setSelectedSegmentIndex: [valueStr integerValue]];
            playerNumber = playerNumberSegmentedControl.selectedSegmentIndex + 2;
            //[self changePlayerNumber];
            [self performSelectorOnMainThread:@selector(actuallyChangePlayerNumber) withObject:nil waitUntilDone:NO];
        }
        else if([action containsString:@"ChangeP0State"]){
            NSString* valueStr = [action substringFromIndex:13];
            //AIControl0.selectedSegmentIndex = (int)[valueStr integerValue];
            [self performSelectorOnMainThread:@selector(setAI0To:) withObject: [NSNumber numberWithInt:[valueStr intValue]] waitUntilDone:NO];
        }
        else if([action containsString:@"ChangeP1State"]){
            NSString* valueStr = [action substringFromIndex:13];
            //AIControl1.selectedSegmentIndex = (int)[valueStr integerValue];
            [self performSelectorOnMainThread:@selector(setAI1To:) withObject: [NSNumber numberWithInt:[valueStr intValue]] waitUntilDone:NO];
        }
        else if([action containsString:@"ChangeP2State"]){
            NSString* valueStr = [action substringFromIndex:13];
            //AIControl2.selectedSegmentIndex = (int)[valueStr integerValue];
            [self performSelectorOnMainThread:@selector(setAI2To:) withObject: [NSNumber numberWithInt:[valueStr intValue]] waitUntilDone:NO];
        }
        else if([action containsString:@"ChangeP3State"]){
            NSString* valueStr = [action substringFromIndex:13];
            //AIControl3.selectedSegmentIndex = (int)[valueStr integerValue];
            [self performSelectorOnMainThread:@selector(setAI3To:) withObject: [NSNumber numberWithInt:[valueStr intValue]] waitUntilDone:NO];
        }
        else if([action containsString:@"ChangeNames"]){
            NSMutableArray *newNames = [[NSMutableArray alloc] init];
            action = [action substringFromIndex:11];
            //NSLog(action);
            while([action length] > 1){
                int endChar = [self findChar:',' inString: action];
                [newNames addObject: [action substringToIndex: endChar]];
                action = [action substringFromIndex:endChar+1];
            }
            playerNames = newNames;
        }
        else if([action containsString:@"StartGame"]){
            //[self newGame];
            [self performSelectorOnMainThread:@selector(newGame) withObject:nil waitUntilDone:NO];
        }
    }
}

- (void) setAI0To: (NSNumber*) i {[AIControl0 setSelectedSegmentIndex:i.integerValue];}
- (void) setAI1To: (NSNumber*) i {[AIControl1 setSelectedSegmentIndex:i.integerValue];}
- (void) setAI2To: (NSNumber*) i {[AIControl2 setSelectedSegmentIndex:i.integerValue];}
- (void) setAI3To: (NSNumber*) i {[AIControl3 setSelectedSegmentIndex:i.integerValue];}


- (void) setIsHost: (BOOL) isHost
{
    host = isHost;
}


//all other methods are exactly the same as the host class

@end
