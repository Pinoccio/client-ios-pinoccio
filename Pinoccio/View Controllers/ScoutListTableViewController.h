//
//  ScoutListTableViewController.h
//  Pinoccio
//
//  Created by Haifisch on 6/7/14.
//  Copyright (c) 2014 Haifisch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoutControlTableViewController.h"
#import "MBProgressHUD.h"
@interface ScoutListTableViewController : UITableViewController
@property (strong, nonatomic) NSString *troopID;
@property (strong, nonatomic) NSString *token;

@end
