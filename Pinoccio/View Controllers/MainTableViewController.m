//
//  MainTableViewController.m
//  Pinoccio
//
//  Created by Haifisch on 6/7/14.
//  Copyright (c) 2014 Haifisch. All rights reserved.
//

#import "MainTableViewController.h"
#import "UARTPeripheral.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+hex.h"
#import "NSData+hex.h"

#define CONNECTING_TEXT @"Connecting…"
#define DISCONNECTING_TEXT @"Disconnecting…"
#define DISCONNECT_TEXT @"Disconnect"
#define CONNECT_TEXT @"Connect"
@interface MainTableViewController (){
    NSString *globalToken;
    NSMutableDictionary *globalTroopDict;
    NSArray *otherOptions;
   

}

@end

@implementation MainTableViewController

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
    if ([JNKeychain loadValueForKey:@"PinoccioKeychainUsername"] == nil && [JNKeychain loadValueForKey:@"PinoccioKeychainPassword"] == nil) {
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
    }else {
        [self checkLogin:NO];
    }
    
    
    //[self performSegueWithIdentifier:@"submitIssue" sender:self];

}
-(void)checkLogin:(BOOL)loggedOut {
    
    if (globalToken == nil) {
        [self refreshTroops];
    }else {
        [[[UIAlertView alloc] initWithTitle:@"Login invalid!" message:@"Check email and password, then try again" delegate:nil cancelButtonTitle:@"Ok :(" otherButtonTitles:nil, nil] show];
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
    }
    if(loggedOut == YES){
        [[[UIAlertView alloc] initWithTitle:@"Logged out!" message:@"Successfully logged out" delegate:nil cancelButtonTitle:@"Ok :D" otherButtonTitles:nil, nil] show];
        [self performSegueWithIdentifier:@"loginSegue" sender:self];

    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    globalTroopDict = [[NSMutableDictionary alloc] init];
    otherOptions = [NSArray arrayWithObjects:@"Bluetooth console", @"Goto HQ",@"Logout", nil];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)refreshTroops {
    NSString *tempTokenStorage = [self token];
    if (![tempTokenStorage  isEqual:@"None!"]) {
        [[NSUserDefaults standardUserDefaults] setObject:tempTokenStorage forKey:@"globalToken"];
        globalToken = tempTokenStorage;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Getting troops...";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            globalTroopDict = [[self allTroopsFor:globalToken] mutableCopy];
            NSLog(@"Refreshing... %@", globalTroopDict);

            [self.tableView reloadData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
    }
}

-(NSDictionary *)allTroopsFor:(NSString *)token {
    NSURL *urlString = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.pinocc.io/v1/troops?token=%@",token]];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:urlString] options:0 error:nil];
    return  dict;
}
-(NSString *)token {
    
    NSString *post = [NSString stringWithFormat:@"{\"email\":\"%@\",\"password\":\"%@\"}",[JNKeychain loadValueForKey:@"PinoccioKeychainUsername"],[JNKeychain loadValueForKey:@"PinoccioKeychainPassword"]];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://api.pinocc.io/v1/login"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *error;
    
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    if (results != nil && results[@"data"][@"token"] != nil) {
        return results[@"data"][@"token"];
    }else {
        return @"None!";
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return [[globalTroopDict objectForKey:@"data"] count];
    }else {
        return otherOptions.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TroopCell" forIndexPath:indexPath];
        cell.textLabel.text = globalTroopDict[@"data"][indexPath.row][@"name"];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        return cell;

    }else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = otherOptions[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == [otherOptions count] - 1) {
            cell.backgroundColor = [UIColor redColor];
            cell.textLabel.textColor = [UIColor whiteColor];
        }
        
        return  cell;
    }
    // Configure the cell...
    
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 1:
            return @"More Options";
            break;
            
        default:
            return @"Your Troops"; // Replaced with a UIView header on the 0 index
            break;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 1:
            return @"Copyright © Pinoccio 2014";
            break;
            
        default:
            return nil;
            break;
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // Logout
        [JNKeychain deleteValueForKey:@"PinoccioKeychainUsername"];
        [JNKeychain deleteValueForKey:@"PinoccioKeychainPassword"];
        globalToken = nil;
        [self checkLogin:YES];

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 100;
    }else {
        return 20;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
        CGRect frameRect;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            frameRect = CGRectMake(250, 20, 260, 67);
        }else{
            frameRect = CGRectMake(30, 20, 260, 67);
        }
        UIImageView *pinoccioLogo = [[UIImageView alloc] initWithFrame:frameRect];
        pinoccioLogo.image = [UIImage imageNamed:@"pinocciologo"];
        
        [header addSubview:pinoccioLogo];
        return header;
    }else {
        return nil;
    }
    
}
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Logout" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Logout" otherButtonTitles:nil, nil];
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
                [self performSegueWithIdentifier:@"bluetoothConsole" sender:self];
                break;
            case 1:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://hq.pinocc.io"]];
                break;
            case 2:
                [popupQuery showInView:self.view];
                break;
            default:
                break;
        }
    }else if (indexPath.section == 0){
        [self performSegueWithIdentifier:@"gotoScout" sender:self];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier  isEqual: @"gotoScout"]) {
        ScoutListTableViewController *scoutList = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        scoutList.troopID = [[[globalTroopDict objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"id"];
        scoutList.token = globalToken;
    }
}


- (IBAction)refreshTroops:(id)sender {
    [self refreshTroops];
}
@end
