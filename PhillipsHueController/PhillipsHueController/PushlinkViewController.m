//
//  PushlinkViewController.m
//  PhillipsHueController
//
//  Created by aono_taketoshi on 2014/12/24.
//  Copyright (c) 2014年 aono_taketoshi. All rights reserved.
//

#import "PushlinkViewController.h"

@interface PushlinkViewController ()

@end

@implementation PushlinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  self.shown = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  self.shown = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hide {
  [self dismissViewControllerAnimated:YES completion:nil];
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
