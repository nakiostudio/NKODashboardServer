//
//  NKOTriggerCommandSocketEvent.h
//  Dashboard Server
//
//  Created by Carlos Vidal on 01/03/2014.
//  Copyright (c) 2014 nakioStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKOTriggerCommandSocketEvent : NSObject

@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) NSString *keyCombination;

+ (instancetype)createFromDictionary:(NSDictionary*)dictionary;

@end
