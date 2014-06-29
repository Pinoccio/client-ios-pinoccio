//
//  ConsoleViewController.m
//  Pinoccio
//
//  Created by Haifisch on 6/23/14.
//  Copyright (c) 2014 Haifisch. All rights reserved.
//

#import "ConsoleViewController.h"

@interface ConsoleViewController ()
@property (strong, nonatomic) IBOutlet UITextView *consoleView;
@property (strong, nonatomic) IBOutlet UITextField *consoleInput;

@end

@implementation ConsoleViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [[(UITextField*) self.view viewWithTag:1] becomeFirstResponder];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendCommand:(id)sender {
    NSURL *urlString = [NSURL URLWithString:[[NSString stringWithFormat:@"https://api.pinocc.io/v1/%@/%@/command/%@?token=%@",self.troopID,self.scoutID,self.consoleInput.text,self.token] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Running...";
    NSURLRequest *request = [NSURLRequest requestWithURL:urlString];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (!error){
                                   id datAA = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                   self.consoleView.text = [NSString stringWithFormat:@"%@\n> %@\n%@",self.consoleView.text,self.consoleInput.text,datAA[@"data"][@"output"]];
                                   self.consoleInput.text = @"";
                                   [self.consoleView scrollRangeToVisible:NSMakeRange([self.consoleView.text length], 0)];
                                   [self.consoleView setScrollEnabled:NO];
                                   [self.consoleView setScrollEnabled:YES];
                               }
                               [MBProgressHUD hideHUDForView:self.view animated:YES];
                           }];
}

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
