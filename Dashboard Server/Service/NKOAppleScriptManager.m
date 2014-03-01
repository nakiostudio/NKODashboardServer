//
//  NKOAppleScriptManager.m
//  Dashboard Server
//
//  Created by Carlos Vidal on 01/03/2014.
//  Copyright (c) 2014 nakioStudio. All rights reserved.
//

#import "NKOAppleScriptManager.h"

@implementation NKOAppleScriptManager

#pragma mark - Public methods
- (void)launchKeyCombination:(NSString*)keyCombination toAppWithName:(NSString*)appName
{
    NSString * output = nil;
    NSString * processErrorDescription = nil;
    
    [self _runProcessAsAdministrator:@"/usr/bin/id"
                       withArguments:[NSArray arrayWithObjects:@"-un", nil]
                              output:&output
                    errorDescription:&processErrorDescription
                           andScript:[self _scriptWithKeyCombination:keyCombination andAppName:appName]];
}

#pragma mark - Private methods
- (NSString*)_scriptWithKeyCombination:(NSString*)keyCombination andAppName:(NSString*)appName
{
    NSString *activateAppScript = [NSString stringWithFormat:@"tell application \"%@\"\nactivate\nend tell\n", appName];
    NSString *keyCombinationScript = [NSString stringWithFormat:@"tell application \"System Events\"\n%@\nend tell", keyCombination];
    
    return [activateAppScript stringByAppendingString:keyCombinationScript];
}

- (BOOL)_runProcessAsAdministrator:(NSString*)scriptPath withArguments:(NSArray*)arguments output:(NSString**)output
                 errorDescription:(NSString**)errorDescription andScript:(NSString*)script{
    
    NSDictionary *errorInfo = [NSDictionary new];
    
    NSAppleScript *appleScript = [[NSAppleScript new] initWithSource:script];
    NSAppleEventDescriptor * eventResult = [appleScript executeAndReturnError:&errorInfo];
    
    // Check errorInfo
    if (! eventResult)
    {
        // Describe common errors
        *errorDescription = nil;
        if ([errorInfo valueForKey:NSAppleScriptErrorNumber])
        {
            NSNumber * errorNumber = (NSNumber *)[errorInfo valueForKey:NSAppleScriptErrorNumber];
            if ([errorNumber intValue] == -128)
                *errorDescription = @"The administrator password is required to do this.";
        }
        
        // Set error message from provided message
        if (*errorDescription == nil)
        {
            if ([errorInfo valueForKey:NSAppleScriptErrorMessage])
                *errorDescription =  (NSString *)[errorInfo valueForKey:NSAppleScriptErrorMessage];
        }
        
        return NO;
    }
    else
    {
        // Set output to the AppleScript's output
        *output = [eventResult stringValue];
        
        return YES;
    }
}

@end
