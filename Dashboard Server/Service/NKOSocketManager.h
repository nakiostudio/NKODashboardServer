//
//  NKOSocketManager.h
//  Dashboard Server
//
//  Created by Carlos Vidal Pallín on 28/02/2014.
//  Copyright (c) 2014 nakioStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKOSocketManager : NSObject

+ (instancetype)sharedManager;
- (void)startServer;

@end
