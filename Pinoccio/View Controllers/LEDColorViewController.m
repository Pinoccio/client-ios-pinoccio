//
//  LEDColorViewController.m
//  Pinoccio
//
//  Created by Haifisch on 6/8/14.
//  Copyright (c) 2014 Haifisch. All rights reserved.
//

#import "LEDColorViewController.h"

@interface LEDColorViewController ()

@end

@implementation LEDColorViewController

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
    self.title = @"Set RGB";
    UIBarButtonItem *setItem = [[UIBarButtonItem alloc] initWithTitle:@"Set" style:UIBarButtonItemStyleDone target:self action:@selector(setColor)];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setColor{
    NSURL *urlString = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.pinocc.io/v1/1/%@/command/led.on?token=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"globalToken"]]];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Running...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}
- (IBAction)rgbChanged:(id)sender {
    UIView *preview = [self.view viewWithTag:8];
    preview.backgroundColor = [UIColor colorWithRed:[(UISlider*)[self.view viewWithTag:5] value]/255 green:[(UISlider*)[self.view viewWithTag:6] value]/255 blue:[(UISlider*)[self.view viewWithTag:7] value]/255 alpha:1];
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
