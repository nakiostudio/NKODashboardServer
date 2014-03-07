//
//  NSDictionary+NKO.h
//  Dashboard Server
//
//  Created by Carlos Vidal on 07/03/2014.
//  Copyright (c) 2014 nakioStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NKO)

- (BOOL)nko_isTrusted;
- (NSString*)nko_authKey;
- (NSDictionary*)nko_authDictionary;

@end
