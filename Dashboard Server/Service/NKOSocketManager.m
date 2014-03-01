//
//  NKOSocketManager.m
//  Dashboard Server
//
//  Created by Carlos Vidal Pallín on 28/02/2014.
//  Copyright (c) 2014 nakioStudio. All rights reserved.
//

#import "NKOSocketManager.h"
#import "NKOSocketDefinitions.h"

#import "NKOAppleScriptManager.h"
#import "NKOAppDiscoverer.h"
#import "NKOBonjourAPI.h"

#import "NSObject+SBJSON.h"
#import "NSString+SBJSON.h"

@interface NKOSocketManager()

@property (nonatomic, strong) NKOAppleScriptManager *appleScriptManager;
@property (nonatomic, strong) NKOAppDiscoverer *appDiscoverer;
@property (nonatomic, assign) NSUInteger appsSent;

@property (nonatomic, strong) NSArray *deviceApps;

@end

@implementation NKOSocketManager

+ (NKOSocketManager *)sharedManager
{
    static dispatch_once_t once;
    static NKOSocketManager * sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    
    if (self != nil){
        
    }
    
    return self;
}

- (void)startServer
{
    [[NKOBonjourAPI sharedInstance] startServerWithMessageReceivedBlock:[self _bonjourMessageReceivedBlock]];
}

#pragma mark - Private methods
- (void)_sendInfoForAppAtIndex:(NSUInteger)index
{
    if (index == 0){
        self.appDiscoverer = nil;
    }
    
    if (self.appDiscoverer.appNames.count > index){
        if (![self.deviceApps containsObject:self.appDiscoverer.appNames[index]]){
            NSString *appInfo = [self.appDiscoverer jsonStringForAppAtIndex:index];
            
            if (appInfo != nil){
                [[NKOBonjourAPI sharedInstance] sendMessage:appInfo];
            }
        }
        else{
            self.appsSent++;
            [self _sendInfoForAppAtIndex:self.appsSent];
        }
    }
}

- (void)_triggerCommandWithEvent:(NKOTriggerCommandSocketEvent*)event
{
    if (event == nil){
        return;
    }
    
    [self.appleScriptManager launchKeyCombination:event.keyCombination toAppWithName:event.appName];
}

#pragma mark - Lazy loading
- (NKOBonjourAPIMessageReceivedBlock)_bonjourMessageReceivedBlock
{
    NKOBonjourAPIMessageReceivedBlock messageReceivedBlock = ^(NSString* message){
        NSString *messageParsed = [message substringWithRange:NSMakeRange(0, message.length-1)];
        
        NSLog(@"Message received %@", message);
        
        NSDictionary *eventDictionary = [messageParsed JSONValue];
        
        if (eventDictionary != nil && eventDictionary[@"event"] != nil){
            NSString *eventName = eventDictionary[@"event"];
            if ([eventName isEqualToString:NKOGetAppsEventName]){
                self.appsSent = 0;
                self.deviceApps = eventDictionary[@"apps"];
                [self _sendInfoForAppAtIndex:self.appsSent];
            }
            else if ([eventName isEqualToString:NKOGetAppsResponseEventName]){
                self.appsSent++;
                [self _sendInfoForAppAtIndex:self.appsSent];
            }
            else if ([eventName isEqualToString:NKOTriggerCommandEventName]){
                NKOTriggerCommandSocketEvent *triggerCommandEvent = [NKOTriggerCommandSocketEvent createFromDictionary:eventDictionary];
                [self _triggerCommandWithEvent:triggerCommandEvent];
            }
        }
    };
    
    return messageReceivedBlock;
}

- (NKOAppDiscoverer*)appDiscoverer
{
    if (self->_appDiscoverer == nil){
        self->_appDiscoverer = [[NKOAppDiscoverer alloc] init];
    }
    
    return self->_appDiscoverer;
}

- (NKOAppleScriptManager*)appleScriptManager
{
    if (self->_appleScriptManager == nil){
        self->_appleScriptManager = [[NKOAppleScriptManager alloc] init];
    }
    
    return self->_appleScriptManager;
}

@end
