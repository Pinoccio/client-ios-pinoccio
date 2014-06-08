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
    globalScoutDict = [[NSMutableDictionary alloc] init];
    NSURL *urlString = [NSURL URLWithString:[[NSString stringWithFormat:@"https://api.pinocc.io/v1/1/%@/command/print led.isoff?token=%@",self.scoutID,self.token] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    globalScoutDict = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:urlString] options:0 error:nil];
    if ([globalScoutDict[@"data"][@"reply"] integerValue] == 1) {
        [self.toggleSwitch setOn:NO];
    }else {
        [self.toggleSwitch setOn:YES];

    }
    NSLog(@"%@",globalScoutDict[@"data"][@"reply"]);

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

- (IBAction)onoffSwitch:(id)sender {
    NSURL *urlString;
    if ([(UISwitch *)sender isOn]) {
         urlString = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.pinocc.io/v1/1/%@/command/led.on?token=%@",self.scoutID,self.token]];
    }else {
        urlString = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.pinocc.io/v1/1/%@/command/led.off?token=%@",self.scoutID,self.token]];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Running...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        globalScoutDict = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:urlString] options:0 error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
    NSLog(@"%@",globalScoutDict);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
