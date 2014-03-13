//
//  NKOAppDelegate.m
//  Dashboard Server
//
//  Created by Carlos Vidal Pallín on 26/02/2014.
//  Copyright (c) 2014 nakioStudio. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "NKOAppDelegate.h"

#import "NKOBonjourAPI.h"
#import "NKOSocketManager.h"
#import "NSUserDefaults+NKO.h"

#import "NKOMainMenuController.h"

@interface NKOAppDelegate()

@property (nonatomic, strong) NSStatusItem *statusBar;

@property (nonatomic, weak) IBOutlet NKOMainMenuController *mainMenu;
@property (nonatomic, weak) IBOutlet NSWindow *preferencesWindow;

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
    self.mainMenu.preferencesItemSelectedBlock = [self _preferencesItemSelectedBlock];
    self.mainMenu.disableServerItemSelectedBlock = [self _disableServerItemSelectedBlock];
    
    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.statusBar.title = @"Dashboard";
    self.statusBar.highlightMode = YES;
    self.statusBar.menu = self.mainMenu;
}

#pragma mark - Lazy loading
- (NKOMainMenuPreferencesItemSelectedBlock)_preferencesItemSelectedBlock
{
    __weak NKOAppDelegate *weakSelf = self;
    
    NKOMainMenuPreferencesItemSelectedBlock itemSelectedBlock = ^(){
        [weakSelf.preferencesWindow makeKeyAndOrderFront:NSApp];
    };
    
    return itemSelectedBlock;
}

- (NKOMainMenuDisableServerItemSelectedBlock)_disableServerItemSelectedBlock
{
    NKOMainMenuDisableServerItemSelectedBlock itemSelectedBlock = ^(BOOL disabled){
        if (disabled){
            [[NKOBonjourAPI sharedInstance] deregisterServer];
        }
        else{
            [[NKOBonjourAPI sharedInstance] registerServer];
        }
    };
    
    return itemSelectedBlock;
}

@end
