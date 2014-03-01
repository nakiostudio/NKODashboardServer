//
//  NKOAppleScriptManager.h
//  Dashboard Server
//
//  Created by Carlos Vidal on 01/03/2014.
//  Copyright (c) 2014 nakioStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKOAppleScriptManager : NSObject

- (void)launchKeyCombination:(NSString*)keyCombination toAppWithName:(NSString*)appName;

@end
