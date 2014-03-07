//
//  NSUserDefaults+NKO.m
//  Dashboard Server
//
//  Created by Carlos Vidal on 07/03/2014.
//  Copyright (c) 2014 nakioStudio. All rights reserved.
//

#import "NSUserDefaults+NKO.h"
#import "NSString+NKO.h"

NSString *const NKOSecretKeyUserDefaultName = @"XfSKBp";

@implementation NSUserDefaults (NKO)

- (void)nko_setSecretKeyWithString:(NSString*)key
{
    [self setObject:[key nko_md5] forKey:NKOSecretKeyUserDefaultName];
}

- (NSString*)nko_secretKeyWithString
{
    return [self objectForKey:NKOSecretKeyUserDefaultName];
}

@end
