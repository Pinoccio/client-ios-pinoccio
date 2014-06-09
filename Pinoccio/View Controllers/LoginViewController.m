//
//  LoginViewController.m
//  Pinoccio
//
//  Created by Haifisch on 6/7/14.
//  Copyright (c) 2014 Haifisch. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    [(UITextField*)[self.view viewWithTag:1] setDelegate:self];
    [(UITextField*)[self.view viewWithTag:2] setDelegate:self];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)login:(id)sender {
    [JNKeychain saveValue:[(UITextField*)[self.view viewWithTag:1] text] forKey:@"PinoccioKeychainUsername"];
    [JNKeychain saveValue:[(UITextField*)[self.view viewWithTag:2] text] forKey:@"PinoccioKeychainPassword"];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField tag] == 1) {
        [(UITextField*)[self.view viewWithTag:2] becomeFirstResponder];
    }else if ([textField tag] == 2){
        [(UITextField*)[self.view viewWithTag:2] resignFirstResponder];
        [self login:nil];
    }
    return YES;
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
