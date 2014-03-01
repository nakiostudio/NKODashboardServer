//
//  NKOAppDiscoverer.h
//  Dashboard Server
//
//  Created by Carlos Vidal on 28/02/2014.
//  Copyright (c) 2014 nakioStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKOAppDiscoverer : NSObject

@property (nonatomic, strong) NSArray *appNames;

- (NSString*)jsonStringForAppAtIndex:(NSUInteger)index;

@end
