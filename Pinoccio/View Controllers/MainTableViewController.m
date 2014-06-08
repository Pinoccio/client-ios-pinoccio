//
//  MainTableViewController.m
//  Pinoccio
//
//  Created by Haifisch on 6/7/14.
//  Copyright (c) 2014 Haifisch. All rights reserved.
//

#import "MainTableViewController.h"

@interface MainTableViewController (){
    NSString *globalToken;
    NSMutableDictionary *globalTroopDict;
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
        [self checkLogin];
    }
}
-(void)checkLogin {
    NSString *tempTokenStorage = [self token];
    if (![tempTokenStorage  isEqual:@"None!"]) {
        globalToken = tempTokenStorage;
    }else {
        [[[UIAlertView alloc] initWithTitle:@"Login invalid!" message:@"Check email and password, then try again" delegate:nil cancelButtonTitle:@"Ok :(" otherButtonTitles:nil, nil] show];
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Getting troops...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        globalTroopDict = [[self allTroopsFor:globalToken] mutableCopy];
        [self.tableView reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    globalTroopDict = [[NSMutableDictionary alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (IBAction)moreActions:(id)sender {
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Title" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Logout" otherButtonTitles:@"Goto HQ", nil];
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:self.view];
}
-(NSDictionary *)allTroopsFor:(NSString *)token {
    NSURL *urlString = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.pinocc.io/v1/troops?token=%@",token]];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:urlString] options:0 error:nil];
    NSLog(@"%@",dict);
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[globalTroopDict objectForKey:@"data"] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TroopCell" forIndexPath:indexPath];
    cell.textLabel.text = globalTroopDict[@"data"][indexPath.row][@"name"];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // Configure the cell...
    
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Your Troops";
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"Copyright © Haifisch 2014";
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // Logout
        [JNKeychain deleteValueForKey:@"PinoccioKeychainUsername"];
        [JNKeychain deleteValueForKey:@"PinoccioKeychainPassword"];
        
        [self checkLogin];

    } else if (buttonIndex == 1) {
        NSLog(@"OPen 1");
    } else if (buttonIndex == 2) {
        NSLog(@"OPen 2");
    }
    
    /**
     * OR use the following switch statement
     * Suggested by Colin =)
     */
    /*
     switch (buttonIndex) {
     case 0:
     self.label.text = @"Destructive Button Clicked";
     break;
     case 1:
     self.label.text = @"Other Button 1 Clicked";
     break;
     case 2:
     self.label.text = @"Other Button 2 Clicked";
     break;
     case 3:
     self.label.text = @"Cancel Button Clicked";
     break;
     }
     */
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Dest: %@", [segue identifier]);
    if ([segue.identifier  isEqual: @"scoutListSegue"]) {
        ScoutListTableViewController *scoutList = [segue destinationViewController];
        UITableViewCell *selectedCell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:selectedCell];
        scoutList.troopID = [[[globalTroopDict objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"token"];
        scoutList.token = globalToken;
    }
}


@end
