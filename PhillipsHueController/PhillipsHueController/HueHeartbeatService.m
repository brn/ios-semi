//
//  HueHeartbeatService.m
//  PhillipsHueController
//
//  Created by aono_taketoshi on 2014/12/19.
//  Copyright (c) 2014年 aono_taketoshi. All rights reserved.
//

#import <HueSDK_iOS/HueSDK.h>
#import "HueHeartbeatService.h"

@implementation HueHeartbeatService
- (id) init:(PHHueSDK*) phHueSdk hueConnectionService:(HueConnectionService*) hueConService {
  id ret = [super init];
  self.phHueSdk = phHueSdk;
  self.hueConnectionService = hueConService;
  return ret;
}

- (void) start:(void (^)())beforeSearchBridge successHandler:(void (^)(NSDictionary* bridgesFound))successHandler failedHandler:(void (^)())failed useCache:(BOOL)useCache {
  PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];
  if (useCache && cache != nil && cache.bridgeConfiguration != nil && cache.bridgeConfiguration.ipaddress != nil) {
    //
    //[self showLoadingViewWithText:NSLocalizedString(@"Connecting...", @"Connecting text")];
        
    // Enable heartbeat with interval of 10 seconds
    [self.phHueSdk enableLocalConnection];
  } else {
    // Automaticly start searching for bridges
    //[self searchForBridgeLocal];
    beforeSearchBridge();
    [self.hueConnectionService searchBridge:successHandler failedHandler:failed];
  }
}

-(void) stop{
  [self.phHueSdk disableLocalConnection];
}
@end
