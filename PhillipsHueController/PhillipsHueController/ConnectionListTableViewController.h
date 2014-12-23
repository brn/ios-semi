//
//  ConnectionListTableViewController.h
//  PhillipsHueController
//
//  Created by 青野 健利 on 2014/12/23.
//  Copyright (c) 2014年 青野 健利. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectionListTableViewController : UITableViewController
@property(strong, nonatomic) NSDictionary* dataSource;
@property(strong, nonatomic) void(^selectedHandler)();
@end
