//
//  NKOAppDiscoverer.m
//  Dashboard Server
//
//  Created by Carlos Vidal on 28/02/2014.
//  Copyright (c) 2014 nakioStudio. All rights reserved.
//

#import "NKOAppDiscoverer.h"

#import "NSImage+NKO.h"
#import "NSData+Base64.h"
#import "NSObject+SBJSON.h"

@interface NKOAppDiscoverer()

@end

@implementation NKOAppDiscoverer

- (id)init
{
    self = [super init];
    
    if (self != nil){
        self->_appNames = [self _appNames];
    }
    
    return self;
}

#pragma mark - Public methods
- (NSString*)jsonStringForAppAtIndex:(NSUInteger)index
{
    if (index < self.appNames.count){
        NSString *appName = self.appNames[index];
        
        NSDictionary *appDict = @{@"event":@"appInfo",
                                  @"name":appName,
                                  @"icon":[self _iconBase64ForAppWithName:appName]};
        
        return [appDict JSONRepresentation];
    }
    else{
        return nil;
    }
}

#pragma mark - Private methods
- (NSArray*)_appNames
{
    NSArray *filesOnAppsDire = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/Applications" error:nil];
    NSArray *appFiles = [filesOnAppsDire filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.app'"]];
    
    NSMutableArray *appNames = [NSMutableArray array];
    
    for (NSString *appFile in appFiles){
        [appNames addObject:[appFile stringByReplacingOccurrencesOfString:@".app" withString:@""]];
    }
    
    return appNames;
}

- (NSString*)_iconBase64ForAppWithName:(NSString*)appName
{
    NSImage *appIconImage = [[NSWorkspace sharedWorkspace] iconForFile:[NSString stringWithFormat:@"/Applications/%@.app",appName]];
    NSImage *appIconScaledImage = [appIconImage scaleImageToSize:CGSizeMake(80.f, 80.f)];
    
    CGImageRef imageConext = [appIconScaledImage CGImageForProposedRect:nil context:nil hints:nil];
    
    NSBitmapImageRep *bitmapRepresentation = [[NSBitmapImageRep alloc] initWithCGImage:imageConext];
    [bitmapRepresentation setSize:appIconScaledImage.size];
    
    NSData *imgData = [bitmapRepresentation representationUsingType:NSPNGFileType properties:nil];
    
    return [imgData base64EncodedString];
}

@end
