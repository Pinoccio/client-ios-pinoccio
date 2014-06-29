//
//  ZendeskDropbox.h
//  ZendeskDropbox
//
//  Created by Graham Cruse on 10/08/2012.
//  Copyright (c) 2012 Zendesk All rights reserved.
//

#import <Foundation/Foundation.h>


@class ZendeskDropbox;



// Error codes
enum {
	ZDErrorMissingSubject =				-610001,
	ZDErrorMissingDescription =			-610002,
	ZDErrorMissingEmail =				-610003,
};



@protocol ZendeskDropboxDelegate <NSObject>

@optional
// Sent when the ticket is submitted to Zendesk server successfully
- (void) submissionDidFinishLoading:(ZendeskDropbox *)connection;

// Sent when ticket submission failed
- (void) submission:(ZendeskDropbox *)connection didFailWithError:(NSError *)error;

// Sent when connected to Zendesk server
- (void) submissionConnectedToServer:(ZendeskDropbox *)connection;

@end



/*
    Three steps to submit a ticket to Zendesk:
 
    1.  define a key 'ZDURL' in your application's plist with your Zendesk URL as value, 
        e.g. mysite.zendesk.com.
 
    2.  instantiate the dropbox class:
        ZendeskDropbox *dropbox = [[ZendeskDropbox alloc] initWithDelegate:self];
 
    3.  Submit the request:
        [dropbox submitWithEmail:@"Email..." subject:@"Subject" andDescription:@"Description..."];
*/

@interface ZendeskDropbox : NSObject {
    
	id <ZendeskDropboxDelegate> delegate;
    
    @private
	NSMutableData * receivedData;
	NSString *baseURL;
	NSString *tag;
    NSURLConnection *theConnection;
}

@property (nonatomic, assign) id<ZendeskDropboxDelegate> delegate;

// init with a delegate (may be nil)
- (id) initWithDelegate:(id<ZendeskDropboxDelegate>)theDelegate;

// Submit ticket to Zendesk server (asynchronous).
- (void) submitWithEmail:(NSString*)email subject:(NSString*)subject andDescription:(NSString*)description;

// to cancel a request in progress
- (void) cancelRequest;

@end




