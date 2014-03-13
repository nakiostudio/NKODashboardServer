//
//  NKOMainMenuController.m
//  Dashboard Server
//
//  Created by Carlos Vidal on 12/03/2014.
//  Copyright (c) 2014 nakioStudio. All rights reserved.
//

#import "NKOMainMenuController.h"

NSString *const NKOMainMenuDisableServerText    = @"Disable server";
NSString *const NKOMainMenuEnableServerText     = @"Enable server";

@interface NKOMainMenuController()

@property (weak) IBOutlet NSMenuItem *disableServerMenuItem;
@property (weak) IBOutlet NSMenuItem *preferencesMenuItem;

@end

@implementation NKOMainMenuController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.preferencesMenuItem setEnabled:YES];
    [self.preferencesMenuItem setTarget:self];
    [self.preferencesMenuItem setAction:@selector(_showPreferencesMenu:)];
    
    [self.disableServerMenuItem setEnabled:YES];
    [self.disableServerMenuItem setTarget:self];
    [self.disableServerMenuItem setAction:@selector(_toggleServerStatus:)];
}

#pragma mark - Private methods
- (void)_toggleServerStatus:(id)sender
{
    BOOL disable;
    
    if ([self.disableServerMenuItem.title isEqualToString:NKOMainMenuDisableServerText]){
        [self.disableServerMenuItem setTitle:NKOMainMenuEnableServerText];
        disable = YES;
    }
    else{
        [self.disableServerMenuItem setTitle:NKOMainMenuDisableServerText];
        disable = NO;
    }
    
    if (self.disableServerItemSelectedBlock != nil){
        self.disableServerItemSelectedBlock(disable);
    }
}

- (void)_showPreferencesMenu:(id)sender
{
    if (self.preferencesItemSelectedBlock != nil){
        self.preferencesItemSelectedBlock();
    }
}

@end
