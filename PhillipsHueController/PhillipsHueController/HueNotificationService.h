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
- (void)register:(id)target selector:(SEL)selector forNotification:(NSString*)notif;
- (void)noLocalConnection:(id)target selector:(SEL)sel;
- (void)localConnection:(id)target selector:(SEL)sel;
- (void)noAuthentification:(id)target selector:(SEL)sel;
- (void)noLocalBridgeKnown:(id)target selector:(SEL)sel;
- (void)pushLinkLocalAuthentificationSuccess:(id)target selector:(SEL)sel;
- (void)pushLinkLocalAuthentificationFailed:(id)target selector:(SEL)sel;
- (void)pushLinkNoLocalConnection:(id)target selector:(SEL)sel;
- (void)pushLinkNoLocalBridge:(id)target selector:(SEL)sel;
- (void)pushLinkButtonNotPressed:(id)target selector:(SEL)sel;
- (void)deregister:(id)target forNotification:(NSString*)notif;
- (void)deregisterAll:(id)target;
@end
