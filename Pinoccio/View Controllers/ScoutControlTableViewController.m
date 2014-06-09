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
    NSURL *urlString = [NSURL URLWithString:[[NSString stringWithFormat:@"https://api.pinocc.io/v1/1/%@/command/print led.isoff?token=%@",self.scoutID,self.token] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if ([NSData dataWithContentsOfURL:urlString] == nil) {
        [[[UIAlertView alloc] initWithTitle:@"Scout" message:@"This scout seems to be unavailable, check back again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        NSURLRequest *request = [NSURLRequest requestWithURL:urlString];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   if (!error){
                                       globalScoutDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                   }
                                   if ([globalScoutDict[@"data"][@"reply"] integerValue] == 1) {
                                       [self.toggleSwitch setOn:NO];
                                   }else {
                                       [self.toggleSwitch setOn:YES];
                                   }
                                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                               }];
    }
}
- (IBAction)onoffSwitch:(id)sender {
    NSURL *urlString;
    if ([(UISwitch *)sender isOn]) {
         urlString = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.pinocc.io/v1/1/%@/command/led.on?token=%@",self.scoutID,self.token]];
    }else {
        urlString = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.pinocc.io/v1/1/%@/command/led.off?token=%@",self.scoutID,self.token]];
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
    NSURL *urlString = [NSURL URLWithString:[[NSString stringWithFormat:@"https://api.pinocc.io/v1/1/%@/command/led.setRGB(%.0f,%.0f,%.0f)?token=%@",self.scoutID,[(UISlider*)[self.view viewWithTag:5]value],[(UISlider*)[self.view viewWithTag:6]value],[(UISlider*)[self.view viewWithTag:7]value],self.token] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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
- (IBAction)rgbChanged:(id)sender {
    UIView *preview = [self.view viewWithTag:8];
    preview.backgroundColor = [UIColor colorWithRed:[(UISlider*)[self.view viewWithTag:5] value]/255 green:[(UISlider*)[self.view viewWithTag:6] value]/255 blue:[(UISlider*)[self.view viewWithTag:7] value]/255 alpha:1];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


@end
