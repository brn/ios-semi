//
//  AppDelegate.h
//  ios-test
//
//  Created by aono_taketoshi on 2014/12/05.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HueSDK_iOS/HueSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) PHHueSDK *hueSdk;

@end

