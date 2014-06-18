//
//  ScoutControlTableViewController.m
//  Pinoccio
//
//  Created by Haifisch on 6/7/14.
//  Copyright (c) 2014 Haifisch. All rights reserved.
//

#import "ScoutControlTableViewController.h"

@interface ScoutControlTableViewController (){
    NSMutableDictionary *globalScoutDict;
}
@property (strong, nonatomic) IBOutlet UISwitch *toggleSwitch;

@end

@implementation ScoutControlTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.setRGBButton.highlightStyle = AXWireButtonHighlightStyleFilled;
    self.setRGBButton.borderWidth = 1;
    self.title = self.scoutName;
    self.scoutNameLabel.text = self.scoutName;
    globalScoutDict = [[NSMutableDictionary alloc] init];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self getInitial];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getInitial{
    NSURL *urlString;
    __block UIAlertView *alert;
    if (![(UISwitch *) [self.view viewWithTag:13] isOn]) {
        urlString = [NSURL URLWithString:[[NSString stringWithFormat:@"https://api.pinocc.io/v1/%@/%@/command/print led.isoff?token=%@",self.troopID,self.scoutID,self.token] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:urlString]
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   if (!error){
                                       globalScoutDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                       if(debug)NSLog(@"Scout control Dictionary: %@", globalScoutDict);

                                       if (globalScoutDict[@"error"] == nil) {
                                           if ([globalScoutDict[@"data"][@"reply"] integerValue] == 1) {
                                               [self.toggleSwitch setOn:NO];
                                               [self setEverythingOff];
                                           }else {
                                               [self.toggleSwitch setOn:YES];
                                           }
                                       }else {
                                           if (alert == nil) {
                                               alert = [[UIAlertView alloc] initWithTitle:@"Scout" message:@"This scout seems to be unavailable, check back again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                               [alert show];
                                           }
                                           
                                           [self.navigationController popViewControllerAnimated:YES];
                                       }
                                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                                   }else {
                                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                                       if (alert == nil) {
                                           alert = [[UIAlertView alloc] initWithTitle:@"Scout" message:@"This scout seems to be unavailable, check back again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                           [alert show];
                                       }
                                       [self.navigationController popViewControllerAnimated:YES];

                                   }
                               }];

    }else {
        [self.toggleSwitch setOn:YES];
    }
        urlString = [NSURL URLWithString:[[NSString stringWithFormat:@"https://api.pinocc.io/v1/%@/%@/command/print power.percent?token=%@",self.troopID,self.scoutID,self.token] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:urlString]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (!error){
                                   globalScoutDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                   if (globalScoutDict[@"error"] == nil) {
                                       self.batteryPercent.text = [NSString stringWithFormat:@"%ld%%", (long)[globalScoutDict[@"data"][@"reply"] integerValue]];
                                   }else {
                                       if (alert == nil) {
                                           alert = [[UIAlertView alloc] initWithTitle:@"Scout" message:@"This scout seems to be unavailable, check back again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                           [alert show];
                                       }
                                       [self.navigationController popViewControllerAnimated:YES];
                                   }
                                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                               }else {
                                   if (alert == nil) {
                                       alert = [[UIAlertView alloc] initWithTitle:@"Scout" message:@"This scout seems to be unavailable, check back again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                       [alert show];
                                   }
                                   [self.navigationController popViewControllerAnimated:YES];

                               }
                           }];
    urlString = [NSURL URLWithString:[[NSString stringWithFormat:@"https://api.pinocc.io/v1/%@/%@/command/print scout.isleadscout?token=%@",self.troopID,self.scoutID,self.token] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:urlString]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (!error){
                                   globalScoutDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                   if (globalScoutDict[@"error"] == nil) {
                                       switch ([globalScoutDict[@"data"][@"reply"] integerValue]) {
                                           case 0:
                                               self.isLeadScout.text = @"No";
                                               break;
                                               
                                           default:
                                               self.isLeadScout.text = @"Yes";
                                               break;
                                       }
                                   }else {
                                       if (alert == nil) {
                                           alert = [[UIAlertView alloc] initWithTitle:@"Scout" message:@"This scout seems to be unavailable, check back again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                           [alert show];
                                       }
                                       [self.navigationController popViewControllerAnimated:YES];
                                   }
                                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                               }else {
                                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                                   if (alert == nil) {
                                       alert = [[UIAlertView alloc] initWithTitle:@"Scout" message:@"This scout seems to be unavailable, check back again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                       [alert show];
                                   }
                                   [self.navigationController popViewControllerAnimated:YES];

                               }
                           }];
    __block NSString *temperature;
    urlString = [NSURL URLWithString:[[NSString stringWithFormat:@"https://api.pinocc.io/v1/%@/%@/command/print temperature.f?token=%@",self.troopID,self.scoutID,self.token] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:urlString]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (!error){
                                   globalScoutDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                   if (globalScoutDict[@"error"] == nil) {
                                       temperature = [NSString stringWithFormat:@"%ld°F", (long)[globalScoutDict[@"data"][@"reply"] integerValue]];

                                   }else {
                                       if (alert == nil) {
                                           alert = [[UIAlertView alloc] initWithTitle:@"Scout" message:@"This scout seems to be unavailable, check back again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                           [alert show];
                                       }
                                       [self.navigationController popViewControllerAnimated:YES];
                                   }
                                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                               }else {
                                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                                   if (alert == nil) {
                                       alert = [[UIAlertView alloc] initWithTitle:@"Scout" message:@"This scout seems to be unavailable, check back again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                       [alert show];
                                   }
                                   [self.navigationController popViewControllerAnimated:YES];
                               }
                           }];
    urlString = [NSURL URLWithString:[[NSString stringWithFormat:@"https://api.pinocc.io/v1/%@/%@/command/print temperature.c?token=%@",self.troopID,self.scoutID,self.token] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:urlString]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (!error){
                                   globalScoutDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                   if (globalScoutDict[@"error"] == nil) {
                                       self.temperature.text = [NSString stringWithFormat:@"%@ / %ld°C", temperature ,(long)[globalScoutDict[@"data"][@"reply"] integerValue]];
                                       
                                   }else {
                                       if (alert == nil) {
                                           alert = [[UIAlertView alloc] initWithTitle:@"Scout" message:@"This scout seems to be unavailable, check back again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                           [alert show];
                                       }
                                       [self.navigationController popViewControllerAnimated:YES];
                                   }
                                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                               }else {
                                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                                   if (alert == nil) {
                                       alert = [[UIAlertView alloc] initWithTitle:@"Scout" message:@"This scout seems to be unavailable, check back again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                       [alert show];
                                   }
                                   [self.navigationController popViewControllerAnimated:YES];
                               }
                           }];
}
-(void)setEverythingOff{
    [(UISlider*)[self.view viewWithTag:5] setValue:0 animated:YES];
    [(UISlider*)[self.view viewWithTag:6] setValue:0 animated:YES];
    [(UISlider*)[self.view viewWithTag:7] setValue:0 animated:YES];
    [(UILabel *) [self.view viewWithTag:9] setText:[NSString stringWithFormat:@"%.0f",[(UISlider*)[self.view viewWithTag:5] value]]];
    [(UILabel *) [self.view viewWithTag:10] setText:[NSString stringWithFormat:@"%.0f",[(UISlider*)[self.view viewWithTag:6] value]]];
    [(UILabel *) [self.view viewWithTag:11] setText:[NSString stringWithFormat:@"%.0f",[(UISlider*)[self.view viewWithTag:7] value]]];
    [(UIView *)[self.view viewWithTag:8]setBackgroundColor:[UIColor blackColor]];
    [(UISwitch *) [self.view viewWithTag:13] setOn:NO animated:YES];
    [(UISwitch *) [self.view viewWithTag:12] setOn:NO animated:YES];

}
- (IBAction)onoffSwitch:(id)sender {
    NSURL *urlString;
    if ([(UISwitch *)sender isOn]) {
         urlString = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.pinocc.io/v1/%@/%@/command/led.on?token=%@",self.troopID,self.scoutID,self.token]];
    }else {
        urlString = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.pinocc.io/v1/%@/%@/command/led.off?token=%@",self.troopID,self.scoutID,self.token]];
        [self setEverythingOff];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Running...";
    NSURLRequest *request = [NSURLRequest requestWithURL:urlString];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (!error){
                                   globalScoutDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                               }
                               [MBProgressHUD hideHUDForView:self.view animated:YES];
                        }];
}
- (IBAction)setRGBColor:(id)sender {
    NSURL *urlString;
    
    if ([(UISwitch *) [self.view viewWithTag:13] isOn]) {
        urlString = [NSURL URLWithString:[[NSString stringWithFormat:@"https://api.pinocc.io/v1/%@/%@/command/led.blink(%.0f,%.0f,%.0f,500,1)?token=%@",self.troopID,self.scoutID,[(UISlider*)[self.view viewWithTag:5]value],[(UISlider*)[self.view viewWithTag:6]value],[(UISlider*)[self.view viewWithTag:7]value],self.token] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }else {
        urlString = [NSURL URLWithString:[[NSString stringWithFormat:@"https://api.pinocc.io/v1/%@/%@/command/led.setrgb(%.0f,%.0f,%.0f)?token=%@",self.troopID,self.scoutID,[(UISlider*)[self.view viewWithTag:5]value],[(UISlider*)[self.view viewWithTag:6]value],[(UISlider*)[self.view viewWithTag:7]value],self.token] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Running...";
    NSURLRequest *request = [NSURLRequest requestWithURL:urlString];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (!error){
                                   globalScoutDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                   NSLog(@"%@",globalScoutDict);
                                   [self performSelectorInBackground:@selector(getInitial) withObject:nil];
                               }
                               [MBProgressHUD hideHUDForView:self.view animated:YES];
                           }];
}
- (IBAction)rgbChanged:(id)sender {
    // I'm in love with this code
    [(UILabel *) [self.view viewWithTag:9] setText:[NSString stringWithFormat:@"%.0f",[(UISlider*)[self.view viewWithTag:5] value]]];
    [(UILabel *) [self.view viewWithTag:10] setText:[NSString stringWithFormat:@"%.0f",[(UISlider*)[self.view viewWithTag:6] value]]];
    [(UILabel *) [self.view viewWithTag:11] setText:[NSString stringWithFormat:@"%.0f",[(UISlider*)[self.view viewWithTag:7] value]]];
    [(UIView *)[self.view viewWithTag:8]setBackgroundColor:[UIColor colorWithRed:[(UISlider*)[self.view viewWithTag:5] value]/255 green:[(UISlider*)[self.view viewWithTag:6] value]/255 blue:[(UISlider*)[self.view viewWithTag:7] value]/255 alpha:1]];
}

@end
