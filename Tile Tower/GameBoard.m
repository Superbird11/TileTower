//
//  GameBoard.m
//  Tile Tower
//
//  Created by Louis Jacobowitz on 1/12/15.
//  Copyright (c) 2015 Louis Jacobowitz. All rights reserved.
//

#import "GameBoard.h"

@implementation GameBoard

- (id) initWithPlayers: (NSArray*) playernumber withNames: (NSArray*) playerNames withFrame: (CGRect) frame andScoreLimit:(int)limit
{
    self = [super initWithFrame:frame];
    //[self setBackgroundColor:[UIColor redColor]];
    [self setUserInteractionEnabled:YES];
    
    names = playerNames;
    
    backgroundLabel = [[UILabel alloc] initWithFrame: CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
    [self addSubview: backgroundLabel];
    [backgroundLabel setUserInteractionEnabled:YES];
    
    if([playernumber count] >= 1){
        switch([[playernumber objectAtIndex:0] intValue]){
            case 1:
                AI0 = [[TileTowerAIType1 alloc] init];
                break;
            case 2:
                AI0 = [[TileTowerAIType2 alloc] init];
                break;
            case 3:
                AI0 = [[TileTowerAIType3 alloc] init];
                break;
            default:
                break;
        }
    }
    if([playernumber count] >= 2){
        switch([[playernumber objectAtIndex:1] intValue]){
            case 1:
                AI1 = [[TileTowerAIType1 alloc] init];
                break;
            case 2:
                AI1 = [[TileTowerAIType2 alloc] init];
                break;
            case 3:
                AI1 = [[TileTowerAIType3 alloc] init];
                break;
            default:
                break;
        }
    }
    if([playernumber count] >= 3){
        switch([[playernumber objectAtIndex:2] intValue]){
            case 1:
                AI2 = [[TileTowerAIType1 alloc] init];
                break;
            case 2:
                AI2 = [[TileTowerAIType2 alloc] init];
                break;
            case 3:
                AI2 = [[TileTowerAIType3 alloc] init];
                break;
            default:
                break;
        }
    }
    if([playernumber count] >= 4){
        switch([[playernumber objectAtIndex:3] intValue]){
            case 1:
                AI3 = [[TileTowerAIType1 alloc] init];
                break;
            case 2:
                AI3 = [[TileTowerAIType2 alloc] init];
                break;
            case 3:
                AI3 = [[TileTowerAIType3 alloc] init];
                break;
            default:
                break;
        }
    }
    
    score = [[NSMutableArray alloc] init];
    scoreLabels = [[NSMutableArray alloc] init];
    scoreLabelBackgrounds = [[NSMutableArray alloc] init];
    for(int i = 0; i < [playernumber count]; i++)
    {
        [score addObject: [NSNumber numberWithInt:0]];
        //[[scoreLabels objectAtIndex:i] setText: [playerNames objectAtIndex:i]];
        [scoreLabelBackgrounds addObject: [[UIImageView alloc] initWithFrame:CGRectMake(5,305,140,40)]];
        [scoreLabels addObject: [[UILabel alloc] initWithFrame: CGRectMake(0,0,140,40)]];
        [[scoreLabels objectAtIndex:i] setTextAlignment: NSTextAlignmentCenter];
        switch(i)
        {
            case 1:
                [[scoreLabelBackgrounds objectAtIndex:i] setFrame:CGRectMake(155,305,140,40)];
                [[scoreLabelBackgrounds objectAtIndex:i] setImage: [UIImage imageNamed:@"ScoreButton2.png"]];
                [[scoreLabels objectAtIndex:i] setTextColor:[UIColor whiteColor]];
                break;
            case 2:
                [[scoreLabelBackgrounds objectAtIndex:i] setFrame:CGRectMake(5,350,140,40)];
                [[scoreLabelBackgrounds objectAtIndex:i] setImage: [UIImage imageNamed:@"ScoreButton3.png"]];
                [[scoreLabels objectAtIndex:i] setTextColor:[UIColor whiteColor]];
                break;
            case 3:
                [[scoreLabelBackgrounds objectAtIndex:i] setFrame:CGRectMake(155,350,140,40)];
                [[scoreLabelBackgrounds objectAtIndex:i] setImage: [UIImage imageNamed:@"ScoreButton4.png"]];
                [[scoreLabels objectAtIndex:i] setTextColor:[UIColor whiteColor]];
                break;
            default:
                [[scoreLabelBackgrounds objectAtIndex:i] setImage: [UIImage imageNamed:@"ScoreButton1.png"]];
                [[scoreLabels objectAtIndex:i] setTextColor:[UIColor whiteColor]];
                break;
        }
        [[scoreLabelBackgrounds objectAtIndex:i] addSubview: [scoreLabels objectAtIndex:i]];
        [self addSubview: [scoreLabelBackgrounds objectAtIndex: i]];
        //TODO: make and assign background images and colors.
    }
    
    turn = 0;
    turnPhase = true; //True = select tile to change. False = select tiles to take.
    messageIsUp = false;
    maxScore = limit;
    
    messageOverlay = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"Message.png"] highlightedImage: [UIImage imageNamed: @"Message.png"]];
    [messageOverlay setFrame: CGRectMake(0,70,self.frame.size.width,120)];
    [messageOverlay setUserInteractionEnabled:YES];
    
    messageLabel = [[UILabel alloc] initWithFrame: CGRectMake(0,0,messageOverlay.frame.size.width,20)];
    [messageLabel setCenter: CGPointMake(self.frame.size.width / 2, 60)];
    [messageLabel setFont: [UIFont systemFontOfSize:20]];
    [messageOverlay addSubview: messageLabel];
    [messageOverlay bringSubviewToFront:messageLabel];
    
    endTurnButton = [[UIButton alloc] initWithFrame: CGRectMake(0,0,100,50)];
    [endTurnButton setCenter: CGPointMake(messageOverlay.frame.size.width - 50,60)];
    [endTurnButton setBackgroundImage: [UIImage imageNamed:@"endTurnButton.png"] forState: UIControlStateNormal];
    [[endTurnButton titleLabel] setNumberOfLines:0];
    [[endTurnButton titleLabel] setTextAlignment:NSTextAlignmentCenter];
    [[endTurnButton titleLabel] setFont: [UIFont systemFontOfSize:12]];
    [endTurnButton addTarget:self action:@selector(endTurn) forControlEvents:UIControlEventTouchUpInside];
    
    
    board = [[NSMutableArray alloc] init];
    for(int i = 0; i < 5; i++){
        [board addObject: [[NSMutableArray alloc] init]];
        for(int j = 0; j < 5; j++){
            [[board objectAtIndex: i]  addObject: [[Tile alloc] initWithX:i andY:j]];
            [backgroundLabel addSubview:[[board objectAtIndex:i] objectAtIndex:j]];
            //[self bringSubviewToFront:[[board objectAtIndex:i] objectAtIndex:j]];
            [[[board objectAtIndex: i] objectAtIndex: j] addTarget:self action:@selector(tileWasClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    clickDragOverlay = [[UILabel alloc] initWithFrame: backgroundLabel.frame];
    [clickDragOverlay setUserInteractionEnabled:YES];
    
    highlightedTileList = [[NSMutableArray alloc] init];
        
    [self startTurn];
    
    return self;
}

- (void) setAIActive: (BOOL) x
{
    if(!x)
        [timer invalidate];
    else
        if((turn == 0 && AI0) || (turn == 1 && AI1) || (turn == 2 && AI2) || (turn == 3 && AI3))
            timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(dealWithAI) userInfo:nil repeats:YES];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!messageIsUp){
        if(!turnPhase){
            UITouch *touch = [[event allTouches] anyObject];
            CGPoint loc = [touch locationInView:self];
            int x = (int)((loc.x)/60);
            int y = (int)((loc.y)/60);
            if(x < 5 && y < 5 && y >= 0 && y >= 0)
                if(![highlightedTileList containsObject:[[board objectAtIndex: x] objectAtIndex:y]]){
                    [[[board objectAtIndex: x] objectAtIndex:y] highlight];
                    [highlightedTileList addObject: [[board objectAtIndex:x] objectAtIndex:y]];
                }
        }
    }
}

- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent *)event
{
    if(messageIsUp){
        [messageOverlay removeFromSuperview];
        messageIsUp = false;
        [backgroundLabel setUserInteractionEnabled:YES];
        for(int i = 0; i < [highlightedTileList count]; i++)
            [[highlightedTileList objectAtIndex:i] unhighlight];
        [highlightedTileList removeAllObjects];
    }
    else{
        if(!turnPhase){
            bool inLineHoriz = true;
            bool inLineVert = true;
            if([highlightedTileList count] <= 1){
                inLineHoriz = false;
                inLineVert = false;
            }
            for(int i = 1; i < [highlightedTileList count]; i++){
                if(!(((Tile*)[highlightedTileList objectAtIndex:i]).X == ((Tile*)[highlightedTileList objectAtIndex:i-1]).X))
                    inLineHoriz = false;
                if(!(((Tile*)[highlightedTileList objectAtIndex:i]).Y == ((Tile*)[highlightedTileList objectAtIndex:i-1]).Y))
                    inLineVert = false;
                if(!(((Tile*)[highlightedTileList objectAtIndex:i]).value == ((Tile*)[highlightedTileList objectAtIndex:i-1]).value)){
                    inLineHoriz = false;
                    inLineVert = false;
                }
                if(((Tile*)[highlightedTileList objectAtIndex:i]).value == 0){
                    inLineHoriz = false;
                    inLineVert = false;
                }
            }
            
            if(inLineHoriz || inLineVert){
                [self sendMessage:@"goodMove"];
            }
            else{
                [self sendMessage:@"badMove"];
            }
        }
    }
}

- (void) sendMessage: (NSString*) message
{
    [messageOverlay addSubview: endTurnButton];
    NSString* displayMessage = [NSString stringWithString:message];
    
    if([message isEqualToString:@"goodMove"]){
        [endTurnButton setTitle: @"Take these\n  tiles" forState: UIControlStateNormal];
        [messageOverlay addSubview: endTurnButton];
        [messageOverlay bringSubviewToFront:endTurnButton];
        displayMessage = @"This move is valid.";
    }
    else if([message isEqualToString:@"badMove"]){
        for(int i = 0; i < [highlightedTileList count]; i++)
            [[highlightedTileList objectAtIndex:i] unhighlight];
        [highlightedTileList removeAllObjects]; //important difference!
        [endTurnButton setTitle: @"Pass this\n  turn" forState: UIControlStateNormal];
        [messageOverlay addSubview: endTurnButton];
        [messageOverlay bringSubviewToFront:endTurnButton];
        displayMessage = @"Invalid move! ";
    }
    else
        [endTurnButton removeFromSuperview];
    
    if([message containsString:@"winner"]){
        [messageLabel setText: displayMessage];
        [messageLabel setTextAlignment: NSTextAlignmentCenter];
        [messageLabel setFrame:CGRectMake(messageLabel.frame.origin.x,messageLabel.frame.origin.y,messageOverlay.frame.size.width,messageLabel.frame.size.height)];
    }
    else{
        [messageLabel setText: [@"  " stringByAppendingString: displayMessage]];
        [messageLabel sizeToFit];
    }
    
    [backgroundLabel setUserInteractionEnabled: NO];
    
    [self addSubview: messageOverlay];
    [self bringSubviewToFront:messageOverlay];
    messageIsUp = YES;
}

- (void) tileWasClicked: (Tile*) tile
{
    if(turnPhase){
        [[[board objectAtIndex:tile.X]objectAtIndex:tile.Y] increment:2];
        if(tile.X > 0 && tile.Y > 0)
            [[[board objectAtIndex:tile.X-1] objectAtIndex:tile.Y-1] increment:1];
        if(tile.X < 4 && tile.Y > 0)
            [[[board objectAtIndex:tile.X+1] objectAtIndex:tile.Y-1] increment:1];
        if(tile.X > 0 && tile.Y < 4)
            [[[board objectAtIndex:tile.X-1] objectAtIndex:tile.Y+1] increment:1];
        if(tile.X < 4 && tile.Y < 4)
            [[[board objectAtIndex:tile.X+1] objectAtIndex:tile.Y+1] increment:1];
        
        turnPhase = false;
        [self addSubview: clickDragOverlay];
        [self bringSubviewToFront: clickDragOverlay];
    }
}

- (void) startTurn
{
    
    for(int i = 0; i < [score count]; i++){
        [[scoreLabels objectAtIndex:i] setText: [[names objectAtIndex:i] stringByAppendingString: [@": " stringByAppendingString: [[score objectAtIndex:i] stringValue]]]];
        if(i == turn)
            [[scoreLabels objectAtIndex:i] setTextColor:[UIColor blackColor]];
        else
            [[scoreLabels objectAtIndex:i] setTextColor:[UIColor whiteColor]];
    }
    
    //THE ERROR OCCURS BETWEEN HERE (never mind, fixed, I think)
    NSString *mes = [[names objectAtIndex:turn] stringByAppendingString:@"'s Turn!"];
    [self sendMessage: mes];
    [clickDragOverlay removeFromSuperview];
    turnPhase = true;
    
    if((turn == 0 && AI0) || (turn == 1 && AI1) || (turn == 2 && AI2) || (turn == 3 && AI3)){
        timerCt = 0;
        timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(dealWithAI) userInfo:nil repeats:YES];
        [timer fire];
        [backgroundLabel setUserInteractionEnabled: NO];
    }
    //AND HERE
}

- (void) dealWithAI
{
    if(timerCt == 0){
        //NSLog(@"Start AI-0");
        [AIMove removeAllObjects];
        AIMove = nil;
        NSMutableArray *getAIMove;
        switch(turn){
            case 0:
                getAIMove = [[NSMutableArray alloc] initWithArray:[AI0 calculateMoveForBoard:board]];
                break;
            case 1:
                getAIMove = [[NSMutableArray alloc] initWithArray:[AI1 calculateMoveForBoard:board]];
                break;
            case 2:
                getAIMove = [[NSMutableArray alloc] initWithArray:[AI2 calculateMoveForBoard:board]];
                break;
            case 3:
                getAIMove = [[NSMutableArray alloc] initWithArray:[AI3 calculateMoveForBoard:board]];
                break;
            default:
                getAIMove = [[NSMutableArray alloc] initWithArray:[AI1 calculateMoveForBoard:board]];
        }
        
        AIMove = getAIMove;
        timerCt = 1;
        [self setUserInteractionEnabled:NO];
        //NSLog(@"End AI-0");
    }
    else if(timerCt == 1){
        //NSLog(@"Start AI-1");
        [messageOverlay removeFromSuperview];
        messageIsUp = false;
        timerCt = 2;
        [self setUserInteractionEnabled:NO];
        //NSLog(@"End AI-1");
    }
    else if(timerCt == 2){
        //NSLog(@"Start AI-2");
        [self tileWasClicked: [AIMove objectAtIndex:0]];
        if([AIMove count] > 0)
            [AIMove removeObjectAtIndex:0];
        timerCt = 3;
        [self setUserInteractionEnabled:NO];
        //NSLog(@"End AI-2");
    }
    else if(timerCt == 3){
        //NSLog(@"Start AI-3");
        highlightedTileList = AIMove;
        if([highlightedTileList count] == 0){
            [self sendMessage:[[@"Player " stringByAppendingString:[NSString stringWithFormat:@"%i",turn+1] ]stringByAppendingString: @" passes this turn." ]];
        }
        else
            for(int i = 0; i < [highlightedTileList count]; i++){
                [[highlightedTileList objectAtIndex:i] highlight];
            }
        [self setUserInteractionEnabled:NO];
        timerCt = 4;
        //NSLog(@"End AI-3");
    }
    else{
        //NSLog(@"Start AI-4");
        [timer invalidate];
        [self setUserInteractionEnabled:YES];
        [self endTurn];
        //NSLog(@"End AI-4");
    }
}

- (void) endTurn
{
    BOOL winner = NO;
    
    int addScore = 0;
    for(int i = 0; i < [highlightedTileList count]; i++){
        addScore += ((Tile*)[highlightedTileList objectAtIndex:i]).value;
        [[highlightedTileList objectAtIndex:i] unhighlight];
        [[highlightedTileList objectAtIndex:i] increment: -1*((Tile*)[highlightedTileList objectAtIndex:i]).value];
    }
    [highlightedTileList removeAllObjects];
    
    if(turn <= [score count])
        [score replaceObjectAtIndex:turn withObject:[NSNumber numberWithInt:[[score objectAtIndex:turn] intValue] + addScore]]; //score += addScore
    else
        [score insertObject:[NSNumber numberWithInt:addScore] atIndex:turn];
    
    if([[score objectAtIndex:turn] intValue] >= maxScore)
        winner = YES;

    if(!winner){
        turn++;
        if(turn >= [score count])
            turn %= [score count];
        NSLog(@"Turn complete.");
        [self startTurn];
        //[[NSNotificationCenter defaultCenter] postNotificationName: @"MultiplayerGame" object:nil];
    }
    if(winner){
        for(int i = 0; i < [score count]; i++)
            [[scoreLabels objectAtIndex:i] setText: [@"Player " stringByAppendingString: [[NSString stringWithFormat:@"%i",i+1] stringByAppendingString: [@": " stringByAppendingString: [[score objectAtIndex:i] stringValue]]]]];
        [self sendMessage: [[@"Player " stringByAppendingString:[NSString stringWithFormat:@"%i",turn+1]] stringByAppendingString:@" is the winner!"]];
        [self setUserInteractionEnabled:NO];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
