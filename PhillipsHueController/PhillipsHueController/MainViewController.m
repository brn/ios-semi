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

static NSString* const kNoConnectionMessage = @"Connection not found.";
static NSString* const kNoAuthentificationMessage = @"Authentification failed, check hue configuration.";
static NSString* const kNoLocalBridgeKnownMessage = @"Bridges not found.";
static NSString* const kAuthentificationFailedMessage = @"Push link authentification failed.";

@interface MainViewController ()
@property(weak, nonatomic) HueHeartbeatService* hueHeartbeatService;
@property(weak, nonatomic) HueNotificationService* hueNotificationService;
@property(strong, nonatomic) LoadingViewController* loadingView;
@property(strong, nonatomic) ConnectionListTableViewController* connectionListTableViewController;
@property(strong, nonatomic) UINavigationController* connectionViewNav;
@property(strong, nonatomic) HueConnectionService* hueConnectionService;
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
        self.connectionViewNav =
        [[UINavigationController alloc] initWithRootViewController:self.connectionListTableViewController];
        self.hueNotificationService = [delegate hueNotificationService];
        self.hueConnectionService = delegate.hueConnectionService;
        
        self.loadingView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
        [self.hueNotificationService localConnection:self selector:@selector(localConnected)];
        [self.hueNotificationService noLocalConnection:self selector:@selector(noLocalConnection)];
        [self.hueNotificationService noAuthentification:self selector:@selector(noAuthentification)];
        [self.hueNotificationService pushLinkLocalAuthentificationFailed:self selector:@selector(authentificationFailed)];
        [self.hueNotificationService pushLinkNoLocalBridge:self selector:@selector(noLocalBridgeKnown)];
        [self.hueNotificationService pushLinkNoLocalConnection:self selector:@selector(noLocalConnection)];
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
    [self.hueHeartbeatService stop];
    [self showLoading:^{
        [self.loadingView showAlert:kNoAuthentificationMessage];
    }];
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

- (void)connect:(BOOL)useCache {
    [self.hueHeartbeatService start:^{
        [self showLoading:nil];
    } successHandler:^(NSDictionary* foundBridge) {
        [self.loadingView hide];
        self.connectionListTableViewController.dataSource = foundBridge;
        __block __weak MainViewController* _self = self;
        self.connectionListTableViewController.selectedHandler = ^(NSIndexPath* path){
            NSArray* keys = foundBridge.allKeys;
            NSString* key = keys[path.row];
            [_self.hueConnectionService connectToSpecificIpAndMacAddr:[foundBridge objectForKey:key] macAddress:key];
        };
        [self presentViewController:self.connectionViewNav animated:YES completion:nil];
    } failedHandler:^{
        [self.loadingView showAlert:kNoConnectionMessage];
    } useCache:useCache];
}

- (void)showLoading:(void(^)())completionHandler {
    if (!self.loadingView.shown) {
        [self presentViewController:self.loadingView animated:YES completion:completionHandler];
    } else if (completionHandler) {
        completionHandler();
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

@end
