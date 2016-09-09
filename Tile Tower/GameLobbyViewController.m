//
//  GameLobbyViewController.m
//  Tile Tower
//
//  Created by Louis Jacobowitz on 1/14/15.
//  Copyright (c) 2015 Louis Jacobowitz. All rights reserved.
//

#import "GameLobbyViewController.h"

@implementation GameLobbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setTitle:@"Game Setup"];
    
    container = [[UILabel alloc] initWithFrame:CGRectMake(0,150,self.view.frame.size.width,self.view.frame.size.height-150)];
    [container setCenter:self.view.center];
    [container setUserInteractionEnabled:YES];
    int frameX = container.frame.size.width;
    //int frameY = container.frame.size.height;
    
    gameVC = [[GameViewController alloc] init];
    
    //Player Number Label
    playerNumber = 2;
    playerNumberLabel = [[UILabel alloc] initWithFrame: CGRectMake(5,10,140,20)];
    [playerNumberLabel setFont: [UIFont systemFontOfSize:14]];
    [playerNumberLabel setText:@"Number of Players: "];
    playerNumberSegmentedControl = [[UISegmentedControl alloc] initWithItems: [NSArray arrayWithObjects:
                                                                               @"2",
                                                                               @"3",
                                                                               @"4",nil]];
    [playerNumberSegmentedControl setFrame: CGRectMake(playerNumberLabel.frame.origin.x + playerNumberLabel.frame.size.width + 5, playerNumberLabel.frame.origin.y, frameX - 10 - (playerNumberLabel.frame.origin.x + playerNumberLabel.frame.size.width),20)];
    playerNumberSegmentedControl.selectedSegmentIndex = 0;
    [playerNumberSegmentedControl addTarget:self action:@selector(changePlayerNumber) forControlEvents:UIControlEventValueChanged];
    
    //AI
    AILabel0 = [[UILabel alloc] initWithFrame:CGRectMake(5,50,60,20)];
    [AILabel0 setFont: [UIFont systemFontOfSize:14]];
    [AILabel0 setText: @"Player 1: "];
    AILabel1 = [[UILabel alloc] initWithFrame:CGRectMake(5,80,60,20)];
    [AILabel1 setFont: [UIFont systemFontOfSize:14]];
    [AILabel1 setText: @"Player 2: "];
    AILabel2 = [[UILabel alloc] initWithFrame:CGRectMake(5,110,60,20)];
    [AILabel2 setFont: [UIFont systemFontOfSize:14]];
    [AILabel2 setText: @"Player 3: "];
    AILabel3 = [[UILabel alloc] initWithFrame:CGRectMake(5,140,60,20)];
    [AILabel3 setFont: [UIFont systemFontOfSize:14]];
    [AILabel3 setText: @"Player 4: "];
    
    AIControl0 = [[UISegmentedControl alloc] initWithItems: [NSArray arrayWithObjects:@"Human",@"AI 1", @"AI 2", @"AI 3",nil]];
    AIControl0.selectedSegmentIndex = 0;
    [AIControl0 setFrame: CGRectMake(AILabel0.frame.origin.x+AILabel0.frame.size.width+5,AILabel0.frame.origin.y,frameX-(AILabel0.frame.origin.x+AILabel0.frame.size.width+10),20)];
    AIControl1 = [[UISegmentedControl alloc] initWithItems: [NSArray arrayWithObjects:@"Human",@"AI 1",@"AI 2",@"AI 3",nil]];
    AIControl1.selectedSegmentIndex = 0;
    [AIControl1 setFrame: CGRectMake(AILabel1.frame.origin.x+AILabel1.frame.size.width+5,AILabel1.frame.origin.y,frameX-(AILabel1.frame.origin.x+AILabel1.frame.size.width+10),20)];
    AIControl2 = [[UISegmentedControl alloc] initWithItems: [NSArray arrayWithObjects:@"Human",@"AI 1",@"AI 2",@"AI 3",nil]];
    AIControl2.selectedSegmentIndex = 0;
    [AIControl2 setFrame: CGRectMake(AILabel2.frame.origin.x+AILabel2.frame.size.width+5,AILabel2.frame.origin.y,frameX-(AILabel2.frame.origin.x+AILabel2.frame.size.width+10),20)];
    AIControl3 = [[UISegmentedControl alloc] initWithItems: [NSArray arrayWithObjects:@"Human",@"AI 1",@"AI 2",@"AI 3",nil]];
    AIControl3.selectedSegmentIndex = 0;
    [AIControl3 setFrame: CGRectMake(AILabel3.frame.origin.x+AILabel3.frame.size.width+5,AILabel3.frame.origin.y,frameX-(AILabel3.frame.origin.x+AILabel3.frame.size.width+10),20)];
    
    //Max Score
    maxScoreLabel = [[UILabel alloc] initWithFrame: CGRectMake(5,180,110,20)];
    [maxScoreLabel setText:@"Score limit: 100"];
    [maxScoreLabel setFont: [UIFont systemFontOfSize:14]];
    incrementMaxScore = [[UIStepper alloc] initWithFrame: CGRectMake(maxScoreLabel.frame.origin.x+maxScoreLabel.frame.size.width + 15,maxScoreLabel.frame.origin.y-5,frameX-10-(maxScoreLabel.frame.origin.x+playerNumberLabel.frame.size.width),20)];
    //[incrementMaxScore setCenter: CGPointMake(120,210)];
    incrementMaxScore.value = 100;
    incrementMaxScore.minimumValue = 10;
    incrementMaxScore.maximumValue = 10000;
    [self changeMaxScore];
    [incrementMaxScore addTarget:self action:@selector(changeMaxScore) forControlEvents:UIControlEventValueChanged];
    
    
    //[startGameButton removeFromSuperview];
    startGameButton = [[UIButton alloc] init];
    [startGameButton setFrame: CGRectMake(frameX/2-75,210,150,75)];
    [startGameButton setImage: [UIImage imageNamed: @"startGameButton.png"] forState: UIControlStateNormal];
    [startGameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startGameButton setTitle:@"Start Game" forState:UIControlStateNormal];
    [startGameButton addTarget:self action:@selector(newGame) forControlEvents:UIControlEventTouchUpInside];
    
    continueGameButton = [[UIBarButtonItem alloc] initWithTitle:@"Continue Game" style: UIBarButtonItemStylePlain target:self action:@selector(continueGame)];
    
    [self.view addSubview: container];
    [container addSubview: playerNumberLabel];
    [container addSubview: playerNumberSegmentedControl];
    [container addSubview: maxScoreLabel];
    [container addSubview: incrementMaxScore];
    [container addSubview: startGameButton];
    [container addSubview: AILabel0];
    [container addSubview: AILabel1];
    //[container addSubview: AILabel2];
    //[container addSubview: AILabel3];
    [container addSubview: AIControl0];
    [container addSubview: AIControl1];
    //[container addSubview: AIControl2];
    //[container addSubview: AIControl3];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray*) setPlayerList
{
    NSMutableArray* list = [[NSMutableArray alloc] init];
    for(int i = 1; i <= playerNumber; i++)
        [list addObject: [@"Player " stringByAppendingFormat:@"%i",i]];
    
    return list;
}

- (void) newGame
{
    NSArray* playerList = [self setPlayerList];
    
    [gameVC configurePlayers1: AIControl0.selectedSegmentIndex player2:AIControl1.selectedSegmentIndex player3: AIControl2.selectedSegmentIndex player4: AIControl3.selectedSegmentIndex];
    [gameVC startNewGameWithPlayers:playerList andLimit:maxScore withVC:self];
    [self.navigationController pushViewController:gameVC animated:YES];
    self.navigationItem.rightBarButtonItem = continueGameButton;
}

- (void) continueGame
{
    [self.navigationController pushViewController:gameVC animated:YES];
    [gameVC unpauseGame];
}

- (void) changeMaxScore
{
    maxScore = incrementMaxScore.value;
    [maxScoreLabel setText:[@"Score Limit: " stringByAppendingString:[NSString stringWithFormat:@"%i",maxScore]]];
}

- (void) changePlayerNumber
{
    playerNumber = playerNumberSegmentedControl.selectedSegmentIndex+2;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
