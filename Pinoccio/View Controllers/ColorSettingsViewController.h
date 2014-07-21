//
//  ColorSettingsViewController.h
//  Pinoccio
//
//  Created by Haifisch on 6/29/14.
//  Copyright (c) 2014 Haifisch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKOColorPickerView.h"

@protocol ScoutControllerDelegate <NSObject>
@property (strong, nonatomic) IBOutlet UIColor *previewColor;
-(void)setPreviewColor:(UIColor *)previewColor;
@end

@interface ColorSettingsViewController : UIViewController <ScoutControllerDelegate>
@property(nonatomic,assign)id delegate;

@end
