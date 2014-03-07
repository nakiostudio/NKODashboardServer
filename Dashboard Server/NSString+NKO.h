//
//  NSString+NKO.h
//  Dashboard Server
//
//  Created by Carlos Vidal on 07/03/2014.
//  Copyright (c) 2014 nakioStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NKO)

- (NSString *)nko_md5;
+ (NSString*)nko_hmacsha1:(NSString *)data secret:(NSString *)key;

@end
