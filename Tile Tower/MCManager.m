//
//  MCManager.m
//  Tile Tower
//
//  Created by Louis Jacobowitz on 1/10/15.
//  Copyright (c) 2015 Louis Jacobowitz. All rights reserved.
//

#import "MCManager.h"

@implementation MCManager

- (id) init
{
    self = [super init];
    
    if( self ){
        _peerID = nil;
        _advertiser = nil;
        _browser = nil;
        _session = nil;
        _connected = false;
    }
    
    return self;
}

-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName
{
    _peerID = [[MCPeerID alloc] initWithDisplayName:displayName];
    _session = [[MCSession alloc] initWithPeer: _peerID];
    _session.delegate = self;
    
    //_myName = displayName;
}

-(void)setupMCBrowser
{
    _browser = [[MCBrowserViewController alloc] initWithServiceType: @"play-tiletower" session: _session];
}

-(void)advertiseSelf:(BOOL)shouldAdvertise
{
    //Precondition: shouldAdvertise has a value
    if(shouldAdvertise){
        _advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"play-tiletower" discoveryInfo:nil session:_session];
        [_advertiser start];
    }
    else{
        [_advertiser stop];
        _advertiser = nil;
    }
}

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    NSDictionary *dict = @{@"peerID": peerID,
                           @"state" : [NSNumber numberWithInt:state]
                           };
    if(state == MCSessionStateConnected)
        _connected = YES;
    //else
    //    _connected = NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidChangeStateNotification"
                                                        object:nil
                                                      userInfo:dict];
}


-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    NSDictionary *dict = @{@"data": data,
                            @"peerID": peerID
                            };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidReceiveDataNotification"
                                                        object:nil
                                                        userInfo:dict];
}


-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    
}


-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
    
}


-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    
}

@end
