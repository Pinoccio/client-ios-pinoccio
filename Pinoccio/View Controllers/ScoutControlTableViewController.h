//
//  ScoutControlTableViewController.h
//  Pinoccio
//
//  Created by Haifisch on 6/7/14.
//  Copyright (c) 2014 Haifisch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "AXWireButton.h"
#import "NKOColorPickerView.h"
#import "Globals.h"
#import "ConsoleViewController.h"
#import "ColorSettingsViewController.h"


@interface ScoutControlTableViewController : UITableViewController
@property (strong,nonatomic) NSString *scoutID;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *scoutName;
@property (strong, nonatomic) NSString *troopID;

@property (strong, nonatomic) IBOutlet UILabel *scoutNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *batteryPercent;
@property (strong, nonatomic) IBOutlet UILabel *isLeadScout;
@property (strong, nonatomic) IBOutlet UILabel *temperature;
@property (strong, nonatomic) IBOutlet AXWireButton *setRGBButton;
@property (strong, nonatomic) IBOutlet AXWireButton *openConsole;
@property (strong, nonatomic) IBOutlet AXWireButton *setColor;
@property(nonatomic,assign)id delegate;

@end
