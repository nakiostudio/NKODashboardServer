//
//  NKOMainMenuController.h
//  Dashboard Server
//
//  Created by Carlos Vidal on 12/03/2014.
//  Copyright (c) 2014 nakioStudio. All rights reserved.
//

#import <Cocoa/Cocoa.h>


typedef void (^NKOMainMenuPreferencesItemSelectedBlock)();
typedef void (^NKOMainMenuDisableServerItemSelectedBlock)(BOOL disableServer);

@interface NKOMainMenuController : NSMenu

@property (nonatomic, strong) NKOMainMenuPreferencesItemSelectedBlock preferencesItemSelectedBlock;
@property (nonatomic, strong) NKOMainMenuDisableServerItemSelectedBlock disableServerItemSelectedBlock;

@end
