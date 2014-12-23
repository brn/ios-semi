//
//  LoadingViewController.m
//  PhillipsHueController
//
//  Created by 青野 健利 on 2014/12/22.
//  Copyright (c) 2014年 青野 健利. All rights reserved.
//

#import <HueSDK_iOS/HueSDK.h>
#import "LoadingViewController.h"

@interface LoadingViewController ()
@property(strong, nonatomic) void (^findNewConHandler)();
@end

@implementation LoadingViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil retryHandler:(void (^)())retryHandler cacelHandler:(void (^)())cancel findNewConHandler:(void(^)())findNewConHandler {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.retryHandler = retryHandler;
        self.cancelHandler = cancel;
        self.findNewConHandler = findNewConHandler;
        self.shown = NO;
        self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self changeStateToLoading];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.indicator startAnimating];
    self.shown = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.indicator stopAnimating];
    self.shown = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onRetry:(id)sender {
    [self changeStateToLoading];
    self.retryHandler();
}

- (IBAction)onCancel:(id)sender {
    [self changeStateToLoading];
    self.cancelHandler();
}

- (void)onNewConnection:(id)sender {
    [self changeStateToLoading];
    self.findNewConHandler();
}

- (void)hide {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showAlert:(NSString*)message {
    [self changeStateToAlert:message];
}

- (void)changeStateToLoading {
    self.indicator.hidden = NO;
    self.alertLabel.hidden = NO;
    self.retryButton.hidden = YES;
    self.cancelButton.hidden = YES;
    self.findNewConnectionButton.hidden = YES;
    self.alertLabel.text = @"Now connecting...";
}

- (void)changeStateToAlert:(const NSString*)message {
    self.indicator.hidden = YES;
    self.alertLabel.hidden = NO;
    self.retryButton.hidden = NO;
    self.cancelButton.hidden = NO;
    self.findNewConnectionButton.hidden = NO;
    self.alertLabel.text = message;
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
