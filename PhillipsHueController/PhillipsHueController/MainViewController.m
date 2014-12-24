//
//  MainViewController.m
//  PhillipsHueController
//
//  Created by 青野 健利 on 2014/12/22.
//  Copyright (c) 2014年 青野 健利. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "LoadingViewController.h"
#import "ConnectionListTableViewController.h"
#import "PushlinkViewController.h"

static NSString* const kNoConnectionMessage = @"Connection not found.";
static NSString* const kNoAuthentificationMessage = @"Authentification failed.";
static NSString* const kNoLocalBridgeKnownMessage = @"Bridges not found.";
static NSString* const kAuthentificationFailedMessage = @"Push link authentification failed.";
static NSString* const kButtonNotPressedMessage = @"Pushlink button is not pressed, try again.";
static const int kMaxHue = 65535;

@interface MainViewController ()
@property(strong, nonatomic) HueHeartbeatService* hueHeartbeatService;
@property(strong, nonatomic) HueNotificationService* hueNotificationService;
@property(strong, nonatomic) LoadingViewController* loadingView;
@property(strong, nonatomic) ConnectionListTableViewController* connectionListTableViewController;
@property(strong, nonatomic) UINavigationController* connectionViewNav;
@property(strong, nonatomic) HueConnectionService* hueConnectionService;
@property(strong, nonatomic) PushlinkViewController* pushlinkViewController;
@end

@implementation MainViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    AppDelegate* delegate = APP_DELEGATE;
    self.hueHeartbeatService = [delegate hueHeartbeatService];
    
    __block __weak MainViewController* _self = self;
    self.loadingView = [[LoadingViewController alloc] initWithNibName:@"LoadingViewController" bundle:nil retryHandler:^void{[_self connect:YES];} cacelHandler:^void{[_self.loadingView hide];} findNewConHandler:^{[_self connect:NO];}];
    self.connectionListTableViewController = [[ConnectionListTableViewController alloc] initWithNibName:@"ConnectionListTableViewController" bundle:nil];
    self.pushlinkViewController = [[PushlinkViewController alloc] initWithNibName:@"PushlinkViewController" bundle:nil];
    self.connectionViewNav =
        [[UINavigationController alloc] initWithRootViewController:self.connectionListTableViewController];
    self.hueNotificationService = [delegate hueNotificationService];
    self.hueConnectionService = delegate.hueConnectionService;
        
    if (SYSTEM_VERSION_LESS_THAN(@"7")) {
      self.loadingView.modalPresentationStyle = UIModalPresentationCurrentContext;
    } else {
      self.loadingView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    
    [self.hueNotificationService localConnection:self selector:@selector(localConnected)];
    [self.hueNotificationService noLocalConnection:self selector:@selector(noLocalConnection)];
    [self.hueNotificationService noAuthentification:self selector:@selector(noAuthentification)];
    [self.hueNotificationService pushLinkLocalAuthentificationFailed:self selector:@selector(authentificationFailed)];
    [self.hueNotificationService pushLinkNoLocalBridge:self selector:@selector(noLocalBridgeKnown)];
    [self.hueNotificationService pushLinkNoLocalConnection:self selector:@selector(noLocalConnection)];
    [self.hueNotificationService pushLinkButtonNotPressed:self selector:@selector(buttonNotPressed)];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  static dispatch_once_t onceFlag;
  dispatch_once(&onceFlag, ^{
      AppDelegate* delegate = APP_DELEGATE;
      [delegate.phHueSdk startUpSDK];
      [self connect:YES];
    });
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)localConnected {
  [self.loadingView hide];
}

- (void)noLocalConnection {
  [self.hueHeartbeatService stop];
  [self showLoading:^{
      [self.loadingView showAlert:kNoConnectionMessage];
    }];
}

- (void)noAuthentification {
  [self.loadingView hide];
  [self showPushlink];
}

- (void)noLocalBridgeKnown {
  [self.hueHeartbeatService stop];
  [self showLoading:^{
      [self.loadingView showAlert:kNoLocalBridgeKnownMessage];
    }];
}

- (void)authentificationFailed {
  [self.hueHeartbeatService stop];
  [self showLoading:^{
      [self.loadingView showAlert:kAuthentificationFailedMessage];
    }];
}

- (void)buttonNotPressed {
  [self showLoading:^{
      [self.loadingView showAlert:kButtonNotPressedMessage];
    }];
}

- (void)authentificationSuccess {
  [self.loadingView hide];
}

- (void)connect:(BOOL)useCache {
  [self.hueHeartbeatService start:^{
      [self showLoading:nil];
    } successHandler:^(NSDictionary* foundBridge) {
      [self.loadingView hide];
      self.connectionListTableViewController.dataSource = foundBridge;
      __block __weak MainViewController* _self = self;
      self.connectionListTableViewController.selectedHandler = ^(NSIndexPath* path){
        NSArray* keys = foundBridge.allKeys;
        NSString* key = keys[(NSUInteger)path.row];
        [_self.hueConnectionService connectToSpecificIpAndMacAddr:[foundBridge objectForKey:key] macAddress:key];
      };
      [self presentViewController:self.connectionViewNav animated:YES completion:nil];
    } failedHandler:^{
      [self.loadingView showAlert:kNoConnectionMessage];
    } useCache:useCache];
}

- (void)showLoading:(void(^)())completionHandler {
  [self.pushlinkViewController hide];
  if (!self.loadingView.shown) {
    [self presentViewController:self.loadingView animated:YES completion:completionHandler];
  } else if (completionHandler) {
    completionHandler();
  }
}


- (void)showPushlink {
  [self.loadingView hide];
  if (!self.pushlinkViewController.shown) {
    [self presentViewController:self.pushlinkViewController animated:YES completion:nil];
  }
}


/*
  #pragma mark - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
  }
*/

- (IBAction)randomize:(id)sender {
  PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];
  PHBridgeSendAPI *bridgeSendApi = [[PHBridgeSendAPI alloc] init];
    
  if ([cache.lights.allValues count] == 0) {
    [self noLocalConnection];
    return;
  }
    
  for (PHLight *light in cache.lights.allValues) {
    PHLightState *lightState = [[PHLightState alloc] init];
    [lightState setHue:[NSNumber numberWithInt:arc4random() % kMaxHue]];
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
