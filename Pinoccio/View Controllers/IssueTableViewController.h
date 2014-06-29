//
//  IssueTableViewController.h
//  Pinoccio
//
//  Created by Haifisch on 6/20/14.
//  Copyright (c) 2014 Haifisch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZendeskDropbox.h"
@interface IssueTableViewController : UITableViewController <ZendeskDropboxDelegate, UITextFieldDelegate, UITextViewDelegate>

@end
