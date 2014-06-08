//
//  ScoutControlTableViewController.h
//  Pinoccio
//
//  Created by Haifisch on 6/7/14.
//  Copyright (c) 2014 Haifisch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface ScoutControlTableViewController : UITableViewController
@property (strong,nonatomic) NSString *scoutID;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *scoutName;


@end
