//
//  NSDictionary+NKO.m
//  Dashboard Server
//
//  Created by Carlos Vidal on 07/03/2014.
//  Copyright (c) 2014 nakioStudio. All rights reserved.
//

#import "NSUserDefaults+NKO.h"
#import "NSDictionary+NKO.h"
#import "NSData+Base64.h"
#import "NSString+NKO.h"

@implementation NSDictionary (NKO)

- (BOOL)nko_isTrusted
{
    if (self[@"event"] != nil && self[@"token"] != nil && self[@"timestamp"] != nil){
        if ([[self nko_authKey] isEqualToString:self[@"token"]]){
            return YES;
        }
    }
    
    return NO;
}

- (NSString*)nko_authKey
{
    if (self[@"event"] != nil && self[@"timestamp"] != nil){
        NSString *eventKey = [NSString stringWithFormat:@"%@%@", self[@"event"], [self[@"timestamp"] nko_md5]];
        NSString *timestampKey = [NSString stringWithFormat:@"%@%@", self[@"timestamp"], [self[@"event"] nko_md5]];
        
        NSString *allTogetherKey = [[NSString stringWithFormat:@"%@%@%@%@",eventKey, [timestampKey nko_md5], timestampKey, [eventKey nko_md5]] nko_md5];
        
        NSString *token = [NSString nko_hmacsha1:allTogetherKey secret:[[NSUserDefaults standardUserDefaults] nko_secretKeyWithString]];
        
        return token;
    }
    
    return nil;
}

- (NSDictionary*)nko_authDictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:self];
    
    NSString *authKey = [self nko_authKey];
    
    if (authKey != nil){
        [dictionary setObject:authKey forKey:@"token"];
    }
    
    return dictionary;
}

@end
