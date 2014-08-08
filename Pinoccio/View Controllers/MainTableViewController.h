//
//  MainTableViewController.h
//  Pinoccio
//
//  Created by Haifisch on 6/7/14.
//  Copyright (c) 2014 Haifisch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoutListTableViewController.h"
#import "LoginViewController.h"
#import "JNKeychain.h"
#import "MBProgressHUD.h"
#import "Globals.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "UARTPeripheral.h"
#import "UARTViewController.h"

@interface MainTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
- (IBAction)refreshTroops:(id)sender;

@end
