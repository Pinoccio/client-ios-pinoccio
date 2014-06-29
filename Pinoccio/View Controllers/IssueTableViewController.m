//
//  IssueTableViewController.m
//  Pinoccio
//
//  Created by Haifisch on 6/20/14.
//  Copyright (c) 2014 Haifisch. All rights reserved.
//

#import "IssueTableViewController.h"

@interface IssueTableViewController ()

@end

@implementation IssueTableViewController

- (id)initWithStyle:(UITableViewStyle)style
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
// Sent when the ticket is submitted to Zendesk server successfully
- (void) submissionDidFinishLoading:(ZendeskDropbox *)connection {
    [[[UIAlertView alloc] initWithTitle:@"Success!" message:@"Thanks for submitting an issue, we'll get back to you soon." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}

// Sent when ticket submission failed
- (void) submission:(ZendeskDropbox *)connection didFailWithError:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:@"Submission failed!" message:@"Looks like something went wrong! Try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([(UITextField *)[self.view viewWithTag:1] isFirstResponder]) {
        [(UITextField *)[self.view viewWithTag:2] becomeFirstResponder];
    }else if ([(UITextField *)[self.view viewWithTag:2] isFirstResponder]) {
        [(UITextView *)[self.view viewWithTag:3] becomeFirstResponder];
    }else if ([(UITextView *)[self.view viewWithTag:3] isFirstResponder]) {
        [(UITextView *)[self.view viewWithTag:3] resignFirstResponder];
    }
    return YES;
}
-(void)submitIssue {
    ZendeskDropbox *dropbox = [[ZendeskDropbox alloc] initWithDelegate:self];
    NSLog(@"Textfield 1: %lu\nTextfield 2: %lu", (unsigned long)[(UITextField *)[self.view viewWithTag:1] text].length, (unsigned long)[(UITextField *)[self.view viewWithTag:2] text].length);
    if ([(UITextField *)[self.view viewWithTag:1] text].length > 0 && [(UITextField *)[self.view viewWithTag:2] text].length > 0 && [(UITextView *)[self.view viewWithTag:3] text].length > 0) {
        [dropbox submitWithEmail:[(UITextField *)[self.view viewWithTag:1] text] subject:[(UITextField *)[self.view viewWithTag:2] text] andDescription:[(UITextView *)[self.view viewWithTag:3] text]];
    }else {
        [[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"All the fields are required, please recheck your submission" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 3:
            [self submitIssue];
            break;
            
        default:
            break;
    }
}
@end
