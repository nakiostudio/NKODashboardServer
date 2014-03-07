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
#import "NSUserDefaults+NKO.h"

@interface NKOAppDelegate()

@property (nonatomic, strong) NSStatusItem *statusBar;
@property (nonatomic, weak) IBOutlet NSMenu *mainMenu;

@end

@implementation NKOAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    if ([[NSUserDefaults standardUserDefaults] nko_secretKeyWithString] == nil){
        [[NSUserDefaults standardUserDefaults] nko_setSecretKeyWithString:@"1234"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else{
        NSLog(@"Key %@", [[NSUserDefaults standardUserDefaults] nko_secretKeyWithString]);
    }
    
    [[NKOSocketManager sharedManager] startServer];
}

- (void)awakeFromNib
{
    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    self.statusBar.title = @"Dashboard";
    
    self.statusBar.menu = self.mainMenu;
    self.statusBar.highlightMode = YES;
}

@end
