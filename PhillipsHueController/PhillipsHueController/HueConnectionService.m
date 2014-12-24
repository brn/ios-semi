//
//  HueConnectionService.m
//  PhillipsHueController
//
//  Created by aono_taketoshi on 2014/12/19.
//  Copyright (c) 2014年 aono_taketoshi. All rights reserved.
//

#import <HueSDK_iOS/HueSDK.h>
#import "HueConnectionService.h"

@implementation HueConnectionService
- (id) init:(PHHueSDK*)phHueSdk {
  id ret = [super init];
  self.phHueSdk = phHueSdk;
  return ret;
}

// Search brigdges of the Phillips Hue.
// If bridges found, call successHandler, otherwise call failedHandler.
- (void) searchBridge:(void (^)(NSDictionary* bridgesFound))successHandler failedHandler:(void (^)())failed {
  PHBridgeSearching *bridgeSearch = [[PHBridgeSearching alloc] initWithUpnpSearch:YES andPortalSearch:YES andIpAdressSearch:YES];
  [bridgeSearch startSearchWithCompletionHandler:^(NSDictionary *bridgesFound) {

      if (bridgesFound.count > 0) {
        successHandler(bridgesFound);
      } else {
        failed();
      }
    }];
}

// Connect to the Phillips Hue that has given ip address and mac address.
- (void) connectToSpecificIpAndMacAddr:(NSString*)ipAddress macAddress:(NSString*)macAddress {
  [self.phHueSdk setBridgeToUseWithIpAddress:ipAddress macAddress:macAddress];
  [self.phHueSdk startPushlinkAuthentication];
}

@end
