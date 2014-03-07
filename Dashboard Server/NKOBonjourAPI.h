//
//  NKOBonjourAPI.h
//  Dashboard Server
//
//  Created by Carlos Vidal Pallín on 26/02/2014.
//  Copyright (c) 2014 nakioStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^NKOBonjourAPIMessageReceivedBlock)(NSString *message);

@interface NKOBonjourAPI : NSObject

+ (NKOBonjourAPI *)sharedInstance;
    
- (void)startServerWithMessageReceivedBlock:(NKOBonjourAPIMessageReceivedBlock)messageReceivedBlock;
- (void)connectToService:(NSNetService*)service;
- (void)sendMessage:(NSString*)message;
- (void)disconnect;

@end
