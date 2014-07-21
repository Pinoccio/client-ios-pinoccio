//
//  ColorSettingsViewController.m
//  Pinoccio
//
//  Created by Haifisch on 6/29/14.
//  Copyright (c) 2014 Haifisch. All rights reserved.
//

#import "ColorSettingsViewController.h"

@interface ColorSettingsViewController (){
    NKOColorPickerView *colorPicker;

}

@end

@implementation ColorSettingsViewController
@synthesize previewColor;
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
    colorPicker = (NKOColorPickerView*)[self.view viewWithTag:1];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)setcolour:(id)sender{
    [[self delegate] setPreviewColor:colorPicker.color];
    [self dismissViewControllerAnimated:YES completion:nil];
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
