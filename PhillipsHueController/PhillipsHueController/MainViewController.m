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

@interface MainViewController ()

@end

@implementation MainViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    id ret = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    AppDelegate* delegate = APP_DELEGATE;
    self.hueHeartbeatService = [delegate hueHeartbeatService];
    
    __block __weak MainViewController* _self = self;
    self.loadingView = [[LoadingViewController alloc] initWithNibName:@"LoadingViewController" bundle:nil retryHandler:^void{[_self connect];} cacelHandler:^void{[_self.loadingView hide];}];
    self.hueNotificationService = [delegate hueNotificationService];
    
    [self.hueNotificationService localConnection:self selector:@selector(localConnected)];
    [self.hueNotificationService noLocalConnection:self selector:@selector(noLocalConnection)];
    [self.hueNotificationService noAuthentification:self selector:@selector(noAuthentification)];
    return ret;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    static dispatch_once_t onceFlag;
    dispatch_once(&onceFlag, ^{
        [self connect];
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
    [self.loadingView showAlert];
}

- (void)noAuthentification {
}

- (void)connect {
    self.loadingView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self.hueHeartbeatService start:^{
        if (!self.loadingView.shown) {
            [self presentViewController:self.loadingView animated:YES completion:nil];
        }
    } successHandler:^(NSDictionary* dict) {
        [self.loadingView hide];
    } failedHandler:^{
        [self.loadingView showAlert];
    }];
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
