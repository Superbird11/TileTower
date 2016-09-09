//
//  WirelessViewController.m
//  Tile Tower
//
//  Created by Louis Jacobowitz on 1/10/15.
//  Copyright (c) 2015 Louis Jacobowitz. All rights reserved.
//

#import "WirelessViewController.h"
#import "AppDelegate.h"

@interface WirelessViewController ()

@property (strong, nonatomic) AppDelegate *appDelegate;

@end

@implementation WirelessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//Initializing the appDelegate and mcManager
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [_appDelegate.mcManager setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
    [_appDelegate.mcManager advertiseSelf:toggleAdvertisingSwitch.isOn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateWithNotification:)
                                                 name:@"MCDidChangeStateNotification"
                                               object:nil];
    
//Configuring the display, because pooh to storyboards
    
    [self.view setBackgroundColor: [UIColor lightGrayColor]];
    nameInputTextField = [[UITextField alloc] initWithFrame: CGRectMake(8,110,self.view.frame.size.width - 16, 40)];
    [nameInputTextField setBorderStyle: UITextBorderStyleRoundedRect];
    [nameInputTextField setPlaceholder:@"This device's name, to display to others"];
    [nameInputTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [nameInputTextField setFont: [UIFont systemFontOfSize:15]];
    [nameInputTextField setDelegate:self];
    
    visibleToOthersLabel = [[UILabel alloc] initWithFrame: CGRectMake(self.view.frame.size.width - 200, 66, self.view.frame.size.width - 16, 40)];
    [visibleToOthersLabel setText:@"Visible to others?"];
    [visibleToOthersLabel setFont: [UIFont systemFontOfSize: 15]];
    
    toggleAdvertisingSwitch = [[UISwitch alloc] initWithFrame: CGRectMake(self.view.frame.size.width - 60,66,30,15)]; //let's see how this works. I'm assuming that it only overrides the latter two.
    
    displayDefaultButton = [[UIButton alloc] initWithFrame: CGRectMake(self.view.frame.size.width / 2 - 100, 140, 200, 40)];
    [displayDefaultButton.titleLabel setTextColor: [UIColor blackColor]];
    [displayDefaultButton setTitle:@"Browse for Devices" forState: UIControlStateNormal];
    
    disconnectButton = [[UIButton alloc] initWithFrame: CGRectMake(self.view.frame.size.width / 2 - 50, self.view.frame.size.height - 50, 100, 40)];
    [disconnectButton.titleLabel setTextColor: [UIColor blackColor]];
    [disconnectButton setTitle:@"Disconnect" forState: UIControlStateNormal];
    
    gotoLobby = [[UIBarButtonItem alloc] initWithTitle:@"Goto Game Lobby" style:UIBarButtonItemStylePlain target:self action:@selector(gotoGameLobby)];
    self.navigationItem.rightBarButtonItem = gotoLobby;
    
    [self.view addSubview: nameInputTextField];
    [self.view addSubview: visibleToOthersLabel];
    [self.view addSubview: displayDefaultButton];
    [self.view addSubview: toggleAdvertisingSwitch];
    [self.view addSubview: disconnectButton];
    
    [displayDefaultButton addTarget:self action: @selector(browseForDevices:) forControlEvents: UIControlEventTouchUpInside];
    [disconnectButton addTarget:self action:@selector(disconnect:) forControlEvents:UIControlEventTouchUpInside];
    [toggleAdvertisingSwitch addTarget: self action: @selector(toggleVisibility:) forControlEvents: UIControlEventValueChanged];
    
    _appDelegate.mcManager.myPlayerNumber = 0;
    
    otherDevicesTableView = [[UITableView alloc] initWithFrame: CGRectMake(8,180,self.view.frame.size.width - 16, self.view.frame.size.height - 312)];
    
//Dealing with the table view
    connectedDevices = [[NSMutableArray alloc] initWithObjects: @"Host",nil];
    [otherDevicesTableView setDelegate: self];
    [otherDevicesTableView setDataSource: self];
    
    [self.view addSubview: otherDevicesTableView];
    
    
}

- (void) gotoGameLobby
{
    NSLog([NSString stringWithFormat:@"%i",_appDelegate.mcManager.myPlayerNumber]);
    //if(toggleAdvertisingSwitch.isOn){
    if([nameInputTextField.text length] > 0){
        [connectedDevices replaceObjectAtIndex:0 withObject: nameInputTextField.text];
    }
    
    gameLobby = [[WirelessGameLobbyVC alloc] initWithPlayers: connectedDevices];
    if(toggleAdvertisingSwitch.isOn)
        [gameLobby setIsHost:YES];
    else
        [gameLobby setIsHost:NO];
    
    [[self navigationController] pushViewController:gameLobby animated:YES];
    //}
    //else{
        
    //}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) browseForDevices: (id) sender
{
    [_appDelegate.mcManager setupMCBrowser];
    [_appDelegate.mcManager.browser setDelegate: self];
    [self presentViewController: _appDelegate.mcManager.browser animated:YES completion:nil];
}

- (void) toggleVisibility: (id) sender
{
    [_appDelegate.mcManager advertiseSelf:toggleAdvertisingSwitch.isOn];
}

- (void) disconnect: (id) sender
{
    [_appDelegate.mcManager.session disconnect];
    
    nameInputTextField.enabled = YES;
    
    [connectedDevices removeAllObjects];
    [otherDevicesTableView reloadData];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    _appDelegate.mcManager.peerID = nil;
    _appDelegate.mcManager.session = nil;
    _appDelegate.mcManager.browser = nil;
    
    if ([toggleAdvertisingSwitch isOn]) {
        [_appDelegate.mcManager.advertiser stop];
    }
    _appDelegate.mcManager.advertiser = nil;
    
    
    [_appDelegate.mcManager setupPeerAndSessionWithDisplayName:textField.text];
    [_appDelegate.mcManager setupMCBrowser];
    [_appDelegate.mcManager advertiseSelf:toggleAdvertisingSwitch.isOn];
    
    return YES;
}

-(void)peerDidChangeStateWithNotification:(NSNotification *)notification
{
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
    
    if (state != MCSessionStateConnecting) {
        if (state == MCSessionStateConnected) {
            [connectedDevices addObject:peerDisplayName];
            NSString* sent = @"setPN";
            sent = [sent stringByAppendingFormat:@"%i",connectedDevices.count-1];
            [self sendState:sent toPeer:peerID];
            //essentially saying "Okay, I register that you're here. You are now player __.
        }
        else if (state == MCSessionStateNotConnected){
            if ([connectedDevices count] > 0) {
                /*
                 int indexOfPeer = [connectedDevices indexOfObject:peerDisplayName];
                [connectedDevices removeObjectAtIndex:indexOfPeer];
                 */
                [connectedDevices removeObject: peerDisplayName];
            }
            
            [otherDevicesTableView reloadData];
            
            BOOL peersExist = ([[_appDelegate.mcManager.session connectedPeers] count] == 0);
            [disconnectButton setEnabled:!peersExist];
            [nameInputTextField setEnabled:peersExist];
        }
    }
}

- (void) sendState: (NSString*) str toPeer: (MCPeerID*) peer;
{
    if(_appDelegate.mcManager.connected && toggleAdvertisingSwitch.isOn){
        NSData *dataToSend = [str dataUsingEncoding: NSUTF8StringEncoding];
        NSArray *allPeers = [NSArray arrayWithObject:peer];
        NSError *error;
        
        [_appDelegate.mcManager.session sendData:dataToSend
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
    if(!toggleAdvertisingSwitch.isOn){
        NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
        NSString *action = [[NSString alloc] initWithData: receivedData encoding:NSUTF8StringEncoding];
        
        if([action containsString:@"setPN"]){
            NSString* valueStr = [action substringFromIndex:5];
            //[self changeMaxScore];
            _appDelegate.mcManager.myPlayerNumber = [valueStr intValue];
        }
    }
}

- (void) browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [_appDelegate.mcManager.browser dismissViewControllerAnimated:YES completion:nil];
}

- (void) browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [_appDelegate.mcManager.browser dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [connectedDevices count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }
    
    cell.textLabel.text = [connectedDevices objectAtIndex:indexPath.row];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
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
