//
//  LoadingViewController.h
//  PhillipsHueController
//
//  Created by 青野 健利 on 2014/12/22.
//  Copyright (c) 2014年 青野 健利. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingViewController : UIViewController
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
          retryHandler:(void (^)())retryHandler cacelHandler:(void (^)())cancel findNewConHandler:(void(^)())findNewConHandler;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;
@property (weak, nonatomic) IBOutlet UIButton *retryButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *findNewConnectionButton;
@property (nonatomic) BOOL shown;
@property (strong, nonatomic) void (^retryHandler)();
@property (strong, nonatomic) void (^cancelHandler)();
- (IBAction)onRetry:(id)sender;
- (IBAction)onCancel:(id)sender;
- (IBAction)onNewConnection:(id)sender;

- (void)hide;
- (void)showAlert:(const NSString*)message;
@end
