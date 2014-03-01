//
//  NKOTriggerCommandSocketEvent.m
//  Dashboard Server
//
//  Created by Carlos Vidal on 01/03/2014.
//  Copyright (c) 2014 nakioStudio. All rights reserved.
//

#import "NKOTriggerCommandSocketEvent.h"

@implementation NKOTriggerCommandSocketEvent

+ (instancetype)createFromDictionary:(NSDictionary*)dictionary
{
    NKOTriggerCommandSocketEvent *triggerCommandEvent = [[NKOTriggerCommandSocketEvent alloc] init];
    triggerCommandEvent.appName = dictionary[@"appName"];
    triggerCommandEvent.keyCombination = dictionary[@"command"];
    
    return triggerCommandEvent;
}

@end
