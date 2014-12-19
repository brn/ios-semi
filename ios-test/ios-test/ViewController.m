//
//  ViewController.m
//  ios-test
//
//  Created by aono_taketoshi on 2014/12/05.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <HueSDK_iOS/HueSDK.h>

#define MAX_HUE 65535

@implementation ViewController

- (id) init {
  id ret = [super init];
  return ret;
}

- (IBAction)onClick:(id)sender {
  [self randomColor];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
  self.simpleButton.hidden = TRUE;
  self.indicator.hidden = FALSE;
  self.stateText.hidden = TRUE;
  [super viewWillAppear:YES];
  [self.indicator startAnimating];
  PHNotificationManager *notificationManager = [PHNotificationManager defaultManager];
    
  [notificationManager registerObject:self withSelector:@selector(localConnection) forNotification:LOCAL_CONNECTION_NOTIFICATION];
  [notificationManager registerObject:self withSelector:@selector(noLocalConnection) forNotification:NO_LOCAL_CONNECTION_NOTIFICATION];
  [notificationManager registerObject:self withSelector:@selector(noLocalConnection) forNotification:NO_LOCAL_AUTHENTICATION_NOTIFICATION];
    
  [self searchConnection];
}

- (void)localConnection {
  self.stateText.text = @"connected!";
}

- (void)noLocalConnection {
  self.stateText.text = @"not connected!";
}


- (void)authentificated {
  self.stateText.text = @"authentificated!";
}

- (void)noAuthentificated {
  self.stateText.text = @"not authentificated!";
}


- (void)noLocalBridge {
  self.stateText.text = @"not local bridge";
}


- (void) searchConnection {
  //[self.hueSdk enableLocalConnection];
  PHBridgeSearching *bridgeSearch = [[PHBridgeSearching alloc] initWithUpnpSearch:YES andPortalSearch:YES andIpAdressSearch:YES];
  [bridgeSearch startSearchWithCompletionHandler:^(NSDictionary *bridgesFound) {

      if (bridgesFound.count > 0) {
        AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
        NSArray *sortedKeys = [bridgesFound.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        NSString *macAddress = [sortedKeys objectAtIndex:0];
        NSString *ipAddress = [bridgesFound objectForKey:macAddress];
    
        [delegate.hueSdk setBridgeToUseWithIpAddress:ipAddress macAddress:macAddress];
        [self localConnection];
        [delegate.hueSdk enableLocalConnection];
        [self authentification:delegate.hueSdk];
      } else {
        /***************************************************
             No bridge was found was found. Tell the user and offer to retry..
        *****************************************************/
            
        // No bridges were found, show this to the user
        //[self showNoBridgesFoundDialog];
        [self noLocalConnection];
      }

      self.simpleButton.hidden = FALSE;
      self.indicator.hidden = TRUE;
      self.stateText.hidden = FALSE;
    }];
}

- (void) authentification:(PHHueSDK*) sdk {
  /***************************************************
     Set up the notifications for push linkng
  *****************************************************/

  // Register for notifications about pushlinking
  PHNotificationManager *phNotificationMgr = [PHNotificationManager defaultManager];
  
    
  [phNotificationMgr registerObject:self withSelector:@selector(authenticationSuccess) forNotification:PUSHLINK_LOCAL_AUTHENTICATION_SUCCESS_NOTIFICATION];
  [phNotificationMgr registerObject:self withSelector:@selector(authenticationFailed) forNotification:PUSHLINK_LOCAL_AUTHENTICATION_FAILED_NOTIFICATION];
  [phNotificationMgr registerObject:self withSelector:@selector(noLocalConnection) forNotification:PUSHLINK_NO_LOCAL_CONNECTION_NOTIFICATION];
  [phNotificationMgr registerObject:self withSelector:@selector(noLocalBridge) forNotification:PUSHLINK_NO_LOCAL_BRIDGE_KNOWN_NOTIFICATION];
    
  // Call to the hue SDK to start pushlinking process
  /***************************************************
     Call the SDK to start Push linking.
     The notifications sent by the SDK will confirm success 
     or failure of push linking
  *****************************************************/

  [sdk startPushlinkAuthentication];
}


- (void)authenticationSuccess {
    /***************************************************
     The notification PUSHLINK_LOCAL_AUTHENTICATION_SUCCESS_NOTIFICATION
     was received. We have confirmed the bridge.
     De-register for notifications and call
     pushLinkSuccess on the delegate
     *****************************************************/
    // Deregister for all notifications
    [[PHNotificationManager defaultManager] deregisterObjectForAllNotifications:self];
    
    [self authentificated];
}


/**
 Notification receiver which is called when the pushlinking failed because the time limit was reached
 */
- (void)authenticationFailed {
    // Deregister for all notifications
    [[PHNotificationManager defaultManager] deregisterObjectForAllNotifications:self];
    
    [self noAuthentificated];
}

- (void)randomColor {
  PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];
  PHBridgeSendAPI *bridgeSendApi = [[PHBridgeSendAPI alloc] init];
    
  if ([cache.lights.allValues count] == 0) {
    NSLog(@"NO Light enabled.");
    return;
  }
    
  for (PHLight *light in cache.lights.allValues) {
    PHLightState *lightState = [[PHLightState alloc] init];
    [lightState setHue:[NSNumber numberWithInt:arc4random() % MAX_HUE]];
    [lightState setBrightness:[NSNumber numberWithInt:254]];
    [lightState setSaturation:[NSNumber numberWithInt:254]];
        
    [bridgeSendApi updateLightStateForId:light.identifier withLightState:lightState completionHandler:^(NSArray *errors) {
        if (errors != nil) {
          NSString *message = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Errors", @""), errors != nil? errors: NSLocalizedString(@"none", @"")];
          NSLog(@"Response: %@", message);
        }
      }];
  }
}

@end
