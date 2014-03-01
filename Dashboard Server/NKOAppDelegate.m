//
//  NKOAppDelegate.m
//  Dashboard Server
//
//  Created by Carlos Vidal Pallín on 26/02/2014.
//  Copyright (c) 2014 nakioStudio. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "NKOAppDelegate.h"
#import "NKOSocketManager.h"

@interface NKOAppDelegate()

@end

@implementation NKOAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[NKOSocketManager sharedManager] startServer];
}

@end
