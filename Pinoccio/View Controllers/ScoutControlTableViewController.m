//
//  ScoutControlTableViewController.m
//  Pinoccio
//
//  Created by Haifisch on 6/7/14.
//  Copyright (c) 2014 Haifisch. All rights reserved.
//

#import "ScoutControlTableViewController.h"
#define previewCell [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]]
@interface ScoutControlTableViewController (){
    NSMutableDictionary *globalScoutDict;
    NKOColorPickerView *colorPicker;
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
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    globalScoutDict = [[NSMutableDictionary alloc] init];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self getInitial];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    colorPicker = (NKOColorPickerView *)[self.view viewWithTag:420];
    self.setRGBButton.highlightStyle = AXWireButtonHighlightStyleFilled;
    self.setRGBButton.borderWidth = 1;
    self.openConsole.highlightStyle = AXWireButtonHighlightStyleFilled;
    self.openConsole.borderWidth = 1;
    self.setColor.highlightStyle = AXWireButtonHighlightStyleFilled;
    self.setColor.borderWidth = 1;
    self.title = self.scoutName;
    self.scoutNameLabel.text = self.scoutName;
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
                                               alert = [[UIAlertView alloc] initWithTitle:@"Scout" message:[NSString stringWithFormat:@"This scout seems to be unavailable, check back again later. More info: %@",error] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;

    [previewCell.backgroundColor getRed:&red green:&green blue:&blue alpha:&alpha];
    NSLog(@"%f,%f,%f",red,green,blue);

    if ([(UISwitch *) [self.view viewWithTag:13] isOn]) {
        urlString = [NSURL URLWithString:[[NSString stringWithFormat:@"https://api.pinocc.io/v1/%@/%@/command/led.blink(%.0f,%.0f,%.0f,500,1)?token=%@",self.troopID,self.scoutID,red*225,green*255,blue*255,self.token] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }else {
        urlString = [NSURL URLWithString:[[NSString stringWithFormat:@"https://api.pinocc.io/v1/%@/%@/command/led.setrgb(%.0f,%.0f,%.0f)?token=%@",self.troopID,self.scoutID,red*255,green*255,blue*255,self.token] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Running...";
    NSURLRequest *request = [NSURLRequest requestWithURL:urlString];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (!error){
                                   globalScoutDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                   [self performSelectorInBackground:@selector(getInitial) withObject:nil];
                               }
                               [MBProgressHUD hideHUDForView:self.view animated:YES];
                           }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"consoleSegue"]) {
        ConsoleViewController *destController = [segue destinationViewController];
        destController.token = self.token;
        destController.troopID = self.troopID;
        destController.scoutID = self.scoutID;
    }else if ([segue.identifier isEqual:@"colorSettingsSegue"]){
        ColorSettingsViewController *colorSettings = [segue destinationViewController];
        colorSettings.delegate = self;
    }
    
    // Pass the selected object to the new view controller.
}
-(void)setPreviewColor:(UIColor *)previewColor {
    previewCell.backgroundColor = previewColor;
}

@end
