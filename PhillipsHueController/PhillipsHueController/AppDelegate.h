//
//  AppDelegate.h
//  PhillipsHueController
//
//  Created by aono_taketoshi on 2014/12/19.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HueHeartbeatService.h"
#import "HueNotificationService.h"
#import "LoadingViewController.h"

#define APP_DELEGATE (AppDelegate*)[[UIApplication sharedApplication] delegate];
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] \
compare:v options:NSNumericSearch] == NSOrderedAscending)


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PHHueSDK* phHueSdk;
@property (strong, nonatomic) HueHeartbeatService* hueHeartbeatService;
@property (strong, nonatomic) HueConnectionService* hueConnectionService;
@property (strong, nonatomic) HueNotificationService* hueNotificationService;
@end
