//
//  HueConnectionService.h
//  PhillipsHueController
//
//  Created by aono_taketoshi on 2014/12/19.
//  Copyright (c) 2014年 aono_taketoshi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HueSDK_iOS/HueSDK.h>

@interface HueConnectionService : NSObject
@property(strong, nonatomic) PHHueSDK* phHueSdk;
- (id) init:(PHHueSDK*)phHueSdk;
- (void) searchBridge:(void (^)(NSDictionary* bridgesFound))successHandler failedHandler:(void (^)())failed;
@end
