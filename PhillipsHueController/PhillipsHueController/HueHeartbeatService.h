//
//  HueHeartbeatService.h
//  PhillipsHueController
//
//  Created by aono_taketoshi on 2014/12/19.
//  Copyright (c) 2014年 aono_taketoshi. All rights reserved.
//

#import <HueSDK_iOS/HueSDK.h>
#import <Foundation/Foundation.h>
#import "HueConnectionService.h"

@interface HueHeartbeatService : NSObject
@property(weak, nonatomic) PHHueSDK* phHueSdk;
@property(weak, nonatomic) HueConnectionService* hueConnectionService;
- (id) init:(PHHueSDK*) phHueSdk hueConnectionService:(HueConnectionService*) hueConService;
- (void) start:(void (^)())beforeSearchBridge successHandler:(void (^)(NSDictionary* bridgesFound))successHandler failedHandler:(void (^)())failed;
@end
