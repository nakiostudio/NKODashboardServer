//
//  NSUserDefaults+NKO.h
//  Dashboard Server
//
//  Created by Carlos Vidal on 07/03/2014.
//  Copyright (c) 2014 nakioStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (NKO)

- (void)nko_setSecretKeyWithString:(NSString*)key;
- (NSString*)nko_secretKeyWithString;

@end
