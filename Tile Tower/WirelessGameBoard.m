//
//  WirelessGameBoard.m
//  Tile Tower
//
//  Created by Louis Jacobowitz on 5/14/15.
//  Copyright (c) 2015 Louis Jacobowitz. All rights reserved.
//

#import "WirelessGameBoard.h"

@implementation WirelessGameBoard

@synthesize appDelegate;

- (id) initWithPlayers: (NSArray*) playernumber withNames: (NSArray*) playerNames withFrame: (CGRect) frame andScoreLimit:(int)limit
{
    self = [super initWithPlayers:playernumber withNames:playerNames withFrame:frame andScoreLimit:limit];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:@"MCDidReceiveDataNotification"
                                               object:nil];
    
    return self;
}

- (void) tileWasClicked: (Tile*) tile
{
    [super tileWasClicked:tile];
    
    NSString* tileID = @"TileClicked";
    tileID = [tileID stringByAppendingFormat:@"%i",tile.X];
    tileID = [tileID stringByAppendingFormat:@"%i",tile.Y];
    
    [self sendState: tileID];
}

- (void) startTurn
{
    NSLog([NSString stringWithFormat:@"%i",myPlayerNo]);
    NSLog([NSString stringWithFormat:@"%i",turn]);
    
    for(int i = 0; i < [score count]; i++){
        [[scoreLabels objectAtIndex:i] setText: [[names objectAtIndex:i] stringByAppendingString: [@": " stringByAppendingString: [[score objectAtIndex:i] stringValue]]]];
        if(i == turn)
            [[scoreLabels objectAtIndex:i] setTextColor:[UIColor blackColor]];
        else
            [[scoreLabels objectAtIndex:i] setTextColor:[UIColor whiteColor]];
    }
    
    NSString *mes = [[names objectAtIndex:turn] stringByAppendingString:@"'s Turn!"];
    [self sendMessage: mes];
/**/[self sendState:[@"TurnStart" stringByAppendingString:mes]];
    [clickDragOverlay removeFromSuperview];
    turnPhase = true;
    
/**/if(turn != myPlayerNo)
/**/    [backgroundLabel setUserInteractionEnabled:NO];
    
/**/if(host)
        if((turn == 0 && AI0) || (turn == 1 && AI1) || (turn == 2 && AI2) || (turn == 3 && AI3)){
            timerCt = 0;
            timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(dealWithAI) userInfo:nil repeats:YES];
            [timer fire];
            [backgroundLabel setUserInteractionEnabled: NO];
        }
    
}

- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent *)event
{
    if(messageIsUp && turn == myPlayerNo)
        [self sendState:@"RemoveMessage"];
    if(!turnPhase && turn == myPlayerNo){ //IF...AND IT IS MY TURN...
        NSString* highlightStr = @"HighlightTiles";
        for(int i = 0; i < [highlightedTileList count]; i++){
            [[highlightedTileList objectAtIndex:i] highlight];
            highlightStr = [highlightStr stringByAppendingFormat:@"%i",((Tile*)[highlightedTileList objectAtIndex:i]).X];
            highlightStr = [highlightStr stringByAppendingFormat:@"%i",((Tile*)[highlightedTileList objectAtIndex:i]).Y];
        }
        [self sendState: highlightStr];
        //...send everybody else all my highlights.
    }
    
    [super touchesEnded:touches withEvent:event];
}

- (void) dealWithAI
{
    if(timerCt == 1){
        [self sendState:@"RemoveMessage"];
        [super dealWithAI];
    }
    else if(timerCt == 3){
        //NSLog(@"Start AI-3");
        highlightedTileList = AIMove;
        if([highlightedTileList count] == 0){
            NSString* passStr = [[names objectAtIndex:turn]stringByAppendingString: @" passes this turn." ];
            [self sendMessage: passStr];
/**/        [self sendState:@"PassTurn"];
        }
        else{
/**/        NSString* highlightStr = @"HighlightTiles";
            for(int i = 0; i < [highlightedTileList count]; i++){
                [[highlightedTileList objectAtIndex:i] highlight];
                highlightStr = [highlightStr stringByAppendingFormat:@"%i",((Tile*)[highlightedTileList objectAtIndex:i]).X];
                highlightStr = [highlightStr stringByAppendingFormat:@"%i",((Tile*)[highlightedTileList objectAtIndex:i]).Y];
            }
            [self sendState:highlightStr];
/**/
        }
        
        [self setUserInteractionEnabled:NO];
        timerCt = 4;
        //NSLog(@"End AI-3");
    }
    else
        [super dealWithAI];
}

- (void) endTurn
{
    [self sendState: @"EndTurn"];
    [super endTurn];
}

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

-(void)didReceiveDataWithNotification:(NSNotification *)notification{
    //MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    //NSString *peerDisplayName = peerID.displayName;
    if(!host){
        NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
        NSString *action = [[NSString alloc] initWithData: receivedData encoding:NSUTF8StringEncoding];
        
        NSLog(@"Recieved:");
        NSLog(action);
        
        if([action containsString:@"RemoveMessage"]){
            [messageOverlay removeFromSuperview];
            messageIsUp = NO;
        }
        else if([action containsString:@"TileClicked"]){
            int myX = [[action substringWithRange:NSMakeRange(11,1)] intValue];
            int myY = [[action substringWithRange:NSMakeRange(12,1)] intValue];
            [self tileWasClicked:[[board objectAtIndex:myX]objectAtIndex:myY]];
        }
        else if([action containsString:@"TurnStart"]){
            [self startTurn];
        }
        else if([action containsString:@"PassTurn"]){
            NSString* passStr = [[names objectAtIndex:turn]stringByAppendingString: @" passes this turn." ];
            [self sendMessage: passStr];
        }
        else if([action containsString:@"HighlightTiles"]){
            NSMutableArray* hTiles = [[NSMutableArray alloc] init];
            action = [action substringFromIndex:14];
            while([action length] > 0){
                int x = [[action substringWithRange:NSMakeRange(0, 1)] intValue];
                int y = [[action substringWithRange:NSMakeRange(1, 1)] intValue];
                action = [action substringFromIndex:2];
                [hTiles addObject:[[board objectAtIndex:x]objectAtIndex:y]];
            }
            highlightedTileList = hTiles;
            for(int i = 0; i < hTiles.count; i++){
                [[hTiles objectAtIndex:i] highlight];
            }
        }
        else if([action containsString:@"EndTurn"]){
            [self endTurn];
        }
    }
}



- (void) setHost:(BOOL)isHost
{
    host = isHost;
    myPlayerNo = appDelegate.mcManager.myPlayerNumber;
    
    NSLog([NSString stringWithFormat:@"%i",myPlayerNo]);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
