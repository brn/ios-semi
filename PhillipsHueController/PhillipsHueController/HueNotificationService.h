//
//  HueNotificationService.h
//  PhillipsHueController
//
//  Created by aono_taketoshi on 2014/12/19.
//  Copyright (c) 2014年 aono_taketoshi. All rights reserved.
//

#import <HueSDK_iOS/HueSDK.h>
#import <Foundation/Foundation.h>

@interface HueNotificationService : NSObject
@property(strong, nonatomic) PHNotificationManager* phNotificationManager;
- (id) init;
- (void) register:(id)target selector:(SEL)selector forNotification:(NSString*)notif;
- (void) deregisterAll:(id)target;
@end
