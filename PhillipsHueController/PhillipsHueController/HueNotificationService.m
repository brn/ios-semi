//
//  HueNotificationService.m
//  PhillipsHueController
//
//  Created by aono_taketoshi on 2014/12/19.
//  Copyright (c) 2014年 aono_taketoshi. All rights reserved.
//

#import "HueNotificationService.h"

@implementation HueNotificationService
- (id) init {
  id ret = [super init];
  self.phNotificationManager = [PHNotificationManager defaultManager];
  return ret;
}

- (void) register:(id)target selector:(SEL)selector forNotification:(NSString*)forNotif {
  [self.phNotificationManager registerObject:target withSelector:selector forNotification:forNotif];
}

- (void)noLocalConnection:(id)target selector:(SEL)sel {
    [self register:target selector:sel forNotification:NO_LOCAL_CONNECTION_NOTIFICATION];
}

- (void)localConnection:(id)target selector:(SEL)sel {
    [self register:target selector:sel forNotification:LOCAL_CONNECTION_NOTIFICATION];
}

- (void)noAuthentification:(id)target selector:(SEL)sel {
    [self register:target selector:sel forNotification:NO_LOCAL_AUTHENTICATION_NOTIFICATION];
}

- (void) deregisterAll:(id)target {
  [self.phNotificationManager deregisterObjectForAllNotifications:self];
}
@end
