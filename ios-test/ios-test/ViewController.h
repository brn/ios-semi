//
//  ViewController.h
//  ios-test
//
//  Created by aono_taketoshi on 2014/12/05.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <HueSDK_iOS/HueSDK.h>
#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (nonatomic) BOOL initialized;
@property (weak, nonatomic) PHHueSDK *hueSdk;
@property (weak, nonatomic) IBOutlet UIButton *simpleButton;
@property (weak, nonatomic) IBOutlet UILabel *stateText;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end
