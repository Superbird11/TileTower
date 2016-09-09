//
//  WirelessViewController.h
//  Tile Tower
//
//  Created by Louis Jacobowitz on 1/10/15.
//  Copyright (c) 2015 Louis Jacobowitz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "WirelessGameLobbyVC.h"

@interface WirelessViewController : UIViewController <MCBrowserViewControllerDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UITextField *nameInputTextField;
    UIButton *displayDefaultButton;
    UISwitch *toggleAdvertisingSwitch;
    UITableView *otherDevicesTableView;
    UIButton *disconnectButton;
    
    UILabel *visibleToOthersLabel;
    
    WirelessGameLobbyVC *gameLobby;
    
    NSMutableArray *connectedDevices;
    UIBarButtonItem *gotoLobby;
}

- (void) browseForDevices: (id) sender;
- (void) toggleVisibility: (id) sender;
- (void) disconnect: (id) sender;

- (void) gotoGameLobby;

-(void)peerDidChangeStateWithNotification:(NSNotification *)notification;


@end
